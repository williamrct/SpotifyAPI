
#if canImport(Combine)
import Combine
#else
import OpenCombine
import OpenCombineDispatch
import OpenCombineFoundation
#endif
import XCTest

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import SpotifyWebAPI

// MARK: - Proxy -

/// The base class for all tests involving
/// `SpotifyAPI<ClientCredentialsFlowManager>`.
open class SpotifyAPIClientCredentialsFlowProxyTests:
    SpotifyAPITestCase, SpotifyAPITests
{
    
    public static var spotify =
            SpotifyAPI<ClientCredentialsFlowBackendManager<ClientCredentialsFlowProxyBackend>>.sharedTest
    
    public static var cancellables: Set<AnyCancellable> = []

    /// If you only need to setup the authorization, override
    /// `setupAuthorization()` instead.
    override open class func setUp() {
        super.setUp()
        print(
            "setup debugging and authorization for " +
            "SpotifyAPIClientCredentialsFlowTests"
        )
        spotify.setupDebugging()
        fuzzSpotify()
        setupAuthorization()
    }

    open class func setupAuthorization() {
        spotify.authorizationManager.waitUntilAuthorized()
    }
    
    open class func fuzzSpotify() {
        
        encodeDecode(spotify, areEqual: { lhs, rhs in
            lhs.authorizationManager == rhs.authorizationManager
        })
        do {
            let encoded = try JSONEncoder().encode(spotify)
            let decoded = try JSONDecoder().decode(
                SpotifyAPI<ClientCredentialsFlowBackendManager<ClientCredentialsFlowProxyBackend>>.self,
                from: encoded
            )
            spotify = decoded
            spotify.authorizationManager.backend.decodeServerError =
                VaporServerError.decodeFromNetworkResponse(data:response:)

        } catch {
            fatalError("\(error)")
        }
        
    }

}

/// The base class for all tests involving
/// `SpotifyAPI<AuthorizationCodeFlowManager<AuthorizationCodeFlowProxyBackend>>`.
open class SpotifyAPIAuthorizationCodeFlowProxyTests:
    SpotifyAPITestCase, SpotifyAPITests
{

    public static var spotify =
            SpotifyAPI<AuthorizationCodeFlowBackendManager<AuthorizationCodeFlowProxyBackend>>.sharedTest

    public static var cancellables: Set<AnyCancellable> = []

    /// If you only need to setup the authorization, override
    /// `setupAuthorization()` instead.
    override open class func setUp() {
        super.setUp()
        print(
            "setup debugging and authorization for " +
            "SpotifyAPIAuthorizationCodeFlowTests"
        )
        spotify.setupDebugging()
        fuzzSpotify()
        setupAuthorization()
    }

    open class func setupAuthorization(
        scopes: Set<Scope> = Scope.allCases,
        showDialog: Bool = false
    ) {

        spotify.authorizationManager.authorizeAndWaitForTokens(
            scopes: scopes, showDialog: showDialog
        )
    }

    open class func fuzzSpotify() {

        encodeDecode(spotify, areEqual: { lhs, rhs in
            lhs.authorizationManager == rhs.authorizationManager
        })
        do {
            let encoded = try JSONEncoder().encode(spotify)
            let decoded = try JSONDecoder().decode(
                SpotifyAPI<AuthorizationCodeFlowBackendManager<AuthorizationCodeFlowProxyBackend>>.self,
                from: encoded
            )
            spotify = decoded
            spotify.authorizationManager.backend.decodeServerError =
                VaporServerError.decodeFromNetworkResponse(data:response:)

        } catch {
            fatalError("\(error)")
        }

    }


}

/// The base class for all tests involving
/// `SpotifyAPI<AuthorizationCodeFlowPKCEManager<AuthorizationCodeFlowPKCEProxyBackend>>`.
open class SpotifyAPIAuthorizationCodeFlowPKCEProxyTests:
    SpotifyAPITestCase, SpotifyAPITests
{
    public static var spotify =
            SpotifyAPI<AuthorizationCodeFlowPKCEBackendManager<AuthorizationCodeFlowPKCEProxyBackend>>.sharedTest

    public static var cancellables: Set<AnyCancellable> = []

    /// If you only need to setup the authorization, override
    /// `setupAuthorization()` instead.
    override open class func setUp() {
        super.setUp()
        print(
            "setup debugging and authorization for " +
            "SpotifyAPIAuthorizationCodeFlowPKCETests"
        )
        spotify.setupDebugging()
        fuzzSpotify()
        setupAuthorization()
    }

    open class func setupAuthorization(
        scopes: Set<Scope> = Scope.allCases
    ) {
        spotify.authorizationManager.authorizeAndWaitForTokens(
            scopes: scopes
        )
    }

    open class func fuzzSpotify() {

        encodeDecode(spotify, areEqual: { lhs, rhs in
            lhs.authorizationManager == rhs.authorizationManager
        })
        do {
            let encoded = try JSONEncoder().encode(spotify)
            let decoded = try JSONDecoder().decode(
                SpotifyAPI<AuthorizationCodeFlowPKCEBackendManager<AuthorizationCodeFlowPKCEProxyBackend>>.self,
                from: encoded
            )
            spotify = decoded
            spotify.authorizationManager.backend.decodeServerError =
                    VaporServerError.decodeFromNetworkResponse(data:response:)

        } catch {
            fatalError("\(error)")
        }

    }

}
