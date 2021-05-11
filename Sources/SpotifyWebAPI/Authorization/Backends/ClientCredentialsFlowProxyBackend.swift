import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

#if canImport(Combine)
import Combine
#else
import OpenCombine
import OpenCombineDispatch
import OpenCombineFoundation
#endif

/**
 Communicates with a backend server that you setup in order to retrieve the
 authoriation information using the [Client Credentials Flow][1].
 
 Compare with `ClientCredentialsFlowClientBackend`.
 
 This type requires a custom backend server that can store your client id and
 client secret.
 
 [1]: https://developer.spotify.com/documentation/general/guides/authorization-guide/#client-credentials-flow
 */
public struct ClientCredentialsFlowProxyBackend: ClientCredentialsFlowBackend {

    /// The logger for this struct.
    public static var logger = Logger(
        label: "ClientCredentialsFlowProxyBackend", level: .critical
    )

    /**
     The URL to your custom backend server that accepts a post request for
     the authorization information. The body will contain a key called
     "grant_type" with the value set to "client_credentials" in
     x-www-form-urlencoded format.
     
     See `self.makeClientCredentialsTokensRequest()` for more information.
     */
    public let tokensURL: URL

    /**
     A hook for decoding an error produced by your backend server into an error
     type, which will then be thrown to downstream subscribers.
     
     After the response from your server is received following a call to
     `self.makeClientCredentialsTokensRequest()`, this function is called with
     the raw data and response metadata from the server. If you return an error
     from this function, then this error will be thrown to downstream
     subscribers. If you return `nil`, then the response from the server will be
     passed through unmodified to downstream subscribers.
     
     - Important: Do not use this function to decode the documented error
     objects produced by Spotify, such as `SpotifyAuthenticationError`.
     This will be done elsewhere. Only use this function to decode error
     objects produced by your custom backend server.
     
     # Thread Safety
     
     No guarentees are made about which thread this function will be called on.
     Do not mutate this property while a request is being made for the
     authorization information.
     */
    public var decodeServerError: ((Data, HTTPURLResponse) -> Error?)?

    /**
     Creates an instance that manages the authorization process for the [Client
     Credentials Flow][1] by communicating with a custom backend server.

     - Parameters:
       - tokensURL: The URL to your custom backend server that accepts a post
             request for the authorization information. The body will contain a
             key called "grant_type" with the value set to "client_credentials"
             in x-www-form-urlencoded format. See
             `self.makeClientCredentialsTokensRequest()` for more information.
       - decodeServerError: A hook for decoding an error produced by your
             backend server into an error type, which will then be thrown to
             downstream subscribers Do not use this function to decode the
             documented error objects produced by Spotify, such as
             `SpotifyAuthenticationError`. This will be done elsewhere.
     
     [1]: https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow-with-proof-key-for-code-exchange-pkce
     */
    public init(
        tokensURL: URL,
        decodeServerError: ((Data, HTTPURLResponse) -> Error?)? = nil
    ) {
        self.tokensURL = tokensURL
        self.decodeServerError = decodeServerError
    }

    /**
     Makes a request for the authorization information.

     This method is called by either the `authorize()` or
     `refreshTokens(onlyIfExpired:tolerance:)` methods of
     `ClientCredentialsFlowBackendManager`. The client credentials flow does not
     provide a refresh token, so in both cases, the same network request should
     be made.

     This method makes a post request to `self.tokensURL`. The headers will
     contain the "Content-Type: application/x-www-form-urlencoded" header and
     the body will contain a key called "grant_type" with the value set to
     "client_credentials" in x-www-form-urlencoded format. For example:
     "grant_type=client_credentials". See `ClientCredentialsTokensRequest`.

     This method must return the authorization information as JSON data that can
     be decoded into `AuthInfo`. The `accessToken`, and `expirationDate` (which
     can be decoded from the "expires_in" JSON key) properties must be
     non-`nil`. For example:

     ```
     {
         "access_token": "NgCXRKc...MzYjw",
         "token_type": "bearer",
         "expires_in": 3600,
     }
     ```

     After the response is retrieved from the server, `self.decodeServerError`
     is called in order to decode any custom error objects that your server
     might return.

     Read about the underlying request that must be made to Spotify in order to
     retrieve this data [here][1].
     
     [1]: https://developer.spotify.com/documentation/general/guides/authorization-guide/#:~:text=the%20request%20is%20sent%20to%20the%20%2Fapi%2Ftoken%20endpoint%20of%20the%20accounts%20service%3A
     */
    public func makeClientCredentialsTokensRequest(
    ) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error> {

        let body = ClientCredentialsTokensRequest()
            .formURLEncoded()
        
        let bodyString = String(data: body, encoding: .utf8) ?? "nil"
        Self.logger.trace(
            """
            POST request to "\(Endpoints.getTokens)"; body:
            \(bodyString)
            """
        )

        var tokensRequest = URLRequest(url: self.tokensURL)
        tokensRequest.httpMethod = "POST"
        tokensRequest.allHTTPHeaderFields = Headers.formURLEncoded
        tokensRequest.httpBody = body

        // `URLSession.defaultNetworkAdaptor` is used so that the test targets
        // can substitue different networking clients for testing purposes.
        // In your own code, you can just use `URLSession.dataTaskPublisher`
        // directly, or a different networking client, if necessary.
        return URLSession.defaultNetworkAdaptor(
            request: tokensRequest
        )
        .tryMap { data, response in
            if let error = self.decodeServerError?(data, response) {
                throw error
            }
            return (data: data, response: response)
        }
        .eraseToAnyPublisher()

    }

}

extension ClientCredentialsFlowProxyBackend: Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.tokensURL == rhs.tokensURL
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.tokensURL)
    }
    
}

extension ClientCredentialsFlowProxyBackend: Codable {
    
    enum CodingKeys: String, CodingKey {
        case tokensURL = "tokens_url"
    }
    
}