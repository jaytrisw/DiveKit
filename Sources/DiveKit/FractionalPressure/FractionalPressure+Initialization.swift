import Foundation
import DiveKitCore
import DiveKitInternal

public extension FractionalPressure {
    init(of gas: Gas, fractionalPressure: Double) throws(Error) {
        let callSite: CallSite = .init(object: .init(describing: Self.self), function: #function)
        try fractionalPressure.validate(using: .greaterThanOrEqual(to: .zero)) {
            .negative(.fractionalPressure($0), callSite)
        }
        try fractionalPressure.validate(using: .lessThanOrEqual(to: .one)) {
            .range(.upperBound($0, .one), callSite)
        }

        self.init(gas, fractionalPressure: fractionalPressure)
    }
}
