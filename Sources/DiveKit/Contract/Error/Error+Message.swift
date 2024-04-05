import Foundation

public extension Error {
    struct Message {
        public let key: String

        package init(key: String) {
            self.key = key
        }
    }
}

extension Error.Message: Equatable {}
