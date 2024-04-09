import Foundation

public enum Error: Swift.Error {
    case input(_ input: Input, _ callSite: CallSite)
}

extension Error: Equatable {}
