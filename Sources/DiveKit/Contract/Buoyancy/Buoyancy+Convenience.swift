import Foundation

package extension Buoyancy {
    init(_ value: Double) {
        if value < 0 {
            self = .negative(abs(value))
            return
        }

        if value > 0 {
            self = .positive(value)
            return
        }
        self = .neutral
    }
}
