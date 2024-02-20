//
//  FeatureTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/06.
//

import Foundation
import ProjectDescription

public enum FeatureTarget {
    case app                // iOSApp
    case dynamicFramework
    case staticFramework
    case unitTest           // Unit Test
    case demo               // Feature Excutable Test
    case testing
    case interface

    public static var microFeature: [Self] {
        return [
            .dynamicFramework,
            .interface,
            .demo,
            .testing,
            .unitTest
        ]
    }
    
    public var hasFramework: Bool {
        switch self {
        case .dynamicFramework, .staticFramework: return true
        default: return false
        }
    }
    public var hasDynamicFramework: Bool { return self == .dynamicFramework }
}
