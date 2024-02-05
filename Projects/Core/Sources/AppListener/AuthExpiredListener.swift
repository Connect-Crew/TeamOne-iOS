//
//  AuthExpiredListener.swift
//  Core
//
//  Created by 강현준 on 2/5/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol AuthExpiredListener {
    var authExpiredListener: PublishRelay<Void> { get }
}

