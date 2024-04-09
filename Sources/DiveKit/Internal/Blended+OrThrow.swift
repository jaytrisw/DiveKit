import Foundation

package extension Blend where State == Unblended {
    func blend(from callSite: CallSite) throws -> Blend<Blended> {
        guard let blend = try? blend() else {
            throw Error.input(.invalid(.blend(self)), callSite)
        }
        return blend
    }
}
