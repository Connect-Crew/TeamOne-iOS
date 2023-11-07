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

    public func register<T>(interface: T.Type, implement: @escaping ((Resolver) -> T)) {
        container.register(interface, factory: implement)
    }

    public func resolve<T>(_ serviceType: T.Type) -> T {

        if container.resolve(serviceType) == nil {
            print("!!!!!DIContainer Error Type is \(serviceType)")
        }

        return container.resolve(serviceType)!
    }
}


