import Foundation
@_documentation(visibility: private)
import DiveKitCore
@_documentation(visibility: private)
import DiveKitLocalization

public extension ConfigurationProviding {
    init(_ units: Units, water: Water) {
        self.init(configuration: .init(units: units, water: water))
    }
}
