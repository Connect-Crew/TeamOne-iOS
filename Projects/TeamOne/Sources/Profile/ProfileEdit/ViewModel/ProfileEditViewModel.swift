//
//  ProfileEditViewModel.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Core
import RxSwift

enum ProfileEditNavigation {
    case editComplete
    case back
}

final class ProfileEditViewModel: ViewModel {
    
    struct Input {
        let tapBackButton: Observable<Void>
        let tapEditCompleteButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileEditNavigation>()
    
    func transform(input: Input) -> Output {
        
        transformEdit(tap: input.tapEditCompleteButton)
        transformBack(tap: input.tapBackButton)
        
        return Output()
    }
    
    private func transformEdit(tap: Observable<Void>) {
        tap
            .map { .editComplete }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    private func transformBack(tap: Observable<Void>) {
        tap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
}
