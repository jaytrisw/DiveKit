public struct CatalogSyncResult: Equatable {
    public enum Action: Equatable {
        case copied
        case merged
        case unchanged
        case wouldCopy
        case wouldMerge
    }

    public let action: Action
    public let sourceKeyCount: Int
    public let targetKeyCountBeforeSync: Int
    public let targetKeyCountAfterSync: Int
    public let addedKeys: [String]

    public var changedTarget: Bool {
        switch action {
            case .copied, .merged:
                true
            case .unchanged, .wouldCopy, .wouldMerge:
                false
        }
    }

    public init(
        action: Action,
        sourceKeyCount: Int,
        targetKeyCountBeforeSync: Int,
        targetKeyCountAfterSync: Int,
        addedKeys: [String]
    ) {
        self.action = action
        self.sourceKeyCount = sourceKeyCount
        self.targetKeyCountBeforeSync = targetKeyCountBeforeSync
        self.targetKeyCountAfterSync = targetKeyCountAfterSync
        self.addedKeys = addedKeys
    }
}
