//
//  ProjectCreateMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import UIKit
import RxSwift
import RxCocoa
import Core
import DSKit

enum ProjectCreateMainNavigation {
    case finish
    case close
}

enum ProjectCreateType {
    case create
    case modify
}

final class ProjectCreateMainViewModel: ViewModel {
    
    private let projectCreateUseCase: ProjectCreateUseCase
    private let projectInfoUseCase: ProjectInfoUseCase
    private let projectModifyUseCase: ProjectModifyUseCase
    
    init(
        projectCreateUseCase: ProjectCreateUseCase,
        projectInfoUseCase: ProjectInfoUseCase,
        projectModifyUseCase: ProjectModifyUseCase,
        type: ProjectCreateType = .create,
        projectId: Int?
    ) {
        self.projectCreateUseCase = projectCreateUseCase
        self.projectInfoUseCase = projectInfoUseCase
        self.projectModifyUseCase = projectModifyUseCase
        self.type = type
        self.modifyTarget = projectId
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let closeButtonTap: Observable<Void>
        let nextButtonTap: Observable<Void>
        let beforeButtonTap: Observable<Void>
        
        let title: Observable<String>
        
        let stateBeforeTap: Observable<Void>
        let stateRunningTap: Observable<Void>
        let onlineTap: Observable<Void>
        let onOfflineTap: Observable<Void>
        let offlineTap: Observable<Void>
        let selectedRegion: Observable<String>
        
        let goalStartUpTap: Observable<Void>
        let goalPortfolioTap: Observable<Void>
        let noRequiredExperienceTap: Observable<Void>
        let selectedMinCareer: Observable<Career>
        let selectedMaxCareer: Observable<Career>
        
        let categoryTap: Observable<String>
        let selectedImage: Observable<[ImageWithName]>
        let deleteImageTap: Observable<ImageWithName>
        
        let addRecruit: Observable<Recruit>
        let minusRecruit: Observable<Recruit>
        let plusRecruit: Observable<Recruit>
        let deleteRecruit: Observable<Recruit>
        let changeCommentRecruit: Observable<(Recruit, String)>
        
        let introduce: Observable<String>
        let leaderPart: Observable<Parts>
        
        let selectedSkillTap: Observable<String>
        let deleteSkillTap: Observable<String>
        
        let createButtonTap: Observable<Void>
        let errorOKTap: Observable<Void>
    }
    
    struct Output {
        let currentPage: Driver<Int>
        let titleCanNextPage: Driver<Bool>
        let stateRegionCanNextPage: Driver<Bool>
        let goalCareerCanNextPage: Driver<Bool>
        let categoryCanNextpage: Driver<Bool>
        let canCreate: Driver<Bool>
        // 지역 리스트
        let regionList: Driver<[String]>
        // 생성 정보
        let projectCreateProps: Driver<ProjectCreateProps>
        // 에러
        let error: PublishSubject<Error>
        let isModify: Observable<Void>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProjectCreateMainNavigation>()
    
    // MARK: - Page
    let currentPage = BehaviorRelay<Int>(value: 0)
    let titleCanNextPage = BehaviorRelay<Bool>(value: false)
    let stateRegionCanNextPage = BehaviorRelay<Bool>(value: false)
    let goalCareerCanNextPage = BehaviorRelay<Bool>(value: false)
    let categoryCanNextpage = BehaviorRelay<Bool>(value: false)
    let canCreate = BehaviorRelay<Bool>(value: false)
    
    // MARK: - 지역정보
    
    let regionList = PublishRelay<[String]>()
    
    // MARK: - 프로젝트 생성 정보
    lazy var projectCreateProps = BehaviorRelay<ProjectCreateProps>(value: ProjectCreateProps())
    
    // MARK: - type(수정하기인 경우 필요)
    
    let type: ProjectCreateType
    let modifyTarget: Int?
    let isModify = PublishRelay<Void>()
    
    // MARK: - Error
    
    let error = PublishSubject<Error>()
    
    func transform(input: Input) -> Output {
        
        switch type {
        case .create:
            transformCreate(input: input)
        case .modify:
            transformModify(input: input)
        }
        
        // Common
        transformNavigation(input: input)
        transformPages(input: input)
        transformError(input: input.errorOKTap)
        transformCanCreate(props: projectCreateProps)
        
        input.viewWillAppear
            .map { KM.shared.getRegion() }
            .bind(to: regionList)
            .disposed(by: disposeBag)
        
        return Output(
            currentPage: currentPage.asDriver(),
            titleCanNextPage: titleCanNextPage.asDriver(),
            stateRegionCanNextPage: stateRegionCanNextPage.asDriver(),
            goalCareerCanNextPage: goalCareerCanNextPage.asDriver(),
            categoryCanNextpage: categoryCanNextpage.asDriver(),
            canCreate: canCreate.asDriver(),
            regionList: regionList.asDriver(onErrorJustReturn: []),
            projectCreateProps: projectCreateProps.asDriver(),
            error: error,
            isModify: isModify.take(1)
        )
    }
    
    // MARK: - Create
    func transformCreate(input: Input) {
        
        transformTitle(title: input.title)
        transformstateRegion(input: input)
        transformGoalCareer(input: input)
        transformCategory(input: input)
        transformPost(input: input)
        transformCreatePost(input: input)
        
        func transformTitle(title: Observable<String>) {
            title
                .withLatestFrom(projectCreateProps) { title, before -> ProjectCreateProps in
                    var props = before
                    props.title = title
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map { $0.title }
                .compactMap { $0 }
                .map { $0.count >= 2 }
                .bind(to: titleCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformstateRegion(input: Input) {
            Observable.merge(
                input.stateBeforeTap.map { ProjectState.before },
                input.stateRunningTap.map { ProjectState.running }
            ).withLatestFrom(projectCreateProps) { state, before -> ProjectCreateProps in
                var props = before
                props.state = state
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            Observable.merge(
                input.onlineTap.map { isOnline.online },
                input.onOfflineTap.map { isOnline.onOffline },
                input.offlineTap.map { isOnline.offline }
            ).withLatestFrom(projectCreateProps) { isOnline, before -> ProjectCreateProps in
                var props = before
                props.isOnline = isOnline
                
                if isOnline == .online {
                    props.region = nil
                }
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            input.selectedRegion
                .withLatestFrom(projectCreateProps) { region, before -> ProjectCreateProps in
                    var props = before
                    props.region = region
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map {
                    return ($0.state, $0.isOnline, $0.region)
                }
                .map { value in
                    let state = value.0
                    let isOnline = value.1
                    let region = value.2
                    
                    if state != nil && isOnline == .online {
                        return true
                    } else if state != nil && (isOnline == .onOffline || isOnline == .offline) && region != nil {
                        return true
                    } else {
                        return false
                    }
                }
                .bind(to: stateRegionCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformGoalCareer(input: Input) {
            Observable.merge(
                input.goalPortfolioTap.map { Goal.portfolio },
                input.goalStartUpTap.map { Goal.startup }
            ).withLatestFrom(projectCreateProps) { goal, before -> ProjectCreateProps in
                var props = before
                props.goal = goal
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            input.selectedMinCareer
                .withLatestFrom(projectCreateProps) { career, before -> ProjectCreateProps in
                    var props = before
                    props.careerMin = career
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.selectedMaxCareer
                .withLatestFrom(projectCreateProps) { career, before -> ProjectCreateProps in
                    var props = before
                    props.careerMax = career
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.noRequiredExperienceTap
                .withLatestFrom(projectCreateProps) { _, before -> ProjectCreateProps in
                    var props = before
                    
                    props.careerMin = Career.none
                    props.careerMax = Career.none
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map {
                    return ($0.goal, $0.careerMin, $0.careerMax)
                }
                .map { value in
                    guard let _ = value.0,
                          let _ = value.1,
                          let _ = value.2 else { return false }
                    
                    return true
                }
                .bind(to: goalCareerCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformCategory(input: Input) {
            input.categoryTap
                .withLatestFrom(projectCreateProps) { category, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.category.contains(where: { $0 == category}),
                       let index = props.category.firstIndex(of: category) {
                        props.category.remove(at: index)
                    } else if props.category.count < 3 {
                        props.category.append(category)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map { $0.category }
                .map { return !$0.isEmpty ? true : false }
                .bind(to: categoryCanNextpage)
                .disposed(by: disposeBag)
        }
        
        func transformPost(input: Input) {
            input.selectedImage
                .withLatestFrom(projectCreateProps) { image, before -> ProjectCreateProps in
                    var props = before
                    
                    props.banner += image
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteImageTap
                .withLatestFrom(projectCreateProps) { image, before -> ProjectCreateProps in
                    var props = before
                    
                    if let index = props.banner.firstIndex(where: { $0 == image }) {
                        props.banner.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.introduce
                .withLatestFrom(projectCreateProps) { introduce, before -> ProjectCreateProps in
                    var props = before
                    
                    props.introducion = introduce
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.leaderPart
                .withLatestFrom(projectCreateProps) { leaderPart, before -> ProjectCreateProps in
                    var props = before
                    
                    props.leaderParts = leaderPart
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.addRecruit
                .withLatestFrom(projectCreateProps) { recruit, before -> ProjectCreateProps in
                    var props = before
                    
                    if !props.recruits.contains(where: { $0.part == recruit.part }) {
                        if props.recruits.map({ $0.max }).reduce(0, +) < 29 {
                            props.recruits.append(recruit)
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.minusRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if let index = props.recruits.firstIndex(of: recurit) {
                        if props.recruits[index].max > 1 {
                            props.recruits[index].max -= 1
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.plusRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.recruits.map({ $0.max }).reduce(0, +) < 29 {
                        if let index = props.recruits.firstIndex(of: recurit) {
                            props.recruits[index].max += 1
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if let index = props.recruits.firstIndex(of: recurit) {
                        props.recruits.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.changeCommentRecruit
                .withLatestFrom(projectCreateProps) { content, before -> ProjectCreateProps in
                    var props = before
                    
                    var recruit = content.0
                    let changedComment = content.1
                    
                    if let index = props.recruits.firstIndex(of: recruit) {
                        props.recruits[index].comment = changedComment
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.selectedSkillTap
                .withLatestFrom(projectCreateProps) { skill, before -> ProjectCreateProps in
                    var props = before
                    
                    if !props.skills.contains(skill) {
                        props.skills.append(skill)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteSkillTap
                .withLatestFrom(projectCreateProps) { skill, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.skills.contains(skill),
                       let index = props.skills.firstIndex(where: { $0 == skill}) {
                        props.skills.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
        }
        
        func transformCreatePost(input: Input) {
            
            input.createButtonTap
                .withLatestFrom(projectCreateProps)
                .withUnretained(self)
                .flatMap { this, props in
                    return this.projectCreateUseCase.create(props: props)
                        .asObservable()
                        .catch { [weak self] error in
                            self?.error.onNext(error)
                            
                            return .empty()
                        }
                }
                .withUnretained(self)
                .subscribe(onNext: { this, _ in
                    this.navigation.onNext(.finish)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Modify
    func transformModify(input: Input) {
        
        
        transformStartFromLastPage()
        transformTitle()
        transformstateRegion(input: input)
        transformGoalCareer(input: input)
        transformCategory(input: input)
        transformPost(input: input)
        transformModifyFetchProjectIfo(input: input)
        transformModifyPost(input: input)
        
        func transformStartFromLastPage() {
            // 수정하기인 경우 마지막 화면부터 시작
            input.viewWillAppear
                .map { _ in return 4 }
                .bind(to: currentPage)
                .disposed(by: disposeBag)
        }
        
        func transformTitle() {
            input.title
                .withLatestFrom(projectCreateProps) { title, before -> ProjectCreateProps in
                    var props = before
                    props.title = title
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map { $0.title }
                .compactMap { $0 }
                .map { $0.count >= 2 }
                .bind(to: titleCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformstateRegion(input: Input) {
            
            Observable.merge(
                input.stateBeforeTap.map { ProjectState.before },
                input.stateRunningTap.map { ProjectState.running }
            ).withLatestFrom(projectCreateProps) { state, before -> ProjectCreateProps in
                var props = before
                props.state = state
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            Observable.merge(
                input.onlineTap.map { isOnline.online },
                input.onOfflineTap.map { isOnline.onOffline },
                input.offlineTap.map { isOnline.offline }
            ).withLatestFrom(projectCreateProps) { isOnline, before -> ProjectCreateProps in
                var props = before
                props.isOnline = isOnline
                
                if isOnline == .online {
                    props.region = nil
                }
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            input.selectedRegion
                .withLatestFrom(projectCreateProps) { region, before -> ProjectCreateProps in
                    var props = before
                    props.region = region
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map {
                    return ($0.state, $0.isOnline, $0.region)
                }
                .map { value in
                    let state = value.0
                    let isOnline = value.1
                    let region = value.2
                    
                    if state != nil && isOnline == .online {
                        return true
                    } else if state != nil && (isOnline == .onOffline || isOnline == .offline) && region != nil {
                        return true
                    } else {
                        return false
                    }
                }
                .bind(to: stateRegionCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformGoalCareer(input: Input) {
            Observable.merge(
                input.goalPortfolioTap.map { Goal.portfolio },
                input.goalStartUpTap.map { Goal.startup }
            ).withLatestFrom(projectCreateProps) { goal, before -> ProjectCreateProps in
                var props = before
                props.goal = goal
                
                return props
            }
            .bind(to: projectCreateProps)
            .disposed(by: disposeBag)
            
            input.selectedMinCareer
                .withLatestFrom(projectCreateProps) { career, before -> ProjectCreateProps in
                    var props = before
                    props.careerMin = career
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.selectedMaxCareer
                .withLatestFrom(projectCreateProps) { career, before -> ProjectCreateProps in
                    var props = before
                    props.careerMax = career
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.noRequiredExperienceTap
                .withLatestFrom(projectCreateProps) { _, before -> ProjectCreateProps in
                    var props = before
                    
                    props.careerMin = Career.none
                    props.careerMax = Career.none
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map {
                    return ($0.goal, $0.careerMin, $0.careerMax)
                }
                .map { value in
                    guard let _ = value.0,
                          let _ = value.1,
                          let _ = value.2 else { return false }
                    
                    return true
                }
                .bind(to: goalCareerCanNextPage)
                .disposed(by: disposeBag)
        }
        
        func transformCategory(input: Input) {
            input.categoryTap
                .withLatestFrom(projectCreateProps) { category, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.category.contains(where: { $0 == category}),
                       let index = props.category.firstIndex(of: category) {
                        props.category.remove(at: index)
                    } else if props.category.count < 3 {
                        props.category.append(category)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            projectCreateProps
                .map { $0.category }
                .map { return !$0.isEmpty ? true : false }
                .bind(to: categoryCanNextpage)
                .disposed(by: disposeBag)
        }
        
        func transformPost(input: Input) {
            input.selectedImage
                .withLatestFrom(projectCreateProps) { image, before -> ProjectCreateProps in
                    var props = before
                    
                    props.banner += image
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteImageTap
                .withLatestFrom(projectCreateProps) { image, before -> ProjectCreateProps in
                    var props = before
                    
                    props.removeBanners.append(image.name)
                    
                    
                    if let index = props.banner.firstIndex(where: { $0 == image }) {
                        props.banner.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.introduce
                .withLatestFrom(projectCreateProps) { introduce, before -> ProjectCreateProps in
                    var props = before
                    
                    props.introducion = introduce
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.leaderPart
                .withLatestFrom(projectCreateProps) { leaderPart, before -> ProjectCreateProps in
                    var props = before
                    
                    props.leaderParts = leaderPart
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.introduce
                .withLatestFrom(projectCreateProps) { introduce, before -> ProjectCreateProps in
                    var props = before
                    
                    props.introducion = introduce
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.leaderPart
                .withLatestFrom(projectCreateProps) { leaderPart, before -> ProjectCreateProps in
                    var props = before
                    
                    props.leaderParts = leaderPart
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.addRecruit
                .withLatestFrom(projectCreateProps) { recruit, before -> ProjectCreateProps in
                    var props = before
                    
                    if !props.recruits.contains(where: { $0.part == recruit.part }) {
                        if props.recruits.map({ $0.max }).reduce(0, +) < 29 {
                            props.recruits.append(recruit)
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.minusRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if let index = props.recruits.firstIndex(of: recurit) {
                        if props.recruits[index].max > 1 {
                            props.recruits[index].max -= 1
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.plusRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.recruits.map({ $0.max }).reduce(0, +) < 29 {
                        if let index = props.recruits.firstIndex(of: recurit) {
                            props.recruits[index].max += 1
                        }
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteRecruit
                .withLatestFrom(projectCreateProps) { recurit, before -> ProjectCreateProps in
                    var props = before
                    
                    if let index = props.recruits.firstIndex(of: recurit) {
                        props.recruits.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.changeCommentRecruit
                .withLatestFrom(projectCreateProps) { content, before -> ProjectCreateProps in
                    var props = before
                    
                    var recruit = content.0
                    let changedComment = content.1
                    
                    if let index = props.recruits.firstIndex(of: recruit) {
                        props.recruits[index].comment = changedComment
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.selectedSkillTap
                .withLatestFrom(projectCreateProps) { skill, before -> ProjectCreateProps in
                    var props = before
                    
                    if !props.skills.contains(skill) {
                        props.skills.append(skill)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
            
            input.deleteSkillTap
                .withLatestFrom(projectCreateProps) { skill, before -> ProjectCreateProps in
                    var props = before
                    
                    if props.skills.contains(skill),
                       let index = props.skills.firstIndex(where: { $0 == skill}) {
                        props.skills.remove(at: index)
                    }
                    
                    return props
                }
                .bind(to: projectCreateProps)
                .disposed(by: disposeBag)
        }
        
        func transformModifyFetchProjectIfo(input: Input) {

            input.viewWillAppear
                .withUnretained(self)
                .map { this, _ in
                    return this.modifyTarget
                }
                .compactMap { $0 }
                .withUnretained(self)
                .flatMap { this, target in
                    this.projectInfoUseCase.project(projectId: target)
                        .catch { [weak self] error in
                            self?.error.onNext(error)
                            return .empty()
                        }
                }
                .withUnretained(self)
                .subscribe(onNext: { this, project in
                    
                    project.toProps(completion: { props in
                        this.projectCreateProps.accept(props)
                        this.isModify.accept(())
                    })
                })
                .disposed(by: disposeBag)
        }
        
        func transformModifyPost(input: Input) {
            input.createButtonTap
                .withLatestFrom(projectCreateProps)
                .withUnretained(self)
                .flatMap { this, props in
                    return this.projectModifyUseCase.modify(props: props, projectId: this.modifyTarget!)
                        .asObservable()
                        .catch { [weak self] error in
                            self?.error.onNext(error)
                            
                            return .empty()
                        }
                }
                .withUnretained(self)
                .subscribe(onNext: { this, _ in
                    this.navigation.onNext(.finish)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    // MARK: - Common
    
    func transformNavigation(input: Input) {
        
        input.closeButtonTap
            .map { .close }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
  
    func transformPages(input: Input) {
        
        input.nextButtonTap
            .withLatestFrom(currentPage)
            .map { $0 + 1 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
        input.beforeButtonTap
            .withLatestFrom(currentPage)
            .map { $0 - 1 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
    }
    
    func transformError(input: Observable<Void>) {
        input
            .map { ProjectCreateMainNavigation.close }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformCanCreate(props: BehaviorRelay<ProjectCreateProps>) {
        props
            .map {
                if $0.leaderParts != nil && !$0.recruits.isEmpty && $0.introducion != nil {
                    if let introduce = $0.introducion {
                        if !introduce.isEmpty {
                            return true
                        }
                    }
                }
                
                return false
            }
            .bind(to: canCreate)
            .disposed(by: disposeBag)
    }
}
