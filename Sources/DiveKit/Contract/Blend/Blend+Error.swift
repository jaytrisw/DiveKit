import Foundation

func error<State: BlendState>(
    for value: Double,
    message: Error<Double>.Message,
    describe: Blend<State>,
    function: StaticString = #function) -> Error<Double> {
        .init(
            value: value,
            message: message,
            object: .init(describing: describe).components(separatedBy: "(").first ?? .init(describing: describe),
            function: function)
        }
