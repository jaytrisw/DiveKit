import Foundation
import DiveKitCore
import DiveKitInternal

package extension Blend where State == Blended {
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

package extension Blend where State == Unblended {
    init(@BlendBuilder builder: () -> Self) {
        self = builder()
    }
}

public extension Blend where State == Blended {
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}

public extension Blend where State == Unblended {
    init(@BlendBuilder builder: () throws(Error) -> Self) throws(Error) {
        self = try builder()
    }
}
