//
//  AppListener.swift
//  TeamOne
//
//  Created by 강현준 on 2/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

final class AppListener: AuthExpiredListener {
    
    private init () {}
    
    public static var shared = AppListener()
    
    public var authExpiredListener = PublishRelay<Void>()
}
