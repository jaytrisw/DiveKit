import Foundation

public struct Water: Sendable {
    public let weight: @Sendable (Units) -> Weight
    public let pressure: @Sendable (Units) -> Pressure

    public init(
        weight: @escaping @Sendable (Units) -> Weight,
        pressure: @escaping @Sendable (Units) -> Pressure) {
            self.weight = weight
            self.pressure = pressure
        }
}
