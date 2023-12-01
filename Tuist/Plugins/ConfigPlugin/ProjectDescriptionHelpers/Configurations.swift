//
//  Configurations.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

public struct XCConfig {
    private struct Path {
        static var framework: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig") }
        static var demo: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Demo.xcconfig") }
        static var tests: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Tests.xcconfig") }
        static func project(_ config: String) -> ProjectDescription.Path { .relativeToRoot("xcconfigs/Base/Projects/Project-\(config).xcconfig") }
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.framework),
        .release(name: "PROD", xcconfig: Path.framework),
    ]
    
    public static let tests: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.tests),
        .release(name: "PROD", xcconfig: Path.tests),
    ]
    
    public static let project: [Configuration] = [
        .debug(name: "DEV", xcconfig: Path.project("DEV")),
        .release(name: "PROD", xcconfig: Path.project("PROD")),
    ]
}
