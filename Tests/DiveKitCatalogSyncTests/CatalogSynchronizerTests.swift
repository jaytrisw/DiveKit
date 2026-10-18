import DiveKitCatalogSyncCore
import DiveKitTestSupport
import Foundation
import Testing

@Suite("Catalog synchronizer", .tags(.catalogSync))
struct CatalogSynchronizerTests {
    @Test func syncCopiesSourceCatalogWhenTargetDoesNotExist() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                (source: try writeCatalog(named: "Source.xcstrings", keys: [
                    "dive.kit.first": "First",
                    "dive.kit.second": "Second"
                ], in: directory),
                 target: directory.appendingPathComponent("Target.xcstrings"))
            } when: { input in
                try CatalogSynchronizer().sync(source: input.source, target: input.target)
            } then: { input, result in
                #expect(result.action == .copied)
                #expect(result.addedKeys == [
                    "dive.kit.first",
                    "dive.kit.second"
                ])
                let (target, source) = (try Data(contentsOf: input.target), try Data(contentsOf: input.source))
                #expect(target == source)
            }
        }
    }

    @Test func dryRunReportsCopyWithoutWriting() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                (source: try writeCatalog(named: "Source.xcstrings", keys: [
                    "dive.kit.first": "First",
                    "dive.kit.second": "Second"
                ], in: directory),
                 target: directory.appendingPathComponent("Target.xcstrings"))
            } when: { input in
                try CatalogSynchronizer().sync(source: input.source, target: input.target, dryRun: true)
            } then: { input, result in
                #expect(result.action == .wouldCopy)
                #expect(result.addedKeys == [
                    "dive.kit.first",
                    "dive.kit.second"
                ])
                #expect(result.targetKeyCountAfterSync == 2)
                #expect(!FileManager.default.fileExists(atPath: input.target.path))
            }
        }
    }

    @Test func syncAddsOnlyMissingKeysWhenTargetExists() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                (source: try writeCatalog(named: "Source.xcstrings", keys: [
                    "dive.kit.existing": "Package default",
                    "dive.kit.missing": "New package default"
                ], in: directory),
                 target: try writeCatalog(named: "Target.xcstrings", keys: [
                    "app.only": "App only",
                    "dive.kit.existing": "Host override"
                 ], in: directory))
            } when: { input in
                (result: try CatalogSynchronizer().sync(source: input.source, target: input.target),
                 strings: try loadStrings(at: input.target))
            } then: { _, output in
                #expect(output.result.action == .merged)
                #expect(output.result.addedKeys == [
                    "dive.kit.missing"
                ])
                #expect(value(for: "dive.kit.existing", in: output.strings) == "Host override")
                #expect(value(for: "dive.kit.missing", in: output.strings) == "New package default")
                #expect(value(for: "app.only", in: output.strings) == "App only")
            }
        }
    }

    @Test func syncDoesNotRewriteWhenNoKeysAreMissing() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                let target = try writeCatalog(named: "Target.xcstrings", keys: [
                    "dive.kit.existing": "Host override"
                ], in: directory)
                return (source: try writeCatalog(named: "Source.xcstrings", keys: [
                    "dive.kit.existing": "Package default"
                ], in: directory),
                        target: target,
                        originalTarget: try Data(contentsOf: target))
            } when: { input in
                try CatalogSynchronizer().sync(source: input.source, target: input.target)
            } then: { input, result in
                #expect(result.action == .unchanged)
                #expect(result.addedKeys == [])
                let target = try Data(contentsOf: input.target)
                #expect(target == input.originalTarget)
            }
        }
    }

    @Test func dryRunReportsMissingKeysWithoutWriting() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                let target = try writeCatalog(named: "Target.xcstrings", keys: [:], in: directory)
                return (source: try writeCatalog(named: "Source.xcstrings", keys: [
                    "dive.kit.missing": "New package default"
                ], in: directory),
                        target: target,
                        originalTarget: try Data(contentsOf: target))
            } when: { input in
                try CatalogSynchronizer().sync(source: input.source, target: input.target, dryRun: true)
            } then: { input, result in
                #expect(result.action == .wouldMerge)
                #expect(result.addedKeys == [
                    "dive.kit.missing"
                ])
                let target = try Data(contentsOf: input.target)
                #expect(target == input.originalTarget)
            }
        }
    }

    // MARK: Errors

    @Test(.tags(.error))
    func missingSourceThrows() async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: directory.appendingPathComponent("Missing.xcstrings"),
                target: directory.appendingPathComponent("Target.xcstrings")) { source, _ in
                    .sourceCatalogNotFound(source)
                }
        }
    }

    @Test(.tags(.error))
    func directorySourceThrows() async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: directory,
                target: directory.appendingPathComponent("Target.xcstrings")) { source, _ in
                    .sourceCatalogIsDirectory(source)
                }
        }
    }

    @Test(.tags(.error))
    func directoryTargetThrows() async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: try writeCatalog(named: "Source.xcstrings", keys: [:], in: directory),
                target: directory) { _, target in
                    .targetCatalogIsDirectory(target)
                }
        }
    }

    @Test(.tags(.error))
    func missingTargetDirectoryThrows() async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: try writeCatalog(named: "Source.xcstrings", keys: [:], in: directory),
                target: directory.appendingPathComponent("Missing/Target.xcstrings")) { _, target in
                    .targetDirectoryNotFound(target.deletingLastPathComponent())
                }
        }
    }

    @Test(.tags(.error), arguments: [
        (#"["not", "a", "dictionary"]"#, "root object must be a JSON dictionary"),
        (#"{"strings": ["not", "a", "dictionary"]}"#, "\"strings\" must be a JSON dictionary"),
        (#"{"sourceLanguage": "en"}"#, "\"strings\" must be a JSON dictionary")])
    func invalidSourceCatalogThrows(contents: String, reason: String) async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: try write(contents, named: "Source.xcstrings", in: directory),
                target: directory.appendingPathComponent("Target.xcstrings")) { source, _ in
                    .invalidCatalog(source, reason)
                }
        }
    }

    @Test(.tags(.error))
    func invalidTargetCatalogThrows() async throws {
        try await withTemporaryDirectory { directory in
            await expectSyncError(
                source: try writeCatalog(named: "Source.xcstrings", keys: [:], in: directory),
                target: try write(#"{"strings": "not a dictionary"}"#, named: "Target.xcstrings", in: directory)) { _, target in
                    .invalidCatalog(target, "\"strings\" must be a JSON dictionary")
                }
        }
    }

    /// Malformed JSON surfaces Foundation's parsing error, not ``CatalogSyncError``.
    @Test(.tags(.error))
    func malformedJSONThrowsParsingError() async throws {
        try await withTemporaryDirectory { directory in
            try await given {
                (source: try write("{ not json", named: "Source.xcstrings", in: directory),
                 target: directory.appendingPathComponent("Target.xcstrings"))
            } when: { input in
                Result { try CatalogSynchronizer().sync(source: input.source, target: input.target) }
            } then: { input, result in
                guard case let .failure(error) = result else {
                    Issue.record("Expected malformed JSON to throw.")
                    return
                }
                #expect(!(error is CatalogSyncError))
                #expect(!FileManager.default.fileExists(atPath: input.target.path))
            }
        }
    }
}

private extension CatalogSynchronizerTests {
    func expectSyncError(
        source: URL,
        target: URL,
        expected: (_ source: URL, _ target: URL) -> CatalogSyncError) async {
            await given {
                (source: source, target: target)
            } when: { input in
                Result { try CatalogSynchronizer().sync(source: input.source, target: input.target) }
            } then: { input, result in
                #expect(throws: expected(input.source, input.target)) { try result.get() }
            }
        }

    func withTemporaryDirectory<Result>(_ operation: (URL) async throws -> Result) async throws -> Result {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        return try await operation(directory)
    }

    func write(_ contents: String, named name: String, in directory: URL) throws -> URL {
        let url = directory.appendingPathComponent(name)
        try Data(contents.utf8).write(to: url)
        return url
    }

    func writeCatalog(
        named name: String,
        keys: [String: String],
        in directory: URL) throws -> URL {
            let url = directory.appendingPathComponent(name)
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
            let data = try JSONSerialization.data(withJSONObject: catalog, options: [.prettyPrinted, .sortedKeys])
            try data.write(to: url)

            return url
        }

    func loadStrings(at url: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        let object = try JSONSerialization.jsonObject(with: data)
        let catalog = try #require(object as? [String: Any])

        return try #require(catalog["strings"] as? [String: Any])
    }

    func value(for key: String, in strings: [String: Any]) -> String? {
        let entry = strings[key] as? [String: Any]
        let localizations = entry?["localizations"] as? [String: Any]
        let english = localizations?["en"] as? [String: Any]
        let stringUnit = english?["stringUnit"] as? [String: Any]

        return stringUnit?["value"] as? String
    }
}
