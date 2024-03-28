import Foundation

package struct Validator<Value> {
    package let validate: (Value) -> Bool

    package init(validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }
}
