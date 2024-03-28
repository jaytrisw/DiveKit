import Foundation

public extension ConfigurationProviding {
    init(_ units: Units, water: Water) {
        self.init(configuration: .init(units: units, water: water))
    }
}
