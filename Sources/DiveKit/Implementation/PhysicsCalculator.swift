import Foundation

public class PhysicsCalculator: ConfigurationProviding {
    public let configuration: Configuration

    required public init(configuration: Configuration) {
        self.configuration = configuration
    }
}

extension PhysicsCalculator: PhysicsCalculating {
    public func gaugePressure(
        at depth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
            try gaugePressure(at: depth, with: configuration, .from(self))
        }

    public func airVolumeFromSurface(
        to depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalResult<Pressure>> {
            try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try atmospheresAbsolute(at: depth, with: configuration, .from(self)) }
                .map { volume.value / $0.result.value }
                .map { .decimal($0, unit: \.pressure, from: configuration) }
        }

    public func airVolumeToSurface(
        from depth: Depth,
        with volume: Volume) throws -> Calculation<DecimalResult<Pressure>> {
            try volume.validate(using: .nonNegative, orThrow: { .negative($0, .from(self)) })
                .map { try atmospheresAbsolute(at: depth, with: configuration, .from(self)) }
                .map { volume.value * $0.result.value }
                .map { .decimal($0, unit: \.pressure, from: configuration) }
        }

    public func atmospheresAbsolute(
        at depth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
            try atmospheresAbsolute(at: depth, with: configuration, .from(self))
        }

    public func pressureChange(
        from firstDepth: Depth,
        to secondDepth: Depth) throws -> Calculation<DecimalResult<Pressure>> {
            try atmospheresAbsolute(at: firstDepth, with: configuration, .from(self))
                .with { try atmospheresAbsolute(at: secondDepth, with: configuration, .from(self)) }
                .map { $0.second.result.value - $0.first.result.value }
                .map { .decimal($0, unit: \.pressure, from: configuration) }
        }
}
