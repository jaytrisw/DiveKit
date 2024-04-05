import Foundation

public extension Blend where State == Blended {
    static var air: Blend<Blended> {
        .init(storage: [
            Oxygen(): 0.209,
            Nitrogen(): 0.79,
            Trace(): 0.001
        ])
    }

    static func enrichedAir(_ fraction: Double) -> Blend<Blended> {
        .init(storage: [
            Oxygen(): fraction,
            Nitrogen(): 1.0 - fraction,
        ])
    }
}
