import ArgumentParser
import DiveKitCatalogSyncCore
import Foundation

struct DiveKitCatalogSync: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "catalog-sync",
        abstract: "Copy missing DiveKit string catalog keys into a host app catalog."
    )

    @Option(
        name: .shortAndLong,
        help: "The DiveKit .xcstrings catalog to copy missing keys from. Defaults to DiveKit's package catalog."
    )
    var source: String?

    @Option(
        name: .shortAndLong,
        help: "The host app .xcstrings catalog to add missing keys to."
    )
    var target: String?

    @Argument(
        help: "The host app .xcstrings catalog to add missing keys to. This is a shorthand for --target."
    )
    var targetPath: String?

    @Flag(
        name: .long,
        help: "Report what would change without writing to the target catalog."
    )
    var dryRun = false

    mutating func validate() throws {
        _ = try resolvedTarget()
    }

    mutating func run() throws {
        let target = try resolvedTarget()
        let synchronizer = CatalogSynchronizer()
        let result = try synchronizer.sync(
            source: source.map(URL.expandingPath) ?? .diveKitSourceCatalog,
            target: URL.expandingPath(target),
            dryRun: dryRun
        )

        print(summary(for: result, target: target))
    }

    private func resolvedTarget() throws -> String {
        if let target, targetPath == nil {
            return target
        }

        if let targetPath, target == nil {
            return targetPath
        }

        if target != nil, targetPath != nil {
            throw ValidationError("Specify the target catalog either with --target or as a positional path, not both.")
        }

        throw ValidationError("Missing target catalog. Provide --target <path> or a positional .xcstrings path.")
    }

    private func summary(for result: CatalogSyncResult, target: String) -> String {
        switch result.action {
            case .copied:
                "Copied \(result.sourceKeyCount) keys into \(target)."
            case .merged:
                "Added \(result.addedKeys.count) missing keys into \(target):\n\(formattedAddedKeys(result.addedKeys))"
            case .unchanged:
                "No missing DiveKit keys found in \(target). Existing keys were not changed."
            case .wouldCopy:
                "Would copy \(result.sourceKeyCount) keys into \(target)."
            case .wouldMerge:
                "Would add \(result.addedKeys.count) missing keys into \(target):\n\(formattedAddedKeys(result.addedKeys))"
        }
    }

    private func formattedAddedKeys(_ keys: [String]) -> String {
        keys.map { "  \($0)" }.joined(separator: "\n")
    }
}

DiveKitCatalogSync.main()

private extension URL {
    static func expandingPath(_ path: String) -> URL {
        URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
    }

    static var diveKitSourceCatalog: URL {
        let packageURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        return packageURL
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("DiveKitLocalization", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("Localizable.xcstrings")
    }
}
