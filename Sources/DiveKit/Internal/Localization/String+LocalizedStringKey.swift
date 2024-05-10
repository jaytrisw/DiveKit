import SwiftUI

internal extension String {
    init(_ key: () -> LocalizedStringKey) {
        self.init(key().stringValue)
    }
}
