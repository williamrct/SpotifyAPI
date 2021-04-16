import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension AudioFeatures {
    
    /// Sample data for testing purposes.
    static let fearless = Bundle.module.decodeJson(
        forResource: "Fearless - AudioFeatures", type: Self.self
    )!

}

#endif
