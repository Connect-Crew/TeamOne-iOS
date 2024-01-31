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
}

final class SettingViewModel: ViewModel {
    
    let signOutUseCase: SignOutUseCase
    let appSettingUseCase: AppSettingUseCase = DIContainer.shared.resolve(AppSettingUseCase.self)
    
    public init(signOutUseCase: SignOutUseCase) {
        self.signOutUseCase = signOutUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTap: Observable<Void>
        let appSettingTap: PublishRelay<AppSettingType>
        let notificationSettingTap: PublishRelay<NotificationSettingType>
    }
    
    struct Output {
        let notificationSetting: Driver<NotificationSettings>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let navigation = PublishSubject<SettingNavigation>()
    
    let notificationSetting = BehaviorRelay<NotificationSettings>(value: NotificationSettings.isNotSet)
    
    func transform(input: Input) -> Output {
        
        transformFetchSetting(viewDidLoad: input.viewDidLoad)
        transformSetNotificationSetting(tap: input.notificationSettingTap)
        transformBackButton(tap: input.backButtonTap)
        transformAppSetting(setting: input.appSettingTap)
        
        return Output(
            notificationSetting: notificationSetting.asDriver()
        )
    }
    
    private func transformFetchSetting(viewDidLoad: Observable<Void>) {
        viewDidLoad
            .withUnretained(self)
            .flatMap { this, _ in
                this.appSettingUseCase.getNotificationSetting()
            }
            .bind(to: notificationSetting)
            .disposed(by: disposeBag)
    }
    
    private func transformSetNotificationSetting(
        tap: PublishRelay<NotificationSettingType>
    ) {
        
        let activity = tap
            .filter { $0 == .activity }
        
        activity
                .withLatestFrom(notificationSetting) { _, setting in
                    var toggled = setting
                    toggled.activitySetting.toggle()
                    
                    return toggled
                }
                .withUnretained(self)
                .flatMap { this, setting in
                    this.appSettingUseCase.setNotificationSetting(setting: setting)
                        .do(onCompleted: {
                            this.notificationSetting.accept(setting)
                        })
                }
                .subscribe(onNext: { _ in })
                .disposed(by: disposeBag)
    }
    
    private func transformAppSetting(
        setting: PublishRelay<AppSettingType>
    ) {
        
        // SignOut
        setting
            .filter({ $0 == .signOut })
            .withUnretained(self)
            .flatMap { this, _ in
                this.signOutUseCase.signOut()
                    .catch { error in
                        print("DEBUG: printError1\(error)")
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] in
                print("DEBUG: Logout")
                self?.navigation.onNext(.logout)
            })
            .disposed(by: disposeBag)
    }
    
    private func transformBackButton(tap: Observable<Void>) {
        tap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}

