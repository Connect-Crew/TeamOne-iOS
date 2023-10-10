//
//  DIContainer.swift
//  CoreTests
//
//  Created by 강현준 on 2023/10/10.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Swinject

public final class DIContainer {
    
    public static let shared = DIContainer()
    private let container: Container
    
    private init() {
        self.container = Container()
    }
}


