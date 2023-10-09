//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TeamOne",
    targets: [.app, .unitTest],
    internalDependencies: [
        .domain,
        .Modules.dsKit
    ]
)

