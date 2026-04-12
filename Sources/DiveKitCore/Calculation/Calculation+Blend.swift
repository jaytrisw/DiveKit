import Foundation

package extension Calculation {
    static func blend(
        _ blend: Blend<Blended>,
        configuration: Configuration) -> Self where Result == Blend<Blended> {
            self.init(
                result: blend,
                configuration: configuration)
        }
}
