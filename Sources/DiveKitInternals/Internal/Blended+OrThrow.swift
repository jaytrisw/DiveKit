import DiveKitCore

package extension Blend where State == Unblended {
    func blend<E: Swift.Error>(orThrow error: (Self) -> E) throws -> Blend<Blended> {
        guard let blend = try? blend() else {
            throw error(self)
        }
        return blend
    }
}
