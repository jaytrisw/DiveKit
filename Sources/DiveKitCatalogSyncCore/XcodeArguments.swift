import Foundation

/// Arguments passed to `catalog-sync` by the Xcode command plugin.
///
/// Xcode passes the plugin its own arguments, such as the selected target, and
/// a catalog path may arrive as a bare `.xcstrings` argument. The plugin cannot
/// import this module, so it forwards the raw arguments and sets
/// ``environmentKey``; `catalog-sync` then normalizes them before parsing.
///
/// - Since: 1.0.0
public enum XcodeArguments {
    /// The environment variable the Xcode plugin sets to `1` to ask
    /// `catalog-sync` to normalize its arguments.
    ///
    /// - Since: 1.0.0
    public static let environmentKey = "DIVEKIT_CATALOG_SYNC_XCODE_ARGUMENTS"

    /// Returns arguments that `catalog-sync` can parse.
    ///
    /// The target catalog, given as `--target <path>`, `--target=<path>`,
    /// `-t <path>`, or the first bare `.xcstrings` argument, moves to a single
    /// trailing `--target <path>`. `--source`, `-s`, `--source=` and `--dry-run`
    /// pass through, as do other flags. Other values, such as Xcode's own
    /// arguments, are dropped. A trailing `--target` or `-t` with no value
    /// passes through so that parsing reports it.
    ///
    /// - Parameter arguments: The arguments Xcode passed to the plugin.
    /// - Returns: The normalized arguments.
    ///
    /// ```swift
    /// XcodeArguments.normalized(["App/Localizable.xcstrings", "--dry-run"])
    /// // ["--dry-run", "--target", "App/Localizable.xcstrings"]
    /// ```
    ///
    /// - Since: 1.0.0
    public static func normalized(_ arguments: [String]) -> [String] {
        var normalizedArguments: [String] = []
        var target: String?
        var remaining = arguments[...]

        while let argument = remaining.popFirst() {
            if argument.hasPrefix("--target=") {
                target = String(argument.dropFirst("--target=".count))
            } else if argument == "--target" || argument == "-t" {
                if let value = remaining.popFirst() {
                    target = value
                } else {
                    normalizedArguments.append(argument)
                }
            } else if argument == "--source" || argument == "-s" {
                normalizedArguments.append(argument)
                remaining.popFirst().map { normalizedArguments.append($0) }
            } else if argument.hasPrefix("--source=") || argument == "--dry-run" {
                normalizedArguments.append(argument)
            } else if target == nil, argument.hasSuffix(".xcstrings") {
                target = argument
            } else if argument.hasPrefix("-") {
                normalizedArguments.append(argument)
            }
        }

        return normalizedArguments + (target.map { ["--target", $0] } ?? [])
    }
}
