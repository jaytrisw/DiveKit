import Foundation

public protocol DecimalResultRepresentable: Equatable, ResultRepresentable {
    associatedtype Unit: UnitRepresentable

    var value: Double { get }
}
