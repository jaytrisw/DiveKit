import Foundation
import PackagePlugin

@main
struct DiveKitCatalogSyncPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        try runCatalogSync(
            toolURL: context.tool(named: "catalog-sync").url,
            workingDirectoryURL: context.package.directoryURL,
            arguments: arguments)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension DiveKitCatalogSyncPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        // Plugins cannot import DiveKitCatalogSyncCore, so catalog-sync
        // normalizes Xcode's arguments when this variable is set. It matches
        // `XcodeArguments.environmentKey`.
        try runCatalogSync(
            toolURL: context.tool(named: "catalog-sync").url,
            workingDirectoryURL: context.xcodeProject.directoryURL,
            arguments: arguments,
            environment: ["DIVEKIT_CATALOG_SYNC_XCODE_ARGUMENTS": "1"])
    }
}
#endif

private func runCatalogSync(
    toolURL: URL,
    workingDirectoryURL: URL,
    arguments: [String],
    environment: [String: String] = [:]) throws {
        let process = Process()
        process.currentDirectoryURL = workingDirectoryURL
        process.executableURL = toolURL
        process.arguments = arguments
        process.environment = ProcessInfo.processInfo.environment.merging(environment) { $1 }

        try process.run()
        process.waitUntilExit()

        guard process.terminationReason == .exit,
              process.terminationStatus == EXIT_SUCCESS else {
            throw CatalogSyncPluginError.toolFailed(process.terminationStatus)
        }
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
