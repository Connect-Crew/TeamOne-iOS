
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ReportFeature",
    targets: Set(FeatureTarget.microFeature),
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)

