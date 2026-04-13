import SwiftUI
import DiveKitCore

internal extension String {
    init(_ key: () -> LocalizedStringResource) {
        self.init(key().stringValue)
    }
}
