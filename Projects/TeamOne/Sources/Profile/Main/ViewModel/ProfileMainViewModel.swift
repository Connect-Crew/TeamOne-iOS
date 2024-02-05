//
//  ProfileMainViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Domain
import RxSwift
import RxCocoa
import Core

enum ProfileNavigation {
    case finish
    case setting
    case myProject
}

final class ProfileMainViewModel: ViewModel {
    
    struct Input {
        let tapSetting: Observable<SettingType>
        let tapMyProfile: Observable<MyProjectType>
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileNavigation>()
    
    func transform(input: Input) -> Output {
        
        transformTapSetting(tap: input.tapSetting)
        transformTapMyProject(input.tapMyProfile)
        
        return Output()
    }
    
    func transformTapSetting(tap: Observable<SettingType>) {
        let tapSetting = tap.filter { $0 == .setting }
        
        tapSetting
            .map { _ in return .setting }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformTapMyProject(_ input: Observable<MyProjectType>) {
        input
            .withUnretained(self)
            .subscribe(onNext: { this, type in
                switch type {
                case .myProject:
                    this.navigation.onNext(.myProject)
                case .submittedProject:
                    break
                case .favoriteProject:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
