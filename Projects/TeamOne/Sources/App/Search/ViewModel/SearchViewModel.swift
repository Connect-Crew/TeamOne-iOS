//
//  SearchViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum SearchNavigation {
    case finish
    case search(String)
}

final class SearchViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<SearchNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
