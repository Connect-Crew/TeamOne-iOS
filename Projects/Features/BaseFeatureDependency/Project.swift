//
//  Project.swift
//  DependencyPlugin
//
//  Created by Junyoung Lee on 2023/08/11.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "BaseFeatureDependency",
    targets: [.dynamicFramework],
    internalDependencies: [
        .domain,
        .Modules.dsKit
    ]
)
