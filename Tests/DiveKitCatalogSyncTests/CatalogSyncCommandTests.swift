import ArgumentParser
@testable import catalog_sync
import DiveKitTestSupport
import Testing

@Suite("catalog-sync command", .tags(.catalogSync))
struct CatalogSyncCommandTests {
    @Test(arguments: [
        ["--target", "App.xcstrings"],
        ["-t", "App.xcstrings"],
        ["App.xcstrings"]])
    func acceptsEitherTargetForm(arguments: [String]) async throws {
        try await given {
            arguments
        } when: { arguments in
            try DiveKitCatalogSync.parse(arguments)
        } then: { _, command in
            #expect(command.target ?? command.targetPath == "App.xcstrings")
        }
    }

    @Test(.tags(.error), arguments: [
        (["--target", "App.xcstrings", "Other.xcstrings"], "Specify the target catalog either with --target or as a positional path, not both."),
        ([], "Missing target catalog. Provide --target <path> or a positional .xcstrings path.")])
    func rejectsBothOrNeitherTargetForm(arguments: [String], message: String) async {
        await given {
            arguments
        } when: { arguments in
            Result { try DiveKitCatalogSync.parse(arguments) }
        } then: { _, result in
            guard case let .failure(error) = result else {
                Issue.record("Expected parsing to fail.")
                return
            }
            #expect(DiveKitCatalogSync.message(for: error) == message)
        }
    }
}
