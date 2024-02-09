//
//  SettingViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import Core

enum SettingNavigation {
    case back
    case logout
    case dropout
}

typealias SettingDataSource = [SettingSection: [SettingCellType]]

final class SettingViewModel: ViewModel {
    
    let signOutUseCase: SignOutUseCase
    let appSettingUseCase: AppSettingUseCase = DIContainer.shared.resolve(AppSettingUseCase.self)
    
    public init(signOutUseCase: SignOutUseCase) {
        self.signOutUseCase = signOutUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTap: Observable<Void>
        let cellDidSelect: Observable<SettingCellType>
        let logoutTap: Observable<Void>
    }
    
    struct Output {
        let dataSource: Driver<[SettingDataSource]>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let navigation = PublishSubject<SettingNavigation>()
    
    let dataSource = BehaviorRelay<[SettingDataSource]>(value: [])
    
    func transform(input: Input) -> Output {
        
        transformBackButton(tap: input.backButtonTap)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { this, _ in
                this.makeDataSource()
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        input.cellDidSelect
            .withUnretained(self)
            .subscribe(onNext: { this, type in
                switch type {
                case .activityNotification(let isOn):
                    this.updateActivity(current: isOn)
                case .dropout:
                    this.navigation.onNext(.dropout)
                case .logout: break
                case .privacyPolicy: break
                case .termsOfService: break
                }
            })
            .disposed(by: disposeBag)
        
        input.logoutTap
            .subscribe(onNext: { [weak self] in
                self?.logout()
            })
            .disposed(by: disposeBag)
        
        return Output(
            dataSource: dataSource.asDriver()
        )
    }
    
    private func transformBackButton(tap: Observable<Void>) {
        tap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}

extension SettingViewModel {
    
    private func makeDataSource() -> Observable<[SettingDataSource]> {
        let notificationSetings = fetchNotificationSettings().map { [$0] }
        
        let rowData = Observable.of([
            makePolicySetting(),
            makeAppSetting()
        ])
        
        return Observable.zip(notificationSetings, rowData)
            .map { $0.0 + $0.1 }
    }
    
    private func fetchNotificationSettings() -> Observable<SettingDataSource> {
        return appSettingUseCase.getNotificationSetting()
            .asObservable()
            .withUnretained(self)
            .map { this, setting -> SettingDataSource in
                return [.notification: [.activityNotification(setting.activitySetting)]]
            }
    }
    
    private func makePolicySetting() -> SettingDataSource {
        return [.policy: [.termsOfService, .privacyPolicy]]
    }
    
    private func makeAppSetting() -> SettingDataSource {
        return [.app: [.logout, .dropout]]
    }
    
    private func updateActivity(current: Bool) {
        appSettingUseCase.setActivitySetting(isOn: !current)
            .do(afterCompleted: { [weak self] in
                
                guard let self = self else { return }
                
                self.makeDataSource()
                    .bind(to: self.dataSource)
                    .disposed(by: self.disposeBag)
            })
            .subscribe(onCompleted: { })
            .disposed(by: disposeBag)
    }
    
    private func logout() {
        signOutUseCase.signOut()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.navigation.onNext(.logout)
            })
            .disposed(by: disposeBag)
    }
}

