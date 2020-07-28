//  Double.swift

import Foundation

extension Double {
    /**
    Rounds a double to specified number of decimal places.
    - parameter decimalPlaces: Double representing the number of decimal places to round to.
    - returns: Double rounded to specified decimal places.
    - since: 1.0
    */
    func round(to decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded(.toNearestOrEven) / divisor
    }
}
