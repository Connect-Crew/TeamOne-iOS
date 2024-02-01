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
}

final class ProfileMainViewModel: ViewModel {
    
    struct Input {
        let tapSetting: Observable<SettingType>
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileNavigation>()
    
    func transform(input: Input) -> Output {
        
        transformTapSetting(tap: input.tapSetting)
        
        return Output()
    }
    
    func transformTapSetting(tap: Observable<SettingType>) {
        let tapSetting = tap.filter { $0 == .setting }
        
        tapSetting
            .map { _ in return .setting }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
