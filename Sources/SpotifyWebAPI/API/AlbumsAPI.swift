import Foundation
import Combine

// MARK: Albums

public extension SpotifyAPI {
    
    /**
     Get an album.
     
     See also `artistAlbums(_:groups:country:limit:offset:)` and
     `albums(_:market:)` (gets several albums).
     
     No scopes are required for this endpoint.
     
     Read more at the [Spotify web API reference][1].
     
     - Parameters:
       - album: The URI for an album.
       - market: *Optional*. An ISO 3166-1 alpha-2 country code or
             the string "from_token". Provide this parameter if you want
             to apply [Track Relinking][2].
     - Returns: The full version of an [album][3].
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/albums/get-album/
     [2]: https://developer.spotify.com/documentation/general/guides/track-relinking-guide/
     [3]: https://developer.spotify.com/documentation/web-api/reference/object-model/#album-object-full
     */
    func album(
        _ album: SpotifyURIConvertible,
        market: String? = nil
    ) -> AnyPublisher<Album, Error> {
        
        do {
            
            let albumId = try SpotifyIdentifier(uri: album).id
            
            return self.getRequest(
                path: "/albums/\(albumId)",
                queryItems: ["market": market],
                requiredScopes: []
            )
            .spotifyDecode(Album.self)
            
        } catch {
            return error.anyFailingPublisher(Album.self)
        }
        
    }
    
    /**
     Get several albums.
     
     See also `artistAlbums(_:groups:country:limit:offset:)` and
     `album(_:market:)` (gets a single album).
     
     No scopes are required for this endpoint.
     
     Read more at the [Spotify web API reference][1].
     
     - Parameters:
       - albums: An array of up to 20 URIs for albums.
       - market: *Optional*. An [ISO 3166-1 alpha-2 country code][2] or
             the string "from_token". Provide this parameter if you want
             to apply [Track Relinking][3].
     - Returns: An array of the full versions of [albums].
           Albums are returned in the order requested. If an album
           is not found, `nil` is returned in the corresponding position.
           Duplicate albums in the request will result in duplicate artists
           in the response.
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/albums/get-several-albums/
     [2]: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
     [3]: https://developer.spotify.com/documentation/general/guides/track-relinking-guide/
     [4]: https://developer.spotify.com/documentation/web-api/reference/object-model/#album-object-full
     */
    func albums(
        _ albums: [SpotifyURIConvertible],
        market: String? = nil
    ) -> AnyPublisher<[Album?], Error> {
        
        do {
            
            let albumsIdsString = try SpotifyIdentifier
                    .commaSeparatedIdsString(albums)
            
            return self.getRequest(
                path: "/albums",
                queryItems: ["ids": albumsIdsString],
                requiredScopes: []
            )
            .spotifyDecode([String: [Album?]].self)
            .tryMap { dict -> [Album?] in
                if let albums = dict["albums"] {
                    return albums
                }
                throw SpotifyLocalError.topLevelKeyNotFound(
                    key: "albums", dict: dict
                )
            }
            .eraseToAnyPublisher()
            
            
        } catch {
            return error.anyFailingPublisher([Album?].self)
        }
        
    }
    
    /**
     Get the tracks for an album.
     
     No scopes are required for this endpoint.
     
     Read more at the [Spotify web API reference][1].
     
     - Parameters:
       - album: The URI for an album.
       - market: *Optional*. An [ISO 3166-1 alpha-2 country code][2] or
             the string "from_token". Provide this parameter if you want
             to apply [Track Relinking][3].
       - limit: *Optional*. The maximum number of tracks to return.
             Default: 20; Minimum: 1; Maximum: 50.
       - offset: *Optional*. The index of the first track to return.
             Default: 0. Use with `limit` to get the next set of tracks
     - Returns: An array of simplified tracks, wrapped in a paging object.
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/albums/get-albums-tracks/
     [2]: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
     [3]: https://developer.spotify.com/documentation/general/guides/track-relinking-guide/
     */
    func albumTracks(
        _ album: SpotifyURIConvertible,
        market: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil
    ) -> AnyPublisher<PagingObject<Track>, Error> {
        
        do {
            
            let albumId = try SpotifyIdentifier(uri: album).id
            
            return self.getRequest(
                path: "/albums/\(albumId)/tracks",
                queryItems: [
                    "market": market,
                    "limit": limit,
                    "offset": offset
                ],
                requiredScopes: []
            )
            .spotifyDecode(PagingObject<Track>.self)
            
        } catch {
            return error.anyFailingPublisher(PagingObject<Track>.self)
        }
        
    }
    
    
}
