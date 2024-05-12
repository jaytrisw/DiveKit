import Foundation

public enum LocalizationStyle {
    case full
    case short
}

extension LocalizationStyle: Codable {}
extension LocalizationStyle: Hashable {}
extension LocalizationStyle: Equatable {}
