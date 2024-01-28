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
}

final class ProfileMainViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
