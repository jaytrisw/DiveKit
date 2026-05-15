import Foundation
import PackagePlugin

@main
struct DiveKitCatalogSyncPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        try runCatalogSync(
            toolURL: context.tool(named: "catalog-sync").url,
            workingDirectoryURL: context.package.directoryURL,
            arguments: arguments
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension DiveKitCatalogSyncPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try runCatalogSync(
            toolURL: context.tool(named: "catalog-sync").url,
            workingDirectoryURL: context.xcodeProject.directoryURL,
            arguments: normalizedXcodeArguments(arguments)
        )
    }
}
#endif

private func runCatalogSync(
    toolURL: URL,
    workingDirectoryURL: URL,
    arguments: [String]) throws {
    let process = Process()
    process.currentDirectoryURL = workingDirectoryURL
    process.executableURL = toolURL
    process.arguments = arguments

    try process.run()
    process.waitUntilExit()

    guard process.terminationReason == .exit,
          process.terminationStatus == EXIT_SUCCESS else {
        throw CatalogSyncPluginError.toolFailed(process.terminationStatus)
    }
}

private func normalizedXcodeArguments(_ arguments: [String]) -> [String] {
    var normalizedArguments: [String] = []
    var target: String?
    var index = arguments.startIndex

    while index < arguments.endIndex {
        let argument = arguments[index]

        if argument.hasPrefix("--target=") {
            target = String(argument.dropFirst("--target=".count))
            index = arguments.index(after: index)
        } else if argument.hasPrefix("--source=") {
            normalizedArguments.append(argument)
            index = arguments.index(after: index)
        } else {
            switch argument {
                case "--target", "-t":
                    let valueIndex = arguments.index(after: index)
                    if valueIndex < arguments.endIndex {
                        target = arguments[valueIndex]
                        index = arguments.index(after: valueIndex)
                    } else {
                        normalizedArguments.append(argument)
                        index = valueIndex
                    }
                case "--source", "-s":
                    normalizedArguments.append(argument)

                    let valueIndex = arguments.index(after: index)
                    if valueIndex < arguments.endIndex {
                        normalizedArguments.append(arguments[valueIndex])
                        index = arguments.index(after: valueIndex)
                    } else {
                        index = valueIndex
                    }
                case "--dry-run":
                    normalizedArguments.append(argument)
                    index = arguments.index(after: index)
                default:
                    if target == nil, argument.hasSuffix(".xcstrings") {
                        target = argument
                    } else if argument.hasPrefix("-") {
                        normalizedArguments.append(argument)
                    }

                    index = arguments.index(after: index)
            }
        }
    }

    if let target {
        normalizedArguments.append(contentsOf: [
            "--target",
            target
        ])
    }

    return normalizedArguments
}

private enum CatalogSyncPluginError: Error, CustomStringConvertible, LocalizedError {
    case toolFailed(Int32)

    var description: String {
        switch self {
            case let .toolFailed(status):
                "catalog-sync failed with exit code \(status)"
        }
    }

    var errorDescription: String? {
        description
    }
}
