import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("/Tuist/Plugins/DependencyPlugin")),
        .local(path: .relativeToRoot("/Tuist/Plugins/ConfigPlugin")),
        .local(path: .relativeToRoot("/Tuist/Plugins/EnvPlugin")),
    ]
)
