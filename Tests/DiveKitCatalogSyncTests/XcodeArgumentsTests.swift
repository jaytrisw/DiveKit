import DiveKitCatalogSyncCore
import DiveKitTestSupport
import Testing

@Suite("Xcode arguments", .tags(.catalogSync))
struct XcodeArgumentsTests {
    @Test(arguments: [
        (["--target", "App.xcstrings"], ["--target", "App.xcstrings"]),
        (["-t", "App.xcstrings"], ["--target", "App.xcstrings"]),
        (["--target=App.xcstrings"], ["--target", "App.xcstrings"]),
        (["App.xcstrings"], ["--target", "App.xcstrings"]),
        (["App.xcstrings", "Other.xcstrings"], ["--target", "App.xcstrings"]),
        (["--target", "First.xcstrings", "Second.xcstrings"], ["--target", "First.xcstrings"]),
        (["App.xcstrings", "--target=Explicit.xcstrings"], ["--target", "Explicit.xcstrings"]),
        (["--target"], ["--target"]),
        (["-t"], ["-t"]),
        (["--source", "Source.xcstrings", "App.xcstrings"], ["--source", "Source.xcstrings", "--target", "App.xcstrings"]),
        (["-s", "Source.xcstrings", "-t", "App.xcstrings"], ["-s", "Source.xcstrings", "--target", "App.xcstrings"]),
        (["--source=Source.xcstrings", "App.xcstrings"], ["--source=Source.xcstrings", "--target", "App.xcstrings"]),
        (["--source"], ["--source"]),
        (["--dry-run", "App.xcstrings"], ["--dry-run", "--target", "App.xcstrings"]),
        (["XcodeTargetName", "App.xcstrings"], ["--target", "App.xcstrings"]),
        (["--verbose", "App.xcstrings"], ["--verbose", "--target", "App.xcstrings"]),
        ([], [])])
    func normalizes(arguments: [String], expected: [String]) async {
        await given {
            arguments
        } when: { arguments in
            XcodeArguments.normalized(arguments)
        } then: { _, result in
            #expect(result == expected)
        }
    }
}
