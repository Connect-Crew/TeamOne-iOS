//
//  TosViewModel.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

enum TosNavigation {

}

final class TosViewModel: ViewModel {

    
    struct Input {

    }

    struct Output {

    }

    let navigation = PublishSubject<TosNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        return Output()
    }
}


