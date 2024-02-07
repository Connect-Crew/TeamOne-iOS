//
//  DropoutViewModel.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Domain
import RxSwift
import RxCocoa
import Core

enum DropoutNavigation {
    case finish
    case back
}

final class DropoutViewModel: ViewModel {
    
    struct Input {
        let tapBack: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<DropoutNavigation>()
    
    func transform(input: Input) -> Output {
        
        input.tapBack
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
