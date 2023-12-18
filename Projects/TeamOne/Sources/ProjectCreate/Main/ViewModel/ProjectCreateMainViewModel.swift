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

final class ProjectCreateMainViewModel: ViewModel {

    struct Input {
        let viewWillAppear: Observable<Void>
        let closeButtonTap: Observable<Void>
        let nextButtonTap: Observable<Void>
        let projectName: Observable<String>
        let beforeButtonTap: Observable<Void>
        let stateBeforeTap: Observable<Void>
        let stateRunningTap: Observable<Void>
        let regionONlineTap: Observable<Void>
        let regionOnOfflineTap: Observable<Void>
        let regionOfflineTap: Observable<Void>
        let selectLocation: Observable<String>

        let purposeStartUpTap: Observable<Void>
        let purposePortfolioTap: Observable<Void>
        let noRequiredExperienceTap: Observable<Void>
        let selectedMinCareer: Observable<String>
        let selectedMaxCareer: Observable<String>

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
        let selectedState: Signal<ProjectState?>
        let selectedRegion: Driver<Region>
        let locationList: Driver<[String]>
        let stateRegionCanNextPage: Driver<Bool>

        let isNoRequiredExperience: Driver<Bool>
        let purpose: Driver<Purpose>
        let purposeCareerCanNextPage: Driver<Bool>

        let selectedCategory: Driver<[String]>

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

    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProjectCreateMainNavigation>()

    let alertResultSubject = PublishSubject<Bool>()

    let location = BehaviorSubject<String>(value: "")
    let isCareerSelected = BehaviorSubject<Bool>(value: false)

    // MARK: - Output

    let currentPage = BehaviorSubject<Int>(value: 4)
    let cancleAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    let state = PublishSubject<ProjectState?>()
    let region = BehaviorSubject<Region>(value: .none)
    lazy var locationList = BehaviorSubject<[String]>(value: [])
    let stateRegionCanNextPage = BehaviorSubject<Bool>(value: false)

    let isNoRequiredExperience = BehaviorSubject<Bool>(value: false)
    let purpose = BehaviorSubject<Purpose>(value: .none)
    let purposeCareerCanNextPage = BehaviorSubject<Bool>(value: false)

    let selectedCategory = BehaviorSubject<[String]>(value: [])

    let selectedImage = BehaviorSubject<[UIImage]>(value: [])

    let selectedRecruits = BehaviorSubject<Recurits>(value: [])

    let selectedSkills = BehaviorSubject<[String]>(value: [])

    let projectCanCreate = BehaviorSubject<Bool>(value: false)

    func transform(input: Input) -> Output {

        transformNavigation(input: input)
        transformPages(input: input)
        transformStateRegion(input: input)
        transformPurposeCareer(input: input)
        transformCategory(input: input)
        transformPost(input: input)
        transformCreatePost(input: input)

        return Output(
            currentPage: currentPage.asDriver(onErrorJustReturn: 0),
            cancleAlert: cancleAlertSubject,
            selectedState: state.asSignal(onErrorJustReturn: nil),
            selectedRegion: region.asDriver(onErrorJustReturn: .none),
            locationList: locationList.asDriver(onErrorJustReturn: []),
            stateRegionCanNextPage: stateRegionCanNextPage.asDriver(onErrorJustReturn: false),
            isNoRequiredExperience: isNoRequiredExperience.asDriver(onErrorJustReturn: false),
            purpose: purpose.asDriver(onErrorJustReturn: .none),
            purposeCareerCanNextPage: purposeCareerCanNextPage.asDriver(onErrorJustReturn: false),
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
        .disposed(by: disposeBag) // 여기에 DisposeBag을 사용하여 구독 관리

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
                   let index = newCurrent.firstIndex(where: { $0 == select}){
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
        
        Observable.combineLatest(
            input.selectedMinCareer,
            input.selectedMaxCareer,
            self.isNoRequiredExperience
        )
        .withUnretained(self)
        .subscribe(onNext: { (viewModel, arg)in
            let min = arg.0
            let max = arg.1
            let noRequired = arg.2

            if noRequired == false {
                if !min.isEmpty && !max.isEmpty {
                    viewModel.isCareerSelected.onNext(true)
                } else {
                    viewModel.isCareerSelected.onNext(false)
                }
            } else {
                viewModel.isCareerSelected.onNext(true)
            }
        })
        .disposed(by: disposeBag)

        Observable.combineLatest(
            isCareerSelected,
            purpose
        )
        .withUnretained(self)
        .subscribe(onNext: { viewModel, arg in
            let careerSelected = arg.0
            let purpose = arg.1

            if careerSelected == true && purpose != .none {
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

    func transformStateRegion(input: Input) {

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
            .bind(to: locationList)
            .disposed(by: disposeBag)

        // -- Input

        let regionChange = Observable.merge(
            input.regionONlineTap.map { Region.online },
            input.regionOnOfflineTap.map { Region.onOffline },
            input.regionOfflineTap.map { Region.offline }
        )

        regionChange
            .bind(to: region)
            .disposed(by: disposeBag)

        input.selectLocation
            .bind(to: location)
            .disposed(by: disposeBag)

        // toNextable

        Observable.combineLatest(state, region, location)
            .map { (state, region, location) in
                // state가 nil이면 false, region이 none이라면 false
                guard let state = state else { return false }
                if region == .none { return false }

                // offline, onoffline일 경우에는 location이 ""이 아닌경우에만
                if (region == .offline || region == .onOffline) && !location.isEmpty {
                    return true
                } else if region == .online {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: stateRegionCanNextPage)
            .disposed(by: disposeBag)
    }
}
