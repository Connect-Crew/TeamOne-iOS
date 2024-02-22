
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SplashFeature",
    targets: Set(FeatureTarget.microFeature),
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)

