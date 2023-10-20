//
//  ViewModel.swift
//  CoreTests
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ViewModel {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
