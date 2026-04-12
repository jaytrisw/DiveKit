import Foundation

public struct Depth: Sendable, Equatable, Hashable {
    public let value: Double

    public init(_ value: Double) {
        self.value = value
    }
}

public extension Depth {
    enum Unit: UnitRepresentable {
        case feet
        case meters
    }
}

extension Depth: DecimalResultRepresentable {}
extension Depth.Unit: Codable {}
extension Depth.Unit: Hashable {}
extension Depth.Unit: Equatable {}
