package enum Tolerance {
    case standard

    var value: Double {
        switch self {
        case .standard:
            1e-12
        }
    }
}

extension Double {
    func isApproximately(_ other: Self, with tolerance: Tolerance = .standard) -> Bool {
        abs(self - other) <= tolerance.value
    }
}
