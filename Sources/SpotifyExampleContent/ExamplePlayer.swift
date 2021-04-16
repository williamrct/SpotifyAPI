import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension CursorPagingObject where Item == PlayHistory {
    
    /// Sample data for testing purposes.
    static let sampleRecentlyPlayed = Bundle.module.decodeJson(
        forResource: "Recently Played - CursorPagingObject<PlayHistory>",
        type: Self.self
    )!
}

public extension CurrentlyPlayingContext {
    
    /// Sample data for testing purposes.
    static let sampleCurrentPlayback = Bundle.module.decodeJson(
        forResource: "Current Playback - CurrentlyPlayingContext",
        type: Self.self
    )!

}

#endif
