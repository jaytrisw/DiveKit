import Foundation

public extension Blend {
    static var air: Blend<Blended> {
        .init(storage: [
            Oxygen(): 0.21,
            Nitrogen(): 0.78,
            Trace(): 0.01
        ])
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        .init(storage: [
            Oxygen(): fraction,
            Nitrogen(): 1.0 - fraction,
        ])
    }
}
