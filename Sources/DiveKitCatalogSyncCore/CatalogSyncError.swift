import Foundation

/// An error thrown while synchronizing a DiveKit string catalog.
///
/// - Since: 1.0.0
public enum CatalogSyncError: Error, Equatable {
    /// The source `.xcstrings` catalog does not exist at the given URL.
    ///
    /// - Since: 1.0.0
    case sourceCatalogNotFound(URL)

    /// The source catalog URL points to a directory rather than a file.
    ///
    /// - Since: 1.0.0
    case sourceCatalogIsDirectory(URL)

    /// The target catalog URL points to a directory rather than a file.
    ///
    /// - Since: 1.0.0
    case targetCatalogIsDirectory(URL)

    /// The parent directory for the target catalog does not exist at the given URL.
    ///
    /// - Since: 1.0.0
    case targetDirectoryNotFound(URL)

    /// A string catalog file could not be parsed as a valid `.xcstrings` dictionary.
    ///
    /// - Since: 1.0.0
    case invalidCatalog(URL, String)
}

/// Provides localized error descriptions for catalog synchronization failures.
///
/// - Since: 1.0.0
extension CatalogSyncError: LocalizedError {
    /// A localized message describing what error occurred.
    ///
    /// - Since: 1.0.0
    public var errorDescription: String? {
        switch self {
            case let .sourceCatalogNotFound(url):
                "Source catalog was not found at \(url.path)"
            case let .sourceCatalogIsDirectory(url):
                "Source catalog path is a directory: \(url.path)"
            case let .targetCatalogIsDirectory(url):
                "Target catalog path is a directory: \(url.path)"
            case let .targetDirectoryNotFound(url):
                "Target catalog directory was not found at \(url.path)"
            case let .invalidCatalog(url, reason):
                "Invalid string catalog at \(url.path): \(reason)"
        }
    }
}
