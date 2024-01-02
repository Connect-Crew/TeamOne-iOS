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

// TODO: - 2번쨰 화면부터 리팩토링.

enum ProjectCreateMainNavigation {
    case finish
    case close
}

final class ProjectCreateMainViewModel: ViewModel {
    
    private let projectCreateUseCase: ProjectCreateUseCase
    
    init(projectCreateUseCase: ProjectCreateUseCase) {
        self.projectCreateUseCase = projectCreateUseCase
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let closeButtonTap: Observable<Void>
        let nextButtonTap: Observable<Void>
        let projectName: Observable<String>
        let beforeButtonTap: Observable<Void>
        let stateBeforeTap: Observable<Void>
        let stateRunningTap: Observable<Void>
        let onlineTap: Observable<Void>
        let onOfflineTap: Observable<Void>
        let offlineTap: Observable<Void>
        let selectLocation: Observable<String>

        let purposeStartUpTap: Observable<Void>
        let purposePortfolioTap: Observable<Void>
        let noRequiredExperienceTap: Observable<Void>
        let selectedMinCareer: Observable<Career>
        let selectedMaxCareer: Observable<Career>

        let categoryTap: Observable<String>
        let selectedImage: Observable<[UIImage]>
        let deleteImageTap: Observable<UIImage>
        let recruitTeamOne: Observable<[Recurit]>

        let introduce: Observable<String>

        let leaderPart: Observable<String>

        let selectedSkillTap: Observable<String>
        let deleteSkillTap: Observable<String>

        let createButtonTap: Observable<Void>
    }

    struct Output {
        let currentPage: Driver<Int>
        let cancleAlert: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
        let createAlert: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
        let selectedState: Signal<ProjectState?>
        let selectedIsOnline: Driver<isOnline>
        let locationList: Driver<[String]>
        let stateRegionCanNextPage: Driver<Bool>
        
        // MARK: - 3번째 화면
        let purpose: Driver<Purpose>
        let purposeCareerCanNextPage: Driver<Bool>
        let isNoRequiredExperience: Driver<Bool>
        let minCareer: Driver<Career>
        let minCareerSelected: Driver<Bool>
        let maxCareer: Driver<Career>
        let maxCareerSelected: Driver<Bool>

        // MARK: - 4번째 화면
        let selectedCategory: Driver<[String]>

        // MARK: - 5번째 화면
        let selectedImage: Driver<[UIImage]>
        let selectedRecruits: Driver<Recurits>
        let selectedSkill: Driver<[String]>
        let projectCanCreate: Driver<Bool>
    }

    lazy var cancleAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "생성을 중단하시겠습니까?",
        content: "확인을 누르시면 모든 내용이 삭제됩니다.",
        availableCancle: true,
        resultSubject: alertResultSubject
    )
    
    lazy var createAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .write,
        title: "프로젝트를 생성하시겠습니까??",
        content: "확인을 누르시면 프로젝트가 생성됩니다.",
        availableCancle: true,
        resultSubject: createAlertResultSubject
    )

    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProjectCreateMainNavigation>()

    let location = BehaviorSubject<String>(value: "")
    let isCareerSelected = BehaviorSubject<Bool>(value: false)

    // MARK: - Output

    // MARK: - Page
    let currentPage = BehaviorSubject<Int>(value: 0)
    
    // MARK: - Alert
    
    let cancleAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    let createAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    
    let alertResultSubject = PublishSubject<Bool>()
    let createAlertResultSubject = PublishSubject<Bool>()
    
    let state = PublishSubject<ProjectState?>()
    let isOnlineSubject = BehaviorSubject<isOnline>(value: .none)
    lazy var regions = BehaviorSubject<[String]>(value: [])

    // MARK: - 3번째 화면
    let isNoRequiredExperience = BehaviorSubject<Bool>(value: false)
    let purpose = BehaviorSubject<Purpose>(value: .none)
    let minCareer = BehaviorSubject<Career>(value: .none)
    let minCareerSelected = BehaviorSubject<Bool>(value: false)
    let maxCareer = BehaviorSubject<Career>(value: .none)
    let maxCareerSelected = BehaviorSubject<Bool>(value: false)
    let purposeCareerCanNextPage = BehaviorSubject<Bool>(value: false)
    
    // MARK: - 4번째 화면

    let selectedCategory = BehaviorSubject<[String]>(value: [])
    let selectedImage = BehaviorSubject<[UIImage]>(value: [])
    let selectedRecruits = BehaviorSubject<Recurits>(value: [])
    let selectedSkills = BehaviorSubject<[String]>(value: [])
    let projectCanCreate = BehaviorSubject<Bool>(value: false)
    
    // MARK: - canNextPage
    let stateRegionCanNextPage = BehaviorSubject<Bool>(value: false)

    func transform(input: Input) -> Output {

        transformNavigation(input: input)
        transformPages(input: input)
        transformStateisOnline(input: input)
        transformPurposeCareer(input: input)
        transformCategory(input: input)
        transformPost(input: input)
        transformCreatePost(input: input)
        
        return Output(
            currentPage: currentPage.asDriver(onErrorJustReturn: 0),
            cancleAlert: cancleAlertSubject,
            createAlert: createAlertSubject,
            selectedState: state.asSignal(onErrorJustReturn: nil),
            selectedIsOnline: isOnlineSubject.asDriver(onErrorJustReturn: .none),
            locationList: regions.asDriver(onErrorJustReturn: []),
            stateRegionCanNextPage: stateRegionCanNextPage.asDriver(onErrorJustReturn: false),
            purpose: purpose.asDriver(onErrorJustReturn: .none),
            purposeCareerCanNextPage: purposeCareerCanNextPage.asDriver(onErrorJustReturn: false),
            isNoRequiredExperience: isNoRequiredExperience.asDriver(onErrorJustReturn: false),
            minCareer: minCareer.asDriver(onErrorJustReturn: .none),
            minCareerSelected: minCareerSelected.asDriver(onErrorJustReturn: false),
            maxCareer: maxCareer.asDriver(onErrorJustReturn: .none),
            maxCareerSelected: maxCareerSelected.asDriver(onErrorJustReturn: false),
            selectedCategory: selectedCategory.asDriver(onErrorJustReturn: []),
            selectedImage: selectedImage.asDriver(onErrorJustReturn: []),
            selectedRecruits: selectedRecruits.asDriver(onErrorJustReturn: []),
            selectedSkill: selectedSkills.asDriver(onErrorJustReturn: []),
            projectCanCreate: projectCanCreate.asDriver(onErrorJustReturn: false)
        )
    }

    func transformCreatePost(input: Input) {
        Observable.combineLatest(
            input.introduce,
            input.leaderPart,
            input.recruitTeamOne
        )
        .map { introduce, leaderPart, recruit in
            
            if !introduce.isEmpty && !introduce.contains("글자수 공백포함 1000자") && !leaderPart.isEmpty && !recruit.isEmpty  {
                return true
            } else {
                return false
            }
        }
        .bind(to: projectCanCreate)
        .disposed(by: disposeBag)
        
        input.recruitTeamOne
            .bind(to: selectedRecruits)
            .disposed(by: disposeBag)
        
        
        let combine1 = Observable.combineLatest(selectedImage, input.projectName, isOnlineSubject, location, state, minCareer, maxCareer)
        let combine2 = Observable.combineLatest(input.leaderPart, selectedCategory, purpose, input.introduce, selectedRecruits, selectedSkills)
        
        createAlertResultSubject
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(combine1, combine2))
            .withUnretained(self)
            .flatMap { this, properties in
                
                let props = ProjectCreateProps(
                    banner: properties.0.0,
                    title: properties.0.1,
                    region: properties.0.3,
                    online: properties.0.2,
                    state: (properties.0.4 ?? .before),
                    careerMin: properties.0.5,
                    careerMax: properties.0.6,
                    leaderParts: properties.1.0,
                    category: properties.1.1,
                    goal: properties.1.2,
                    introducion: properties.1.3,
                    recruits: properties.1.4,
                    skills: properties.1.5
                )
                
                return this.projectCreateUseCase.create(props: props)
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.finish)
            }, onError: { [weak self] error in
                // TODO: - 에러처리
                self?.navigation.onNext(.finish)
            })
            .disposed(by: disposeBag)
            
    }

    func transformPost(input: Input) {
        input.selectedImage
            .withLatestFrom(selectedImage) {
                return ($0, $1)
            }
            .map { selected, current in
                return current + selected
            }
            .bind(to: selectedImage)
            .disposed(by: disposeBag)

        input.deleteImageTap
            .withLatestFrom(selectedImage) {
                return ($0, $1)
            }
            .map { (delete, current) in

                print("!!!!!!!!!!!\(self)::::")
                print(delete)
                print("!!!!!!!!!!!!")
                var newCurrent = current

                if let index = current.firstIndex(where: { $0 == delete }) {
                    newCurrent.remove(at: index)
                }

                return newCurrent
            }
            .bind(to: selectedImage)
            .disposed(by: disposeBag)

        input.selectedSkillTap
            .withLatestFrom(selectedSkills) { select, current in
                var newCurrent = current

                if !newCurrent.contains(select) {
                    newCurrent.append(select)
                }

                return newCurrent
            }
            .bind(to: selectedSkills)
            .disposed(by: disposeBag)

        input.deleteSkillTap
            .withLatestFrom(selectedSkills) { select, current in
                var newCurrent = current

                if newCurrent.contains(select),
                   let index = newCurrent.firstIndex(where: { $0 == select}) {
                    newCurrent.remove(at: index)
                }

                return newCurrent
            }
            .bind(to: selectedSkills)
            .disposed(by: disposeBag)
    }

    func transformCategory(input: Input) {
        input.categoryTap
            .withLatestFrom(selectedCategory) { tap, current in
                return (tap, current)
            }
            .map { (tap, current) in

                var newCurrent = current

                if newCurrent.contains(where: { $0 == tap}),
                   let index = current.firstIndex(of: tap) {
                    newCurrent.remove(at: index)
                } else {
                    if newCurrent.count < 3 {
                        newCurrent.append(tap)
                    }
                }

                return newCurrent
            }
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
    }

    func transformPurposeCareer(input: Input) {

        Observable.merge(
            input.purposePortfolioTap.map { _ in return Purpose.portfolio },
            input.purposeStartUpTap.map { _ in return Purpose.startup }
        )
        .bind(to: purpose)
        .disposed(by: disposeBag)

        input.noRequiredExperienceTap
            .withLatestFrom(isNoRequiredExperience)
            .map { !$0 }
            .bind(to: isNoRequiredExperience)
            .disposed(by: disposeBag)
        
        isNoRequiredExperience
            .filter { $0 == true }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.minCareer.onNext(.none)
                this.maxCareer.onNext(.none)
                this.minCareerSelected.onNext(true)
                this.maxCareerSelected.onNext(true)
            })
            .disposed(by: disposeBag)
        
        input.selectedMinCareer
            .withUnretained(self)
            .bind(onNext: { this, career in
                this.minCareer.onNext(career)
                this.minCareerSelected.onNext(true)
                this.maxCareerSelected.onNext(false)
            })
            .disposed(by: disposeBag)
        
        input.selectedMaxCareer
            .withUnretained(self)
            .bind(onNext: { this, career in
                this.maxCareer.onNext(career)
                this.maxCareerSelected.onNext(true)
            })
            .disposed(by: disposeBag)
    
        Observable.combineLatest(
            minCareerSelected,
            maxCareerSelected
        )
        .withUnretained(self)
        .subscribe(onNext: { (viewModel, arg) in
            let min = arg.0
            let max = arg.1
            
            if min != false && max != false {
                viewModel.purposeCareerCanNextPage.onNext(true)
            } else {
                viewModel.purposeCareerCanNextPage.onNext(false)
            }
        })
        .disposed(by: disposeBag)
        
    }

    func transformNavigation(input: Input) {

        input.closeButtonTap
            .withUnretained(self)
            .map { viewModel, _ in
                viewModel.cancleAlert
            }
            .bind(to: cancleAlertSubject)
            .disposed(by: disposeBag)

        cancleAlert
            .resultSubject
            .filter { $0 == true }
            .map { _ in
                return ProjectCreateMainNavigation.close
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.createButtonTap
            .withUnretained(self)
            .map { this, _ in
                this.createAlert
            }
            .bind(to: createAlertSubject)
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

    func transformStateisOnline(input: Input) {

        // State

        let stateChange = Observable.merge(
            input.stateBeforeTap.map { ProjectState.before },
            input.stateRunningTap.map { ProjectState.running }
        )

        stateChange
            .map { [state] newState in
                return Observable.just(newState)
                    .withLatestFrom(state.asObservable().startWith(nil)) { ($0, $1) }
                    .map { new, current in
                        return new == current ? nil : new
                    }
                    .distinctUntilChanged()
            }
            .concat()
            .bind(to: state)
            .disposed(by: disposeBag)

        // region

        // -- Output

        input.viewWillAppear
            .map { KM.shared.getRegion() }
            .bind(to: regions)
            .disposed(by: disposeBag)

        // -- Input

        let isOnlineChange = Observable.merge(
            input.onlineTap.map { isOnline.online },
            input.onOfflineTap.map { isOnline.onOffline },
            input.offlineTap.map { isOnline.offline }
        )

        isOnlineChange
            .bind(to: isOnlineSubject)
            .disposed(by: disposeBag)

        input.selectLocation
            .bind(to: location)
            .disposed(by: disposeBag)

        // toNextable

        Observable.combineLatest(state, isOnlineSubject, location)
            .map { (state, isOnline, location) in
                // state가 nil이면 false, region이 none이라면 false
                guard let state = state else { return false }
                if isOnline == .none { return false }

                // offline, onoffline일 경우에는 location이 ""이 아닌경우에만
                if (isOnline == .offline || isOnline == .onOffline) && !location.isEmpty {
                    return true
                } else if isOnline == .online {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: stateRegionCanNextPage)
            .disposed(by: disposeBag)
    }
}
