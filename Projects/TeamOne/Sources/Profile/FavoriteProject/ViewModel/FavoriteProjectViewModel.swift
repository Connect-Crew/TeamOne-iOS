//
//  FavoriteProjectViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum FavoriteProjectNavigation {
    case back
}

final class FavoriteProjectViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<FavoriteProjectNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

