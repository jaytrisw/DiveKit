//  DKError.swift

import Foundation

struct DKError: LocalizedError {
    let title: String?
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    private var _description: String
    
    static let partialPressure = DKError(title: "Invalid Partial Pressure", description: "Partial pressure parameter must be a positive value.")
    static let depth = DKError(title: "Invalid Depth", description: "Depth parameter must be a positive value.")
    
    init(title: String?, description: String) {
        self.title = title
        self._description = description
    }
}
