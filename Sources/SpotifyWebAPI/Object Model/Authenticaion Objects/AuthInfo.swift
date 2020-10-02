import Foundation

/**
 The authorization info that spotify returns
 for the Authorization Code Flow and the
 Client Credentials Flow.

 This is used in various different contexts, including:
 
 * When decoding the respose after requesting the access and refresh tokens
   in `AuthorizationCodeFlowManager`.
 * When decoding the response after refreshing the tokens for
   `AuthorizationCodeFlowManager` or `ClientCredentialsFlowManager`
 * As a wrapper for decoding and encoding `AuthorizationCodeFlowManager`
   and `ClientCredentialsFlowManager`.
 
 Because of its diverse uses, all of its properties are `nil`,
 which means that it will never fail to decode itself from data,
 so be careful about swallowing errors.
 
 Includes the following properties:
 
 * `accessToken`: used in all of the requests to the Spotify web API
   for authorization.
 * `refreshToken`: Used to refresh the access token.
 * `expirationDate`: The expiration date of the access token.
 * `scopes`: The scopes that have been authorized for the access token.
 */
struct AuthInfo: Codable, Hashable {
    
    /// The access token used in all of the requests
    /// to the Spotify web API.
    public let accessToken: String?
    
    /// Used to refresh the access token.
    public let refreshToken: String?
    
    /// The expiration date of the access token.
    public let expirationDate: Date?
    
    /// The scopes that have been authorized for the access token.
    public let scopes: Set<Scope>?

    init(
        accessToken: String?,
        refreshToken: String?,
        expirationDate: Date?,
        scopes: Set<Scope>?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expirationDate = expirationDate
        self.scopes = scopes
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        
        self.accessToken = try container.decodeIfPresent(
            String.self, forKey: .accessToken
        )
        
        // this struct is used to get the refresh and access
        // tokens after the app is authorized, and to get
        // a fresh access token using the refresh token.
        // In the latter case, the refresh token is usually nil.
        // Furthermore, this is used to
        self.refreshToken = try container.decodeIfPresent(
            String.self, forKey: .refreshToken
        )
        self.scopes = try container.decodeSpotifyScopesIfPresent(
            forKey: .scopes
        )
        
        // if the json data was retrieved directly from the spotify API,
        // then the expiration date will be an integer representing
        // the number of seconds after the current date
        // that the access token expires.
        if let expirationDate = try container
                .decodeDateFromExpiresInSecondsIfPresent(
            forKey: .expiresInSeconds
        ) {
            self.expirationDate = expirationDate
        }

        /*
         if the json data was retrieved from elsewhere,
         such as persistent storage, then the expiration date
         will be stored in ISO 8601 format as
         Coordinated Universal Time (UTC) with a zero offset:
         "YYYY-MM-DD'T'HH:mm:SSZ". this is how Spotify formats timestamps,
         so the expiration date is formatted this way for consistency.
         see https://developer.spotify.com/documentation/web-api/#timestamps
         */
        else {
            self.expirationDate = try container.decodeSpotifyTimestampIfPresent(
                forKey: .expirationDate
            )
        }
        
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(
            keyedBy: CodingKeys.self
        )
        
        try container.encodeIfPresent(
            self.accessToken, forKey: .accessToken
        )
        try container.encodeIfPresent(
            self.refreshToken, forKey: .refreshToken
        )
        try container.encodeSpotifyScopesIfPresent(
            scopes, forKey: .scopes
        )
        try container.encodeSpotifyTimestampIfPresent(
            expirationDate, forKey: .expirationDate
        )
        
    }
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expirationDate = "expiration_date"
        case expiresInSeconds = "expires_in"
        case scopes = "scope"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
    
}

extension AuthInfo: CustomStringConvertible {
    
    public var description: String {
        
        let expirationDateString = expirationDate?
                .description(with: .autoupdatingCurrent)
                ?? "nil"
        
        var scopeString = "nil"
        if let scopes = scopes {
            scopeString = "\(scopes.map(\.rawValue))"
        }
        
        return """
            AuthInfo(
                access_token: "\(accessToken ?? "nil")"
                scopes: \(scopeString)
                expirationDate: \(expirationDateString)
                refresh_token: "\(refreshToken ?? "nil")"
            )
            """
    }

}

// MARK: - Testing -

extension AuthInfo {
    
    /// Creates an instance with random values.
    /// Only use for tests.
    static func withRandomValues() -> Self {
        return Self(
            accessToken: UUID().uuidString,
            refreshToken: UUID().uuidString,
            expirationDate: Date(),
            scopes: Set(Scope.allCases.shuffled().prefix(5))
        )
    }
    

}
