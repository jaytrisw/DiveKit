# DiveKit

<p align="center">
<img src="https://jaytrisw.github.io/DiveKit/DiveKit.jpg" alt="DiveKit" title="DiveKit" width="500"/>
</p>

<p align="center">
<a href="https://swift.org/"><img src="https://github.com/jaytrisw/DiveKit/workflows/Swift/badge.svg" alt="Swift" title="Swift"></a> <a href="https://travis-ci.com/jaytrisw/DiveKit"><img src="https://travis-ci.com/jaytrisw/DiveKit.svg?branch=master"></a> <a href='https://jaytrisw.github.io/DiveKit'> <img src='https://jaytrisw.github.io/DiveKit/badge.svg' alt='Documentation Status' /></a>
<br />
<a href="https://codeclimate.com/github/jaytrisw/DiveKit/maintainability"><img src="https://api.codeclimate.com/v1/badges/1b7039fc233efcc5187e/maintainability" /></a> <a href="https://www.codefactor.io/repository/github/jaytrisw/divekit/overview/master"><img src="https://www.codefactor.io/repository/github/jaytrisw/divekit/badge/master" alt="CodeFactor" /></a> <a href="https://codecov.io/gh/jaytrisw/DiveKit"><img src="https://codecov.io/gh/jaytrisw/DiveKit/branch/master/graph/badge.svg" /></a>
<br /> 
<a href="https://github.com/apple/swift-package-manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-green" alt="Swift Package Manager compatible" title="Swift Package Manager compatible"></a>
<a href="https://cocoapods.org/pods/DiveKit"><img src="https://img.shields.io/cocoapods/v/DiveKit.svg" alt="CocoaPods" title="CocoaPods"></a> 
</p>

The development of DiveKit started to fulfill the need for diving calculations in the ongoing rewrite of my iOS application, Guam Dive Guide.  My goal for DiveKit is to be a robust library of scuba diving calculations.

I will continue to develop this codebase to include more calculations and refactor code to provide the most accurate calculations with syntax that is both easy to use and easy to understand.


## Initialization

```swift
import UIKit
import DiveKit

class ViewController: UIViewController {

    var diveKit: DiveKit!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize diveKit with default values of salt water and imperial units
        diveKit = DiveKit.init()
        // Initialize diveKit with fresh water and metric units
        diveKit = DiveKit.init(waterType: .freshWater, measurementUnit: .metric)
        // Initialize diveKit with water type of fresh water and default value of imperial
        diveKit = DiveKit.init(waterType: .freshWater)
        // Initialize diveKit with metric measurements and default water type of salt water
        diveKit = DiveKit.init(measurementUnit: .metric)
    }
}
```

## Usage

#### Calculate MOD of an Enriched Air Nitrox (EANx) Blend

```swift
import DiveKit

// Calclate MOD for EANx32 at PPO2 of 1.4 (Salt Water and Imperial Units)
let enrichedAirCalc = DKEnrichedAir.init(waterType: .saltWater, measurementUnit: .imperial)
do {
    let gas = try Gas.enrichedAir(32)
    let mod = try enrichedAirCalc.maximumOperatingDepth(fractionOxygen: 1.4, gas: gas)
    print(mod) // 111 (feet)
} catch {
    // Handle Error
    print(error.localizedDescription)
}
```

## Installation

#### CocoaPods

DiveKit is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'DiveKit', '~> 0.11.0'
```

#### Swift Package Manager with Xcode 11

Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/jaytrisw/DiveKit.git", from: "0.11.0"),
```

...and then include `"DiveKit"` as a dependency for your executable target:

```swift
.product(name: "DiveKit", package: "DiveKit"),
```

> **Note:** Because `DiveKit` is under active development,
source-stability will only guaranteed after the release of version `1.0`, breaking changes may occur until then.

[View Apple Documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

## Author

Joshua T. Wood <joshuatw@gmail.com> | [@joshuatw](https://twitter.com/joshuatw)

## License

DiveKit is available under the MIT license. See the LICENSE file for more info.

## Projects that use DiveKit

#### Guam Dive Guide
<a href='https://apps.apple.com/us/app/id1383968687'> <img src='https://jaytrisw.github.io/DiveKit/App_Store_Badge.svg' alt='Download on the App Store' /></a>

#### Scuba Calculator
<a href='https://apps.apple.com/us/app/id1502584393'> <img src='https://jaytrisw.github.io/DiveKit/App_Store_Badge.svg' alt='Download on the App Store' /></a>
