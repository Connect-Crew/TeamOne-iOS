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
        let backButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<FavoriteProjectNavigation>()
    
    func transform(input: Input) -> Output {
        
        transformBack(tap: input.backButtonTap)
        
        return Output()
    }
    
    private func transformBack(tap: Observable<Void>) {
        tap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}

