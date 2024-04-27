import DiveKit

extension CallSite: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(description: stringLiteral)
    }
}

