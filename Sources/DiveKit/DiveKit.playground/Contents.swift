import DiveKit

var str = "Hello, DiveKit"

let diveKit = DiveKit.default
let gasCalculator = DKGasCalculator(with: diveKit)

do {
    let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 30, for: 10, consuming: 200)
} catch let error as DiveKit.Error {
    print(error.recoverySuggestion)
} catch {
    
}
