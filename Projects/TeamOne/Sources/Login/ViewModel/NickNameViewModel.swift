//
//  NickNameViewModel.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

enum NickNameNavigation {

}

final class NickNameViewModel: ViewModel {

    
    struct Input {

    }

    struct Output {

    }

    let navigation = PublishSubject<NickNameNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        return Output()
    }
}


