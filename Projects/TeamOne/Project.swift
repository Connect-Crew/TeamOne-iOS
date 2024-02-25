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
    targets: [.app],
    internalDependencies: [
        .data,
        .Features.RootFeature,
        .Features.Splash.Feature,
        .Features.Report.Feature
    ]
)
