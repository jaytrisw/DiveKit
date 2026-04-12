import DiveKitLocalization

package typealias LocalizedKey = DiveKitLocalization.LocalizedKey

package func localizedString(
    for key: String,
    with comment: @autoclosure () -> String) -> String {
        DiveKitLocalization.localizedString(for: key, with: comment())
    }

package func localizedString(
    for key: String,
    quantity: Double,
    with comment: @autoclosure () -> String) -> String {
        DiveKitLocalization.localizedString(for: key, quantity: quantity, with: comment())
    }
