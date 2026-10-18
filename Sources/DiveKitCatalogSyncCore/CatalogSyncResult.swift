/// The outcome of synchronizing a DiveKit string catalog with a target catalog.
///
/// - Since: 1.0.0
public struct CatalogSyncResult: Equatable {
    /// The action performed or planned during synchronization.
    ///
    /// - Since: 1.0.0
    public enum Action: Equatable {
        /// The source catalog was copied to create a new target catalog.
        ///
        /// - Since: 1.0.0
        case copied

        /// Missing keys from the source catalog were merged into the target catalog.
        ///
        /// - Since: 1.0.0
        case merged

        /// The target catalog already contained all keys from the source catalog.
        ///
        /// - Since: 1.0.0
        case unchanged

        /// A dry run determined that the source catalog would be copied to create the target catalog.
        ///
        /// - Since: 1.0.0
        case wouldCopy

        /// A dry run determined that missing keys would be merged into the target catalog.
        ///
        /// - Since: 1.0.0
        case wouldMerge
    }

    /// The synchronization action that was taken or planned.
    ///
    /// - Since: 1.0.0
    public let action: Action

    /// The number of localization keys in the source catalog.
    ///
    /// - Since: 1.0.0
    public let sourceKeyCount: Int

    /// The number of localization keys in the target catalog before synchronization.
    ///
    /// - Since: 1.0.0
    public let targetKeyCountBeforeSync: Int

    /// The number of localization keys in the target catalog after synchronization.
    ///
    /// - Since: 1.0.0
    public let targetKeyCountAfterSync: Int

    /// The sorted list of localization keys added (or that would be added) to the target catalog.
    ///
    /// - Since: 1.0.0
    public let addedKeys: [String]

    /// Whether the target catalog file on disk was modified.
    ///
    /// - Since: 1.0.0
    public var changedTarget: Bool {
        switch action {
            case .copied, .merged:
                true
            case .unchanged, .wouldCopy, .wouldMerge:
                false
        }
    }

    /// Creates a catalog synchronization result.
    ///
    /// - Parameters:
    ///   - action: The synchronization action that was taken or planned.
    ///   - sourceKeyCount: The number of localization keys in the source catalog.
    ///   - targetKeyCountBeforeSync: The number of localization keys in the target
    ///     catalog before synchronization.
    ///   - targetKeyCountAfterSync: The number of localization keys in the target
    ///     catalog after synchronization.
    ///   - addedKeys: The sorted list of localization keys added to the target catalog.
    ///
    /// ```swift
    /// let result = CatalogSyncResult(
    ///     action: .merged,
    ///     sourceKeyCount: 40,
    ///     targetKeyCountBeforeSync: 12,
    ///     targetKeyCountAfterSync: 14,
    ///     addedKeys: ["dive.kit.error.negative.depth", "dive.kit.error.negative.volume"])
    /// ```
    ///
    /// - Since: 1.0.0
    public init(
        action: Action,
        sourceKeyCount: Int,
        targetKeyCountBeforeSync: Int,
        targetKeyCountAfterSync: Int,
        addedKeys: [String]) {
            self.action = action
            self.sourceKeyCount = sourceKeyCount
            self.targetKeyCountBeforeSync = targetKeyCountBeforeSync
            self.targetKeyCountAfterSync = targetKeyCountAfterSync
            self.addedKeys = addedKeys
        }
}
