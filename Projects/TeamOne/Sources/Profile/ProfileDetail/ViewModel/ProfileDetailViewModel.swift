//
//  ProfileDetailViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum ProfileDetailNavigation {
    case back
}

final class ProfileDetailViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileDetailNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

