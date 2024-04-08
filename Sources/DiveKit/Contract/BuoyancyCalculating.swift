import Foundation

public protocol BuoyancyCalculating: ConfigurationProviding {
    func buoyancy(of object: Object) throws -> Calculation<Buoyancy>
}
