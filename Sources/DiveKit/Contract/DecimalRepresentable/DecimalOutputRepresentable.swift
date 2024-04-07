import Foundation

public protocol DecimalOutputRepresentable: Equatable, ResultRepresentable {
    associatedtype Unit: UnitRepresentable
}
