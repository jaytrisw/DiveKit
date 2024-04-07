import Foundation

public protocol DecimalOutputRepresentable: DecimalRepresentable {
    associatedtype Unit: UnitRepresentable
}
