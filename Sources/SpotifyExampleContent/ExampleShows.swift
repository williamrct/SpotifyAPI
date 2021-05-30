import Foundation
import SpotifyWebAPI

#if SWIFT_TOOLS_5_3

public extension Show {
    
    /// Sample data for testing purposes.
    static let seanCarroll = Bundle.module.decodeJSON(
        forResource: "Sean Carroll - Show", type: Self.self
    )!
    
    /// Sample data for testing purposes.
    static let samHarris = Bundle.module.decodeJSON(
        forResource: "Sam Harris - Show", type: Self.self
    )!
    
    /// Sample data for testing purposes.
    static let joeRogan = Bundle.module.decodeJSON(
        forResource: "Joe Rogan - Show", type: Self.self
    )!

}

#endif
