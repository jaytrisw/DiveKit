import Foundation

public protocol LocalizedDescriptionProviding {
    associatedtype Style
    func localizedDescription(for style: Style) -> String
}
