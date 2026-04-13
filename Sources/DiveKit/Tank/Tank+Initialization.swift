import Foundation
import DiveKitCore
import DiveKitInternal

public extension Tank {
    init(blend: Blend<Unblended>, size: Size) throws(Error) {
        let callSite = CallSite(object: .init(describing: Self.self), function: #function)
        self = .init(blend: try blend.blend(callSite), size: size)
    }
}
