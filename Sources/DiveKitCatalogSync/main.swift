import ArgumentParser
import DiveKitCatalogSyncCore
import Foundation

struct DiveKitCatalogSync: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "divekit-catalog-sync",
        abstract: "Synchronize missing DiveKit string catalog keys into a host app catalog."
    )

    @Option(
        name: .shortAndLong,
        help: "The DiveKit .xcstrings catalog to copy missing keys from."
    )
    var source = "Sources/DiveKitLocalization/Resources/Localizable.xcstrings"

    @Option(
        name: .shortAndLong,
        help: "The host app .xcstrings catalog to update."
    )
    var target: String

    @Flag(
        name: .long,
        help: "Report what would change without writing to the target catalog."
    )
    var dryRun = false

    mutating func run() throws {
        let synchronizer = CatalogSynchronizer()
        let result = try synchronizer.sync(
            source: URL.expandingPath(source),
            target: URL.expandingPath(target),
            dryRun: dryRun
        )

        print(summary(for: result))
    }

    private func summary(for result: CatalogSyncResult) -> String {
        switch result.action {
            case .copied:
                "Copied \(result.sourceKeyCount) keys into \(target)."
            case .merged:
                "Added \(result.addedKeys.count) missing keys into \(target):\n\(formattedAddedKeys(result.addedKeys))"
            case .unchanged:
                "Catalog already in sync. \(target) has all \(result.sourceKeyCount) DiveKit keys."
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
}
