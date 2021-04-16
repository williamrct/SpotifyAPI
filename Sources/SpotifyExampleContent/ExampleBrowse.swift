import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension PagingObject where Item == Playlist<PlaylistItemsReference> {
    
    /// Sample data for testing purposes.
    static let sampleCategoryPlaylists = Bundle.module.decodeJson(
        forResource: "Category Playlists - PagingObject<Playlist<PlaylistItemsReference>>",
        type: Self.self
    )!
    
}

public extension FeaturedPlaylists {
    
    /// Sample data for testing purposes.
    static let sampleFeaturedPlaylists = Bundle.module.decodeJson(
        forResource: "Featured Playlists - FeaturedPlaylists",
        type: Self.self
    )!

}

public extension SpotifyCategory {
    
    /// Sample data for testing purposes.
    static let sampleCategories = Bundle.module.decodeJson(
        forResource: "categories - SpotifyCategory",
        type: Self.self
    )!

}

#endif
