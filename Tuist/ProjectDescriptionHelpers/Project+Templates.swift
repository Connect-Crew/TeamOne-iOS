import ProjectDescription
import Foundation
import EnvPlugin
import ConfigPlugin

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {
    static func makeModule(
        name: String,
        targets: Set<FeatureTarget> = Set([.staticFramework, .unitTest]),
        packages: [Package] = [],
        internalDependencies: [TargetDependency] = [], // 모듈간 의존성
        externalDependencies: [TargetDependency] = [], // 외부 라이브러리 의존성
        interfaceDependencies: [TargetDependency] = [], // Feature Interface 의존성
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false,
        infoPlist: [String: InfoPlist.Value] = Project.appInfoPlist
    ) -> Project {
        let configurationName: ConfigurationName = "DEV"
        let hasDynamicFramework = targets.contains(.dynamicFramework)
        let deploymentTarget = Environment.deploymentTarget
        let platform = Environment.platform

        let baseSettings: SettingsDictionary = .baseSettings

        var projectTargets: [Target] = []
        var schemes: [Scheme] = []

        if targets.contains(.app) {
            let bundleSuffix = name
            let settings = baseSettings

            let target = Target(name: name,
                                platform: platform,
                                product: .app,
                                bundleId: "\(Environment.bundlePrefix).\(bundleSuffix)",
                                deploymentTarget: deploymentTarget,
                                infoPlist: .extendingDefault(with: infoPlist),
                                sources: "Sources/**/*.swift",
                                resources: [.glob(pattern: "Resources/**", excluding: [])],
                                entitlements: "\(name).entitlements",
                                scripts: [
                                    .pre(path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"), arguments: [], name: "SwiftLint"),
                                    .post(path: .relativeToRoot("Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run"), arguments: [], name: "Firebase Crashlytics")],
                                dependencies: [
                                    internalDependencies,
                                    externalDependencies,
                                ].flatMap { $0 },
                                settings: .settings(base: settings, configurations: XCConfig.project)
//                                settings: .settings(
//                                    configurations:[
//                                        .debug(name: "DEV",
//                                              settings: [
//                                                "CODE_SIGN_IDENTITY": "Apple Development",
//                                                "PROVISIONING_PROFILE_SPECIFIER": "match Development com.connectCrew.TeamOne",
//                                                "CODE_SIGN_STYLE": "Manual"
//                                              ],
//                                               xcconfig: XCConfig.project),
//                                        )
//                                    ]
//                                )
            )
            projectTargets.append(target)
        }

        // MARK: - Unit Tests
        if targets.contains(.unitTest) {
            let deps: [TargetDependency] = [.target(name: name)]

            let target = Target(
                name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "\(Environment.bundlePrefix).\(name)Tests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/Sources/**/*.swift"],
                resources: [.glob(pattern: "Tests/Resources/**", excluding: [])],
                dependencies: [
                    deps,
                    [

                    ]
                ].flatMap { $0 },
                settings: .settings(base: SettingsDictionary().setCodeSignManual(), configurations: XCConfig.tests)
            )
        }

        // MARK: - Framework
        if targets.contains(where: { $0.hasFramework }) {

            let settings = baseSettings

            let target = Target(
                name: name,
                platform: platform,
                product: hasDynamicFramework ? .framework : .staticFramework,
                bundleId: "\(Environment.bundlePrefix).\(name)",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Sources/**/*.swift"],
                resources: hasResources ? [.glob(pattern: "Resources/**", excluding: [])] : [],
                dependencies: internalDependencies + externalDependencies,
                settings: .settings(base: settings, configurations: XCConfig.framework)
            )

            projectTargets.append(target)
        }

        // MARK: - Scheme
        //        let additionalSchemes = targets.contains(.demo)
        //                ? [Scheme.makeScheme(configs: configurationName, name: name),
        //                   Scheme.makeDemoScheme(configs: configurationName, name: name)]
        //                : [Scheme.makeScheme(configs: configurationName, name: name)]
        //                schemes += additionalSchemes

        var scheme = targets.contains(.app)
        ? appSchemes
        : schemes

        return Project(
            name: name,
            organizationName: Environment.workspaceName,
            packages: packages,
            settings: .settings(configurations: XCConfig.project),
            targets: projectTargets,
            schemes: schemes
        )
    }
}

// MARK: - Scheme Extension
extension Scheme {
    /// Scheme 생성하는 method
    static func makeScheme(configs: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configs,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: configs),
            archiveAction: .archiveAction(configuration: configs),
            profileAction: .profileAction(configuration: configs),
            analyzeAction: .analyzeAction(configuration: configs)
        )
    }

    static func makeDemoScheme(configs: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: "\(name)Demo",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configs,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)Demo"])
            ),
            runAction: .runAction(configuration: configs),
            archiveAction: .archiveAction(configuration: configs),
            profileAction: .profileAction(configuration: configs),
            analyzeAction: .analyzeAction(configuration: configs)
        )
    }
}

extension Project {
    static let appSchemes: [Scheme] = [
        // DEV API, debug scheme
        .init(
            name: "\(Environment.workspaceName)-DEV",
            shared: true,
            buildAction: .buildAction(targets: ["\(Environment.workspaceName)"]),
            testAction: .targets(
                ["\(Environment.workspaceName)Tests", "\(Environment.workspaceName)UITests"],
                configuration: "DEV",
                options: .options(coverage: true, codeCoverageTargets: ["\(Environment.workspaceName)"])
            ),
            runAction: .runAction(configuration: "DEV"),
            archiveAction: .archiveAction(configuration: "DEV"),
            profileAction: .profileAction(configuration: "DEV"),
            analyzeAction: .analyzeAction(configuration: "DEV")
        ),
        // PROD API, release scheme
        .init(
            name: "\(Environment.workspaceName)-PROD",
            shared: true,
            buildAction: .buildAction(targets: ["\(Environment.workspaceName)"]),
            runAction: .runAction(configuration: "PROD"),
            archiveAction: .archiveAction(configuration: "PROD"),
            profileAction: .profileAction(configuration: "PROD"),
            analyzeAction: .analyzeAction(configuration: "PROD")
        )
    ]
}
