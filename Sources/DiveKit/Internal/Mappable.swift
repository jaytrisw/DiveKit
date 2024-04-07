import Foundation

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
extension Calculation: Mappable {}
extension Double: Mappable {}
extension PartialPressure: Mappable {}
extension Tank: Mappable {}
extension Tuple: Mappable {}
