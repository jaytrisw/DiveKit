import Foundation
import DiveKitCore

package extension Calculation {
    func with(_ other: () throws(Error) -> Calculation) throws(Error) -> Tuple<Self, Self> {
        .init(first: self, second: try other())
    }
}
