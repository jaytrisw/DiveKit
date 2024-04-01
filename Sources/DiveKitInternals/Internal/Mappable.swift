import DiveKitCore

package protocol Mappable {}

package extension Mappable {
    func map<Transform>(_ transform: () throws -> Transform) rethrows -> Transform {
        try transform()
    }

    func map<Transform>(_ transform: (Self) throws -> Transform) rethrows -> Transform {
        try transform(self)
    }
}

extension Blend: Mappable {}
extension PartialPressure: Mappable {}
extension Double: Mappable {}
extension ValidatedTuple: Mappable {}
extension CalculationTuple: Mappable {}
