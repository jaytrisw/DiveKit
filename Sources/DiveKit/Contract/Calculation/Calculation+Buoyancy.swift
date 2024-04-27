import Foundation

extension Calculation where Result == Buoyancy {
    static func buoyancy(_ value: Double, configuration: Configuration) -> Self {
        .init(result: .init(value), configuration: configuration)
    }
}
