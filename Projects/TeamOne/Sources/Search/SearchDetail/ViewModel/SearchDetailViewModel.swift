//
//  SearchDetailViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum SearchDetailNavigation {
    case finish
}

final class SearchDetailViewModel: ViewModel {
 
    public let searchKeyword = BehaviorSubject<String>(value: "")
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<SearchDetailNavigation>()
    
    func transform(input: Input) -> Output {
        
        self.searchKeyword
            .subscribe(onNext: { keyword in
                print("keyword : \(keyword)")
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
