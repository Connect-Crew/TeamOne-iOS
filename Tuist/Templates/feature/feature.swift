//
//  feature.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 2/20/24.
//

import Foundation

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Feature module template",
    attributes: [
        nameAttribute
    ],
    items: [
        // MARK: Project
        .file(path: "Projects/Features/\(nameAttribute)/Project.swift",
              templatePath: "project.stencil"),
        
        // MARK: Sources
        .file(path: "Projects/Features/\(nameAttribute)/Sources/.gitkeep",
              templatePath: "empty.stencil"),
        
        // MARK: Tests
        .file(path: "Projects/Features/\(nameAttribute)/Tests/Resources/.gitkeep",
              templatePath: "empty.stencil"),
        .file(path: "Projects/Features/\(nameAttribute)/Tests/Sources/.gitkeep",
              templatePath: "empty.stencil"),
        
        // MARK: Testing
            .file(path: "Projects/Features/\(nameAttribute)/Testing/Resources/.gitkeep",
                  templatePath: "empty.stencil"),
            .file(path: "Projects/Features/\(nameAttribute)/Testing/Sources/.gitkeep",
                  templatePath: "empty.stencil"),
        
        // MARK: Example
            .file(path: "Projects/Features/\(nameAttribute)/Deomo/Resources/.gitkeep",
                  templatePath: "empty.stencil"),
            .file(path: "Projects/Features/\(nameAttribute)/Deomo/Sources/AppDelegate.swift",
                  templatePath: "appDelegate.stencil"),
            .file(path: "Projects/Features/\(nameAttribute)/Deomo/Sources/SceneDelegate.swift",
                  templatePath: "sceneDelegate.stencil"),
        .file(path: "Projects/Features/\(nameAttribute)/Deomo/ReSources/Launch Screen.storyboard",
              templatePath: "storyboard.stencil"),
        
        // MARK: Interface
            .file(path: "Projects/Features/\(nameAttribute)/Interface/.gitkeep",
                  templatePath: "empty.stencil")
    ]
)
