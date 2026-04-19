import Foundation
import Testing

func expectEqual<T: Equatable>(
    _ lhs: @autoclosure () throws -> T,
    _ rhs: @autoclosure () throws -> T
) rethrows {
    let lhs = try lhs()
    let rhs = try rhs()
    #expect(lhs == rhs)
}

func expectEqual(
    _ lhs: @autoclosure () throws -> Double,
    _ rhs: @autoclosure () throws -> Double,
    accuracy: Double
) rethrows {
    let lhs = try lhs()
    let rhs = try rhs()
    #expect(abs(lhs - rhs) <= accuracy)
}
