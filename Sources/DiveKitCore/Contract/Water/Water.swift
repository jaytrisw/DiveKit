import Foundation

public struct Water {
    public let weight: (Units) -> Weight
    public let pressure: (Units) -> Pressure

    public init(
        weight: @escaping (Units) -> Weight,
        pressure: @escaping (Units) -> Pressure) {
            self.weight = weight
            self.pressure = pressure
        }
}
