import DiveKitCatalogSyncCore
import Foundation
import Testing

@Suite
struct CatalogSynchronizerTests {
    @Test func syncCopiesSourceCatalogWhenTargetDoesNotExist() throws {
        // Given
        try withTemporaryDirectory { temporaryDirectoryURL in
            let sut = CatalogSynchronizer()
            let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
                "dive.kit.first": "First",
                "dive.kit.second": "Second"
            ], in: temporaryDirectoryURL)
            let targetURL = temporaryDirectoryURL.appendingPathComponent("Target.xcstrings")

            // When
            let result = try sut.sync(source: sourceURL, target: targetURL)

            // Then
            #expect(result.action == .copied)
            #expect(result.addedKeys == [
                "dive.kit.first",
                "dive.kit.second"
            ])
            #expect(try Data(contentsOf: targetURL) == Data(contentsOf: sourceURL))
        }
    }

    @Test func syncAddsOnlyMissingKeysWhenTargetExists() throws {
        // Given
        try withTemporaryDirectory { temporaryDirectoryURL in
            let sut = CatalogSynchronizer()
            let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
                "dive.kit.existing": "Package default",
                "dive.kit.missing": "New package default"
            ], in: temporaryDirectoryURL)
            let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [
                "app.only": "App only",
                "dive.kit.existing": "Host override"
            ], in: temporaryDirectoryURL)

            // When
            let result = try sut.sync(source: sourceURL, target: targetURL)
            let strings = try loadStrings(at: targetURL)

            // Then
            #expect(result.action == .merged)
            #expect(result.addedKeys == [
                "dive.kit.missing"
            ])
            #expect(value(for: "dive.kit.existing", in: strings) == "Host override")
            #expect(value(for: "dive.kit.missing", in: strings) == "New package default")
            #expect(value(for: "app.only", in: strings) == "App only")
        }
    }

    @Test func syncDoesNotRewriteWhenNoKeysAreMissing() throws {
        // Given
        try withTemporaryDirectory { temporaryDirectoryURL in
            let sut = CatalogSynchronizer()
            let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
                "dive.kit.existing": "Package default"
            ], in: temporaryDirectoryURL)
            let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [
                "dive.kit.existing": "Host override"
            ], in: temporaryDirectoryURL)
            let originalTargetData = try Data(contentsOf: targetURL)

            // When
            let result = try sut.sync(source: sourceURL, target: targetURL)

            // Then
            #expect(result.action == .unchanged)
            #expect(result.addedKeys == [])
            #expect(try Data(contentsOf: targetURL) == originalTargetData)
        }
    }

    @Test func dryRunReportsMissingKeysWithoutWriting() throws {
        // Given
        try withTemporaryDirectory { temporaryDirectoryURL in
            let sut = CatalogSynchronizer()
            let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
                "dive.kit.missing": "New package default"
            ], in: temporaryDirectoryURL)
            let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [:], in: temporaryDirectoryURL)
            let originalTargetData = try Data(contentsOf: targetURL)

            // When
            let result = try sut.sync(source: sourceURL, target: targetURL, dryRun: true)

            // Then
            #expect(result.action == .wouldMerge)
            #expect(result.addedKeys == [
                "dive.kit.missing"
            ])
            #expect(try Data(contentsOf: targetURL) == originalTargetData)
        }
    }

    private func withTemporaryDirectory<Result>(_ operation: (URL) throws -> Result) throws -> Result {
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: temporaryDirectoryURL,
            withIntermediateDirectories: true
        )

        do {
            let result = try operation(temporaryDirectoryURL)
            try FileManager.default.removeItem(at: temporaryDirectoryURL)

            return result
        } catch {
            try? FileManager.default.removeItem(at: temporaryDirectoryURL)
            throw error
        }
    }

    private func writeCatalog(
        named name: String,
        keys: [String: String],
        in temporaryDirectoryURL: URL) throws -> URL {
        let url = temporaryDirectoryURL.appendingPathComponent(name)
        let strings = keys.reduce(into: [String: Any]()) { result, element in
            result[element.key] = [
                "extractionState": "manual",
                "localizations": [
                    "en": [
                        "stringUnit": [
                            "state": "translated",
                            "value": element.value
                        ]
                    ]
                ]
            ]
        }
        let catalog: [String: Any] = [
            "sourceLanguage": "en",
            "strings": strings,
            "version": "1.0"
        ]
        let data = try JSONSerialization.data(
            withJSONObject: catalog,
            options: [
                .prettyPrinted,
                .sortedKeys
            ]
        )
        try data.write(to: url)

        return url
    }

    private func loadStrings(at url: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        let object = try JSONSerialization.jsonObject(with: data)
        let catalog = try #require(object as? [String: Any])

        return try #require(catalog["strings"] as? [String: Any])
    }

    private func value(for key: String, in strings: [String: Any]) -> String? {
        let entry = strings[key] as? [String: Any]
        let localizations = entry?["localizations"] as? [String: Any]
        let english = localizations?["en"] as? [String: Any]
        let stringUnit = english?["stringUnit"] as? [String: Any]

        return stringUnit?["value"] as? String
    }
}
