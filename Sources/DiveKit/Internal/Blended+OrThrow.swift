import Foundation

internal extension Blend where State == Unblended {
    func blend(_ callSite: CallSite) throws -> Blend<Blended> {
        guard let blend = try? blend() else {
            throw Error.input(.invalid(.blend(self)), callSite)
        }
        return blend
    }
}
