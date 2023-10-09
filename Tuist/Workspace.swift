//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin

// MARK: - Project

let workspace = Workspace(
    name: Environment.workspaceName,
    projects: [
        "Projects/**"
    ]
)

