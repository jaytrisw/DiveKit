import Foundation

public enum CatalogSyncError: Error, Equatable {
    case sourceCatalogNotFound(URL)
    case sourceCatalogIsDirectory(URL)
    case targetCatalogIsDirectory(URL)
    case targetDirectoryNotFound(URL)
    case invalidCatalog(URL, String)
}

extension CatalogSyncError: LocalizedError {
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
