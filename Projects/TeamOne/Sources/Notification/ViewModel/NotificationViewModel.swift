//
//  NotificationViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum NotificationNavigation {
    case finish
}

final class NotificationViewModel: ViewModel {
    
    private let wishUseCase = DIContainer.shared.resolve(WishUseCase.self)
    
    struct Input {
        let didFeedbackSendTap: PublishRelay<String>
    }
    
    struct Output {
        let error: Signal<Error>
        let feedbackSuccess: Signal<Void>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<NotificationNavigation>()
    
    let error = PublishRelay<Error>()
    let feedbackSuccess = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        
        transformFeedback(feedback: input.didFeedbackSendTap)
        
        return Output(
            error: error.asSignal(),
            feedbackSuccess: feedbackSuccess.asSignal())
    }
    
    private func transformFeedback(feedback: PublishRelay<String>) {
        feedback
            .withUnretained(self)
            .flatMap { this, message in
                this.wishUseCase.wish(message: message)
                    .asObservable()
                    .catch { error in
                        this.error.accept(error)
                        return .empty()
                    }
            }
            .map { _ in return () }
            .bind(to: feedbackSuccess)
            .disposed(by: disposeBag)
        
    }
}

