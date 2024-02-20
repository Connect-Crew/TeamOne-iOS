//  BaseTabBarViewModel.swift
//  RootFeature
//
//  Created by Junyoung Lee on 2023/09/27.
//  Copyright © 2023 Quriously. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

import BaseFeatureDependency
import Domain
import Core
import DSKit

final class BaseTabBarViewModel: ViewModelType {
    
    private var disposeBag = DisposeBag()
    private let inventoryUseCase = DIContainer.shared.resolve(OnlineInventoryUseCase.self)
    private let updateLocalKlassUseCase = DIContainer.shared.resolve(UpdateLocalKlassUseCase.self)
    private let consumeAllUseCase = DIContainer.shared.resolve(ConsumeAllUseCase.self)
    private let downloadVideoUseCase = DIContainer.shared.resolve(DownloadVideoUseCase.self)
    private let clearInvalidVideoUseCase = DIContainer.shared.resolve(ClearInvalidVideoUseCase.self)
    weak var coordinator: MainCoordinator?
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let tabBarDidMove: Observable<Void>
        let startCoordinator: Observable<(page: TabBarPage, tabNavigationController: UINavigationController)>
    }
    
    struct Output {
        let tokenExpiredAlert: Driver<Alert>
    }
    
    func transform(input: Input) -> Output {
        
        let tenSecondsInterval = Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance)
        let tokenExpireResult = PublishSubject<Bool>()
        
        let viewWillAppear = input.viewWillAppear
            .share()
        
        viewWillAppear
            .flatMap(updateLocalKlassUseCase.updateKlassLocalDB)
            .subscribe()
            .disposed(by: disposeBag)
        
        tenSecondsInterval
            .withUnretained(self)
            .flatMap { this, _ -> Observable<Void> in
                this.consumeAllUseCase.consumeAll()
            }
            .subscribe(onNext: { _ in
                Log.debug("Offline Consume All Complete")
            })
            .disposed(by: disposeBag)
        
        input.startCoordinator
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.coordinator?.startTabCoordinator(
                    page: result.page,
                    tabNavigationController: result.tabNavigationController
                )
            })
            .disposed(by: disposeBag)
        
        clearInvalidVideoUseCase.clearInvalidVideo()
        
        let alert = NotificationCenter.default.rx.notification(.tokenExpired)
            .map { _ in
                Alert.tokenExpiredAlert(tokenExpireResult.asObserver())
            }
        
        tokenExpireResult
            .bind { [weak self] _ in
                self?.coordinator?.finish()
            }
            .disposed(by: disposeBag)
        
        return Output(
            tokenExpiredAlert: alert.asDriver { _ in .never() }
        )
    }
    
    deinit {
        disposeBag = DisposeBag()
        Log.debug("deinit: \(type(of: self))")
    }
}
