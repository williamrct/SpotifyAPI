import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension PagingObject where Item == SavedItem<Album> {
    
    /// Sample data for testing purposes.
    static let sampleCurrentUserSavedAlbums = Bundle.module.decodeJson(
        forResource: "Current User Saved Albums - PagingObject<SavedItem<Album>>",
        type: Self.self
    )!

}

#endif
