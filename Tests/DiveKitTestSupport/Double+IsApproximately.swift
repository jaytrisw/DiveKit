package enum Tolerance {
    case standard
    case loose

    package var value: Double {
        switch self {
        case .standard:
            1e-12
        case .loose:
            1e-6
        }
    }
}

extension Double {
    package func isApproximately(_ other: Self, with tolerance: Tolerance = .standard) -> Bool {
        abs(self - other) <= tolerance.value
    }
}
