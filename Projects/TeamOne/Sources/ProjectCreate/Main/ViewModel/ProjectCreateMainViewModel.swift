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
    
    init(
        projectCreateUseCase: ProjectCreateUseCase,
        projectInfoUseCase: ProjectInfoUseCase,
        type: ProjectCreateType = .create,
        projectId: Int?
    ) {
        self.projectCreateUseCase = projectCreateUseCase
        self.projectInfoUseCase = projectInfoUseCase
        self.type.onNext(type)
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
        let selectedImage: Observable<[UIImage]>
        let deleteImageTap: Observable<UIImage>
        let recruitTeamOne: Observable<[Recruit]>
        
        let introduce: Observable<String>
        let leaderPart: Observable<String>
        
        let selectedSkillTap: Observable<String>
        let deleteSkillTap: Observable<String>
        
        let createButtonTap: Observable<Void>
        let errorOKTap: Observable<Bool>
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
    lazy var props = BehaviorRelay<ProjectCreateProps>(value: ProjectCreateProps())
    
    // MARK: - type(수정하기인 경우 필요)
    
    let type = BehaviorSubject<ProjectCreateType>(value: .create)
    let modifyTarget: Int?
    let isModify = PublishRelay<Void>()
    
    // MARK: - Error
    
    let error = PublishSubject<Error>()
    
    func transform(input: Input) -> Output {
        
        transformNavigation(input: input)
        transformPages(input: input)
        transformTitle(input: input)
        transformstateRegion(input: input)
        transformGoalCareer(input: input)
        transformCategory(input: input)
        transformPost(input: input)
        transformCreatePost(input: input)
        transformModify(input: input)
        transformError(input: input.errorOKTap)
        
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
            projectCreateProps: props.asDriver(),
            error: error,
            isModify: isModify.take(1)
        )
    }
    
    func transformNavigation(input: Input) {
        
        input.closeButtonTap
            .map { .close }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    
    func transformPages(input: Input) {
        
        // 수정하기인 경우 마지막 화면부터 시작
        type
            .filter { $0 == .modify }
            .distinctUntilChanged()
            .map { _ in return 4 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
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
    
    func transformTitle(input: Input) {
        input.title
            .withLatestFrom(props) { title, before -> ProjectCreateProps in
                var props = before
                props.title = title
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        props
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
        ).withLatestFrom(props) { state, before -> ProjectCreateProps in
            var props = before
            props.state = state
            
            return props
        }
        .bind(to: props)
        .disposed(by: disposeBag)
        
        Observable.merge(
            input.onlineTap.map { isOnline.online },
            input.onOfflineTap.map { isOnline.onOffline },
            input.offlineTap.map { isOnline.offline }
        ).withLatestFrom(props) { isOnline, before -> ProjectCreateProps in
            var props = before
            props.isOnline = isOnline
            
            if isOnline == .online {
                props.region = nil
            }
            
            return props
        }
        .bind(to: props)
        .disposed(by: disposeBag)
        
        input.selectedRegion
            .withLatestFrom(props) { region, before -> ProjectCreateProps in
                var props = before
                props.region = region
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        props
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
        Observable.merge (
            input.goalPortfolioTap.map { Goal.portfolio },
            input.goalStartUpTap.map { Goal.startup }
        ).withLatestFrom(props) { goal, before -> ProjectCreateProps in
            var props = before
            props.goal = goal
            
            return props
        }
        .bind(to: props)
        .disposed(by: disposeBag)
        
        input.selectedMinCareer
            .withLatestFrom(props) { career, before -> ProjectCreateProps in
                var props = before
                props.careerMin = career
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.selectedMaxCareer
            .withLatestFrom(props) { career, before -> ProjectCreateProps in
                var props = before
                props.careerMax = career
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.noRequiredExperienceTap
            .withLatestFrom(props) { _, before -> ProjectCreateProps in
                var props = before
                
                props.careerMin = Career.none
                props.careerMax = Career.none
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        props
            .map {
                return ($0.goal, $0.careerMin, $0.careerMax)
            }
            .map { value in
                guard let goal = value.0,
                      let min = value.1,
                      let max = value.2 else { return false }
                
                return true
            }
            .bind(to: goalCareerCanNextPage)
            .disposed(by: disposeBag)
    }
    
    func transformCategory(input: Input) {
        input.categoryTap
            .withLatestFrom(props) { category, before -> ProjectCreateProps in
                var props = before
                
                if props.category.contains(where: { $0 == category}),
                   let index = props.category.firstIndex(of: category) {
                    props.category.remove(at: index)
                } else if props.category.count < 3 {
                    props.category.append(category)
                }
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        props
            .map { $0.category }
            .map { return !$0.isEmpty ? true : false }
            .bind(to: categoryCanNextpage)
            .disposed(by: disposeBag)
    }
    
    func transformPost(input: Input) {
        input.selectedImage
            .withLatestFrom(props) { image, before -> ProjectCreateProps in
                var props = before
                
                props.banner += image
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.deleteImageTap
            .withLatestFrom(props) { image, before -> ProjectCreateProps in
                var props = before
                
                if let index = props.banner.firstIndex(where: { $0 == image }) {
                    props.banner.remove(at: index)
                }
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.introduce
            .withLatestFrom(props) { introduce, before -> ProjectCreateProps in
                var props = before
                
                props.introducion = introduce
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.leaderPart
            .withLatestFrom(props) { leaderPart, before -> ProjectCreateProps in
                var props = before
                
                props.leaderParts = leaderPart
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.recruitTeamOne
            .withLatestFrom(props) { recurit, before -> ProjectCreateProps in
                var props = before
                
                props.recruits = recurit
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.selectedSkillTap
            .withLatestFrom(props) { skill, before -> ProjectCreateProps in
                var props = before
                
                if !props.skills.contains(skill) {
                    props.skills.append(skill)
                }
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        input.deleteSkillTap
            .withLatestFrom(props) { skill, before -> ProjectCreateProps in
                var props = before
                
                if props.skills.contains(skill),
                   let index = props.skills.firstIndex(where: { $0 == skill}) {
                    props.skills.remove(at: index)
                }
                
                return props
            }
            .bind(to: props)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.introduce,
            input.leaderPart,
            input.recruitTeamOne
        )
        .map { introduce, leaderPart, recruit in
            
            if !introduce.isEmpty && !leaderPart.isEmpty && !recruit.isEmpty  {
                return true
            } else {
                return false
            }
        }
        .bind(to: canCreate)
        .disposed(by: disposeBag)
    }
    
    func transformCreatePost(input: Input) {
        input.createButtonTap
            .withLatestFrom(props)
            .withUnretained(self)
            .flatMap{ this, props in
                return this.projectCreateUseCase.create(props: props)
                    .asObservable()
                    .catch { error in
                        this.error.onNext(error)
                        
                        return .empty()
                    }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.finish)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 수정하기관련
    
    func transformModify(input: Input) {
        let modify = props
            .take(1)
            .withLatestFrom(type)
            .filter { $0 == .modify }
        
        modify
            .withUnretained(self)
            .map { this, _ in
                return this.modifyTarget
            }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { this, target in
                this.projectInfoUseCase.project(projectId: target)
                    .catch { error in
                        this.error.onNext(error)
                        this.navigation.onNext(.close)
                        return .empty()
                    }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, project in
                this.props.accept(project.toProps())
                this.isModify.accept(())
                UIImageView.pathToImage(path: project.banners) { images in
                    let unOptionalImages = images.compactMap { $0 }
                    
                    var props = this.props.value
                    props.banner = unOptionalImages
                    
                    this.props.accept(props)
                    this.isModify.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    func transformError(input: Observable<Bool>) {
        input
            .map { _ in
                ProjectCreateMainNavigation.close
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
