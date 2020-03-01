//  DKError.swift

import Foundation

struct DKError: LocalizedError {
    let title: String
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    private var _description: String
    
    static let positiveValueRequired = DKError(title: "Positive Value Expected", description: "A positive value was expected")
    static let partialPressureNeedsPositive = DKError(title: "Invalid Partial Pressure", description: "Partial pressure cannot be a negative value")
    static let depthNeedsPositive = DKError(title: "Invalid Depth Parameter", description: "Depth parameter cannot be a negative value")
    
    init(title: String?, description: String) {
        self.title = title ?? "Error"
        self._description = description
    }
}
