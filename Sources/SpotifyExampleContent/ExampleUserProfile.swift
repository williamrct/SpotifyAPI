import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension SpotifyUser {
    
    /// Sample data for testing purposes.
    static let sampleCurrentUserProfile = Bundle.module.decodeJson(
        forResource: "Current User Profile - SpotifyUser",
        type: Self.self
    )!

}

#endif
