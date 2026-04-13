import Foundation
import DiveKitCore

package protocol Mappable {}

package extension Mappable {
    func map<Transform>(_ transform: () throws(Error) -> Transform) throws(Error) -> Transform {
        try transform()
    }

    func map<Transform>(_ transform: (Self) throws(Error) -> Transform) throws(Error) -> Transform {
        try transform(self)
    }
}

extension Blend: Mappable {}
extension Buoyancy: Mappable {}
extension Calculation: Mappable {}
extension Double: Mappable {}
extension Object: Mappable {}
extension FractionalPressure: Mappable {}
extension PartialPressure: Mappable {}
extension Tank: Mappable {}
extension Tuple: Mappable {}
