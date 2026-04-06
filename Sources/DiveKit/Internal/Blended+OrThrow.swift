import Foundation

internal extension Blend where State == Unblended {
    func blend(_ callSite: CallSite) throws(DiveKit.Error) -> Blend<Blended> {
        try totalPressure.validate(using: .equal(to: .one)) {
            .blend(.totalPressure($0, self), callSite)
        }
        return .init(storage)
    }
}
