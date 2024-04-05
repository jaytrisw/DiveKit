import Foundation

public protocol ConfigurationProviding {
    var configuration: Configuration { get }

    init(configuration: Configuration)
}
