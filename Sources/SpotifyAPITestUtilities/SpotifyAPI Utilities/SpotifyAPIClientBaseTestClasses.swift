
#if canImport(Combine)
import Combine
#else
import OpenCombine
import OpenCombineDispatch
import OpenCombineFoundation
#endif
import XCTest
import SpotifyWebAPI

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Client -

/// The base class for all tests involving
/// `SpotifyAPI<ClientCredentialsFlowManager>`.
open class SpotifyAPIClientCredentialsFlowTests:
    SpotifyAPITestCase, SpotifyAPITests
{
    
    public static var spotify =
            SpotifyAPI<ClientCredentialsFlowManager>.sharedTest
    
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
                SpotifyAPI<ClientCredentialsFlowManager>.self,
                from: encoded
            )
            spotify = decoded
        
        } catch {
            fatalError("\(error)")
        }
        
    }

}


/// The base class for all tests involving
/// `SpotifyAPI<AuthorizationCodeFlowManager<AuthorizationCodeFlowClientBackend>>`.
open class SpotifyAPIAuthorizationCodeFlowTests:
    SpotifyAPITestCase, SpotifyAPITests
{

    public static var spotify =
            SpotifyAPI<AuthorizationCodeFlowManager>.sharedTest
    
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
                SpotifyAPI<AuthorizationCodeFlowManager>.self,
                from: encoded
            )
            spotify = decoded
        
        } catch {
            fatalError("\(error)")
        }
        
    }
    

}

/// The base class for all tests involving
/// `SpotifyAPI<AuthorizationCodeFlowPKCEManager<AuthorizationCodeFlowPKCEClientBackend>>`.
open class SpotifyAPIAuthorizationCodeFlowPKCETests:
    SpotifyAPITestCase, SpotifyAPITests
{

    public static var spotify =
            SpotifyAPI<AuthorizationCodeFlowPKCEManager>.sharedTest
    
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
                SpotifyAPI<AuthorizationCodeFlowPKCEManager>.self,
                from: encoded
            )
            spotify = decoded
        
        } catch {
            fatalError("\(error)")
        }
        
    }

}
