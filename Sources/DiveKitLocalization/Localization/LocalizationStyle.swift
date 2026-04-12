import Foundation
import DiveKitCore

public enum LocalizationStyle: Sendable {
    case full
    case short
}

extension LocalizationStyle: Codable {}
extension LocalizationStyle: Hashable {}
extension LocalizationStyle: Equatable {}
