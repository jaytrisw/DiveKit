import Foundation

public struct CatalogSynchronizer {
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public func sync(source sourceURL: URL, target targetURL: URL, dryRun: Bool = false) throws -> CatalogSyncResult {
        try validateSourceCatalog(at: sourceURL)
        try validateTargetLocation(at: targetURL)

        guard fileManager.fileExists(atPath: targetURL.path) else {
            return try copyCatalog(source: sourceURL, target: targetURL, dryRun: dryRun)
        }

        let sourceCatalog = try loadCatalog(at: sourceURL)
        var targetCatalog = try loadCatalog(at: targetURL)
        let sourceStrings = try strings(in: sourceCatalog, catalogURL: sourceURL)
        var targetStrings = try strings(in: targetCatalog, catalogURL: targetURL)
        let targetKeyCountBeforeSync = targetStrings.count
        let addedKeys = sourceStrings.keys
            .filter { targetStrings[$0] == nil }
            .sorted()

        guard !addedKeys.isEmpty else {
            return CatalogSyncResult(
                action: .unchanged,
                sourceKeyCount: sourceStrings.count,
                targetKeyCountBeforeSync: targetKeyCountBeforeSync,
                targetKeyCountAfterSync: targetKeyCountBeforeSync,
                addedKeys: []
            )
        }

        for key in addedKeys {
            targetStrings[key] = sourceStrings[key]
        }

        if dryRun {
            return CatalogSyncResult(
                action: .wouldMerge,
                sourceKeyCount: sourceStrings.count,
                targetKeyCountBeforeSync: targetKeyCountBeforeSync,
                targetKeyCountAfterSync: targetKeyCountBeforeSync + addedKeys.count,
                addedKeys: addedKeys
            )
        }

        targetCatalog["strings"] = targetStrings
        try writeCatalog(targetCatalog, to: targetURL)

        return CatalogSyncResult(
            action: .merged,
            sourceKeyCount: sourceStrings.count,
            targetKeyCountBeforeSync: targetKeyCountBeforeSync,
            targetKeyCountAfterSync: targetKeyCountBeforeSync + addedKeys.count,
            addedKeys: addedKeys
        )
    }

    private func copyCatalog(source sourceURL: URL, target targetURL: URL, dryRun: Bool) throws -> CatalogSyncResult {
        let sourceCatalog = try loadCatalog(at: sourceURL)
        let sourceStrings = try strings(in: sourceCatalog, catalogURL: sourceURL)
        let keys = sourceStrings.keys.sorted()

        if dryRun {
            return CatalogSyncResult(
                action: .wouldCopy,
                sourceKeyCount: keys.count,
                targetKeyCountBeforeSync: 0,
                targetKeyCountAfterSync: keys.count,
                addedKeys: keys
            )
        }

        try fileManager.copyItem(at: sourceURL, to: targetURL)

        return CatalogSyncResult(
            action: .copied,
            sourceKeyCount: keys.count,
            targetKeyCountBeforeSync: 0,
            targetKeyCountAfterSync: keys.count,
            addedKeys: keys
        )
    }

    private func validateSourceCatalog(at url: URL) throws {
        var isDirectory: ObjCBool = false

        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            throw CatalogSyncError.sourceCatalogNotFound(url)
        }

        if isDirectory.boolValue {
            throw CatalogSyncError.sourceCatalogIsDirectory(url)
        }
    }

    private func validateTargetLocation(at url: URL) throws {
        var isDirectory: ObjCBool = false

        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
            throw CatalogSyncError.targetCatalogIsDirectory(url)
        }

        let directoryURL = url.deletingLastPathComponent()
        var targetDirectoryIsDirectory: ObjCBool = false

        guard fileManager.fileExists(atPath: directoryURL.path, isDirectory: &targetDirectoryIsDirectory),
              targetDirectoryIsDirectory.boolValue else {
            throw CatalogSyncError.targetDirectoryNotFound(directoryURL)
        }
    }

    private func loadCatalog(at url: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        let object = try JSONSerialization.jsonObject(with: data, options: [])

        guard let catalog = object as? [String: Any] else {
            throw CatalogSyncError.invalidCatalog(url, "root object must be a JSON dictionary")
        }

        _ = try strings(in: catalog, catalogURL: url)

        return catalog
    }

    private func strings(in catalog: [String: Any], catalogURL: URL) throws -> [String: Any] {
        guard let strings = catalog["strings"] as? [String: Any] else {
            throw CatalogSyncError.invalidCatalog(catalogURL, "\"strings\" must be a JSON dictionary")
        }

        return strings
    }

    private func writeCatalog(_ catalog: [String: Any], to url: URL) throws {
        var data = try JSONSerialization.data(
            withJSONObject: catalog,
            options: [
                .prettyPrinted,
                .sortedKeys,
                .withoutEscapingSlashes
            ]
        )
        data.append(0x0A)
        try data.write(to: url, options: .atomic)
    }
}
