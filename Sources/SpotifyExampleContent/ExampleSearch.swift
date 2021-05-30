import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension SearchResult {
    
    /// Sample data for testing purposes.
    static let queryCrumb = Bundle.module.decodeJSON(
        forResource: "Search for 'Crumb' - SearchResult",
        type: Self.self
    )!

}

#endif
