//
//  Script.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/14.
//

import Foundation
import ProjectDescription

//public extension TargetScript {
//    static let SwiftLintString = TargetScript.pre(script: """
//if test -d "/opt/homebrew/bin/"; then
//    PATH="/opt/homebrew/bin/:${PATH}"
//fi
//
//export PATH
//
//if which swiftlint > /dev/null; then
//    swiftlint autocorrect && swiftlint
//else
//    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
//fi
//""", name: "SwiftLintString", basedOnDependencyAnalysis: false
//    )
//}
