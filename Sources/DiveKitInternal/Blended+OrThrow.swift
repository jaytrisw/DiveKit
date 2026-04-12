import Foundation
import DiveKitCore

package extension Blend where State == Unblended {
    func blend(_ callSite: CallSite) throws(Error) -> Blend<Blended> {
        try totalPressure.validate(using: .equal(to: .one)) {
            .blend(.totalPressure($0, self), callSite)
        }
        return .init(self)
    }
}
