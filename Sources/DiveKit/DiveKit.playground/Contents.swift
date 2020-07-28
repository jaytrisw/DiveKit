import DiveKit

var str = "Hello, DiveKit"

let gasCalculator = DKGasCalculator.init()

do {
    // Calculate SAC rate
    let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 33, for: 10, consuming: 200)
    print(surfaceAirConsumption.value) // 10.0
} catch {
    // Handle Error
    print(error.localizedDescription)
}

do {
    // Calculate SAC rate
    let surfaceAirConsumption = try gasCalculator.surfaceAirConsumption(at: 33, for: 10, startGas: 2400, endGas: 2200)
    print(surfaceAirConsumption.value) // 10.0
} catch {
    // Handle Error
    print(error.localizedDescription)
}
