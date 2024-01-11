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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<NotificationNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

