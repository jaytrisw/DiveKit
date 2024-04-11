import Foundation

public enum Error: Swift.Error {
    case negative(_ negative: Negative, _ callSite: CallSite)
    case tank(_ tank: Tank, _ callSite: CallSite)
    case blend(_ blend: Blend, _ callSite: CallSite)
}

extension Error: Equatable {}
