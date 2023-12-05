//
//  ProjectCreateMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import Foundation
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
    }

    struct Output {
        let currentPage: Driver<Int>
        let cancleAlert: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
        let selectedState: Signal<ProjectState?>
        let selectedRegion: Driver<Region>
        let locationList: Driver<[String]>
        let stateRegionCanNextPage: Driver<Bool>
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

    // MARK: - Output

    let currentPage = BehaviorSubject<Int>(value: 0)
    let cancleAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    let state = PublishSubject<ProjectState?>()
    let region = BehaviorSubject<Region>(value: .none)
    lazy var locationList = BehaviorSubject<[String]>(value: [])
    let stateRegionCanNextPage = BehaviorSubject<Bool>(value: false)

    func transform(input: Input) -> Output {

        transformNavigation(input: input)
        transformPages(input: input)
        transformStateRegion(input: input)

        return Output(
            currentPage: currentPage.asDriver(onErrorJustReturn: 0),
            cancleAlert: cancleAlertSubject,
            selectedState: state.asSignal(onErrorJustReturn: nil),
            selectedRegion: region.asDriver(onErrorJustReturn: .none),
            locationList: locationList.asDriver(onErrorJustReturn: []),
            stateRegionCanNextPage: stateRegionCanNextPage.asDriver(onErrorJustReturn: false)
        )
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
