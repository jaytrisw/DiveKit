import DiveKitCatalogSyncCore
import XCTest

final class CatalogSynchronizerTestCase: XCTestCase {
    private var temporaryDirectoryURL: URL!
    private var sut: CatalogSynchronizer!

    override func setUpWithError() throws {
        try super.setUpWithError()

        temporaryDirectoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(
            at: temporaryDirectoryURL,
            withIntermediateDirectories: true
        )
        sut = CatalogSynchronizer()
    }

    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: temporaryDirectoryURL)
        sut = nil
        temporaryDirectoryURL = nil

        try super.tearDownWithError()
    }

    func testSyncCopiesSourceCatalogWhenTargetDoesNotExist() throws {
        // Given
        let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
            "dive.kit.first": "First",
            "dive.kit.second": "Second"
        ])
        let targetURL = temporaryDirectoryURL.appendingPathComponent("Target.xcstrings")

        // When
        let result = try sut.sync(source: sourceURL, target: targetURL)

        // Then
        XCTAssertEqual(result.action, .copied)
        XCTAssertEqual(result.addedKeys, [
            "dive.kit.first",
            "dive.kit.second"
        ])
        XCTAssertEqual(try Data(contentsOf: targetURL), try Data(contentsOf: sourceURL))
    }

    func testSyncAddsOnlyMissingKeysWhenTargetExists() throws {
        // Given
        let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
            "dive.kit.existing": "Package default",
            "dive.kit.missing": "New package default"
        ])
        let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [
            "app.only": "App only",
            "dive.kit.existing": "Host override"
        ])

        // When
        let result = try sut.sync(source: sourceURL, target: targetURL)
        let strings = try loadStrings(at: targetURL)

        // Then
        XCTAssertEqual(result.action, .merged)
        XCTAssertEqual(result.addedKeys, [
            "dive.kit.missing"
        ])
        XCTAssertEqual(value(for: "dive.kit.existing", in: strings), "Host override")
        XCTAssertEqual(value(for: "dive.kit.missing", in: strings), "New package default")
        XCTAssertEqual(value(for: "app.only", in: strings), "App only")
    }

    func testSyncDoesNotRewriteWhenNoKeysAreMissing() throws {
        // Given
        let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
            "dive.kit.existing": "Package default"
        ])
        let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [
            "dive.kit.existing": "Host override"
        ])
        let originalTargetData = try Data(contentsOf: targetURL)

        // When
        let result = try sut.sync(source: sourceURL, target: targetURL)

        // Then
        XCTAssertEqual(result.action, .unchanged)
        XCTAssertEqual(result.addedKeys, [])
        XCTAssertEqual(try Data(contentsOf: targetURL), originalTargetData)
    }

    func testDryRunReportsMissingKeysWithoutWriting() throws {
        // Given
        let sourceURL = try writeCatalog(named: "Source.xcstrings", keys: [
            "dive.kit.missing": "New package default"
        ])
        let targetURL = try writeCatalog(named: "Target.xcstrings", keys: [:])
        let originalTargetData = try Data(contentsOf: targetURL)

        // When
        let result = try sut.sync(source: sourceURL, target: targetURL, dryRun: true)

        // Then
        XCTAssertEqual(result.action, .wouldMerge)
        XCTAssertEqual(result.addedKeys, [
            "dive.kit.missing"
        ])
        XCTAssertEqual(try Data(contentsOf: targetURL), originalTargetData)
    }

    private func writeCatalog(named name: String, keys: [String: String]) throws -> URL {
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
        let catalog = try XCTUnwrap(object as? [String: Any])

        return try XCTUnwrap(catalog["strings"] as? [String: Any])
    }

    private func value(for key: String, in strings: [String: Any]) -> String? {
        let entry = strings[key] as? [String: Any]
        let localizations = entry?["localizations"] as? [String: Any]
        let english = localizations?["en"] as? [String: Any]
        let stringUnit = english?["stringUnit"] as? [String: Any]

        return stringUnit?["value"] as? String
    }
}
