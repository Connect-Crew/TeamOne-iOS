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
    case profileEdit
    case back
}

final class ProfileDetailViewModel: ViewModel {
    
    struct Input {
        let tapBackButton: Observable<Void>
        let tapProfileEditButton: Observable<Void>
    }
    
    struct Output {
        let representProject: Observable<[Void]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ProfileDetailNavigation>()
    
    func transform(input: Input) -> Output {
        
        transformEdit(tap: input.tapProfileEditButton)
        transformBack(tap: input.tapBackButton)
        
        return Output(
            representProject: Observable.just([(), (), (), ()])
        )
    }
    
    private func transformEdit(tap: Observable<Void>) {
        tap
            .map { .profileEdit }
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

