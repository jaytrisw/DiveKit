import Foundation

internal extension Blend where State == Unblended {
    func blend(_ callSite: CallSite) throws -> Blend<Blended> {
        guard totalPressure == 1.0 else {
            throw Error.input(.blend(.totalPressure(totalPressure, self)), callSite)
        }
        return .init(storage: storage)
    }
}
