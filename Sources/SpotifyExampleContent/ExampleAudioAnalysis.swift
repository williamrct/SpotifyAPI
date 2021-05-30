import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension AudioAnalysis {
    
    /// Sample data for testing purposes.
    static let anyColourYouLike = Bundle.module.decodeJSON(
        forResource: "Any Colour You Like - AudioAnalysis", type: Self.self
    )!

}

#endif
