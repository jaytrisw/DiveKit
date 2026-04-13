import Foundation

public struct Calculation<Result: ResultRepresentable>: Sendable {
    public let result: Result
    public let configuration: Configuration

    package init(result: Result, configuration: Configuration) {
        self.result = result
        self.configuration = configuration
    }
}

extension Calculation: Equatable where Result: Equatable {}
