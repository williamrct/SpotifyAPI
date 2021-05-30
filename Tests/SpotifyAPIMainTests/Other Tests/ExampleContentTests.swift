import Foundation
import XCTest
import SpotifyWebAPI
import SpotifyExampleContent
import SpotifyAPITestUtilities

/// Ensure that the example content is correctly decoded from JSON
/// without errors.
final class ExampleContentTests: SpotifyAPITestCase {
    
    var sink = ""
    
    static var allTests = [
        ("testAlbums", testAlbums),
        ("testArtists", testArtists),
        ("testAadioAnalysis", testAadioAnalysis),
        ("testAudioFeatures", testAudioFeatures),
        ("testBrowse", testBrowse),
        ("testEpisodes", testEpisodes),
        ("testLibrary", testLibrary),
        ("testPlayer", testPlayer),
        ("testPlaylists", testPlaylists),
        ("testSearch", testSearch),
        ("testShows", testShows),
        ("testTracks", testTracks),
        ("testUserProfile", testUserProfile)
    ]
    
    func testAlbums() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(Album.abbeyRoad)
        
        XCTAssertEqual(Album.abbeyRoad.name, "Abbey Road (Remastered)")
        encodeDecode(Album.darkSideOfTheMoon)
        XCTAssertEqual(
            Album.darkSideOfTheMoon.name,
            "The Dark Side of the Moon"
        )
        encodeDecode(Album.inRainbows)
        XCTAssertEqual(Album.inRainbows.name, "In Rainbows")
        encodeDecode(Album.jinx)
        XCTAssertEqual(Album.jinx.name, "Jinx")
        encodeDecode(Album.meddle)
        XCTAssertEqual(Album.meddle.name, "Meddle")
        encodeDecode(Album.skiptracing)
        XCTAssertEqual(Album.skiptracing.name, "Skiptracing")
        #endif
    }

    func testArtists() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(Artist.crumb, areEqual: ==)
        XCTAssertEqual(Artist.crumb.name, "Crumb")
        encodeDecode(Artist.levitationRoom, areEqual: ==)
        XCTAssertEqual(Artist.levitationRoom.name, "levitation room")
        encodeDecode(Artist.pinkFloyd, areEqual: ==)
        XCTAssertEqual(Artist.pinkFloyd.name, "Pink Floyd")
        encodeDecode(Artist.radiohead, areEqual: ==)
        XCTAssertEqual(Artist.radiohead.name, "Radiohead")
        encodeDecode(Artist.skinshape, areEqual: ==)
        XCTAssertEqual(Artist.skinshape.name, "Skinshape")
        encodeDecode(Artist.theBeatles, areEqual: ==)
        XCTAssertEqual(Artist.theBeatles.name, "The Beatles")
        #endif
    }
    
    func testAadioAnalysis() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(AudioAnalysis.anyColourYouLike)
        #endif
    }
    
    func testAudioFeatures() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(AudioFeatures.fearless)
        #endif
    }
    
    func testBrowse() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(PagingObject.sampleCategoryPlaylists, areEqual: ==)
        encodeDecode(FeaturedPlaylists.sampleFeaturedPlaylists, areEqual: ==)
        encodeDecode(SpotifyCategory.sampleCategories, areEqual: ==)
        #endif
    }
    
    func testEpisodes() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(Episode.seanCarroll111)
        XCTAssertEqual(
            Episode.seanCarroll111.name,
            "111 | Nick Bostrom on Anthropic Selection and Living in a Simulation"
        )
        encodeDecode(Episode.seanCarroll112)
        XCTAssertEqual(
            Episode.seanCarroll112.name,
           "112 | Fyodor Urnov on Gene Editing, CRISPR, and Human Engineering"
        )
        encodeDecode(Episode.samHarris213)
        XCTAssertEqual(
            Episode.samHarris213.name,
            "#213 — The Worst Epidemic"
        )
        encodeDecode(Episode.samHarris214)
        XCTAssertEqual(
            Episode.samHarris214.name,
            "#214 — August 13, 2020"
        )
        encodeDecode(Episode.samHarris215)
        XCTAssertEqual(
            Episode.samHarris215.name,
            "#215 — August 21, 2020"
        )
        #endif
    }
    
    func testLibrary() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(PagingObject.sampleCurrentUserSavedAlbums)
        #endif
    }
    
    func testPlayer() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(CursorPagingObject.sampleRecentlyPlayed)
        encodeDecode(CurrentlyPlayingContext.sampleCurrentPlayback)
        #endif
    }
    
    func testPlaylists() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(PagingObject.thisIsJimiHendrix, areEqual: ==)
        encodeDecode(PagingObject.thisIsPinkFloyd, areEqual: ==)
        encodeDecode(PagingObject.thisIsMacDeMarco, areEqual: ==)
        encodeDecode(PagingObject.thisIsSpoon, areEqual: ==)
        encodeDecode(PagingObject.bluesClassics, areEqual: ==)
        
        encodeDecode(PagingObject.thisIsStevieRayVaughan, areEqual: ==)

        encodeDecode(Playlist.episodesAndLocalTracks, areEqual: ==)
        XCTAssertEqual(Playlist.episodesAndLocalTracks.name, "Local Songs")
        encodeDecode(Playlist.crumb, areEqual: ==)
        XCTAssertEqual(Playlist.crumb.name, "Crumb")
        encodeDecode(Playlist.lucyInTheSkyWithDiamonds, areEqual: ==)
        XCTAssertEqual(
            Playlist.lucyInTheSkyWithDiamonds.name,
            "Lucy in the sky with diamonds"
        )
        encodeDecode(Playlist.thisIsMFDoom, areEqual: ==)
        XCTAssertEqual(
            Playlist.thisIsMFDoom.name,
            "This Is MF DOOM"
        )
        encodeDecode(Playlist.rockClassics, areEqual: ==)
        XCTAssertEqual(
            Playlist.rockClassics.name,
            "Rock Classics"
        )
        encodeDecode(Playlist.thisIsSonicYouth, areEqual: ==)
        XCTAssertEqual(
            Playlist.thisIsSonicYouth.name,
            "This Is: Sonic Youth"
        )
        encodeDecode(Playlist.thisIsRadiohead, areEqual: ==)
        XCTAssertEqual(
            Playlist.thisIsRadiohead.name,
            "This Is Radiohead"
        )
        encodeDecode(Playlist.thisIsSkinshape, areEqual: ==)
        XCTAssertEqual(
            Playlist.thisIsSkinshape.name,
            "This is: Skinshape"
        )
        encodeDecode(Playlist.modernPsychedelia, areEqual: ==)
        XCTAssertEqual(
            Playlist.modernPsychedelia.name,
            "Modern Psychedelia"
        )
        encodeDecode(Playlist.thisIsMildHighClub, areEqual: ==)
        XCTAssertEqual(
            Playlist.thisIsMildHighClub.name,
            "This Is Mild High Club"
        )
        encodeDecode(Playlist.menITrust, areEqual: ==)
        XCTAssertEqual(
            Playlist.menITrust.name,
            "Men I Trust"
        )
        #endif
    }
    
    func testPlaylistItems() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(PlaylistItem.samHarris216)
         XCTAssertEqual(
            PlaylistItem.samHarris216.name,
            "#216 — September 3, 2020"
         )
        encodeDecode(PlaylistItem.samHarris217)
        XCTAssertEqual(
            PlaylistItem.samHarris217.name,
            "#217 — The New Religion of Anti-Racism"
        )
        encodeDecode(PlaylistItem.joeRogan1536)
        XCTAssertEqual(
            PlaylistItem.joeRogan1536.name,
            "#1536 - Edward Snowden"
        )
        encodeDecode(PlaylistItem.joeRogan1537)
        XCTAssertEqual(
            PlaylistItem.joeRogan1537.name,
            "#1537 - Lex Fridman"
        )
        encodeDecode(PlaylistItem.oceanBloom)
        XCTAssertEqual(
            PlaylistItem.oceanBloom.name,
            "Hans Zimmer & Radiohead - Ocean Bloom (full song HQ)"
        )
        encodeDecode(PlaylistItem.echoesAcousticVersion)
        XCTAssertEqual(
            PlaylistItem.echoesAcousticVersion.name,
            "Echoes - Acoustic Version"
        )
        encodeDecode(PlaylistItem.killshot)
        XCTAssertEqual(
            PlaylistItem.killshot.name,
            "Killshot"
        )
        #endif
    }
    
    func testSearch() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(SearchResult.queryCrumb)
        #endif
    }
    
    func testShows() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(Show.seanCarroll)
        XCTAssertEqual(
            Show.seanCarroll.name,
            "Sean Carroll's Mindscape: Science, Society, Philosophy, Culture, Arts, and Ideas"
        )
        encodeDecode(Show.samHarris)
        XCTAssertEqual(Show.samHarris.name, "Making Sense with Sam Harris")
        encodeDecode(Show.joeRogan)
        XCTAssertEqual(Show.joeRogan.name, "The Joe Rogan Experience")
        #endif
    }

    func testTracks() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(Track.because)
        XCTAssertEqual(Track.because.name, "Because - Remastered 2009")
        encodeDecode(Track.comeTogether)
        XCTAssertEqual(Track.comeTogether.name, "Come Together - Remastered 2009")
        encodeDecode(Track.faces)
        XCTAssertEqual(Track.faces.name, "Faces")
        encodeDecode(Track.illWind)
        XCTAssertEqual(Track.illWind.name, "Ill Wind")
        encodeDecode(Track.odeToViceroy)
        XCTAssertEqual(Track.odeToViceroy.name, "Ode To Viceroy")
        encodeDecode(Track.reckoner)
        XCTAssertEqual(Track.reckoner.name, "Reckoner")
        encodeDecode(Track.theEnd)
        XCTAssertEqual(Track.theEnd.name, "The End - Remastered 2009")
        encodeDecode(Track.time)
        XCTAssertEqual(Track.time.name, "Time")
        encodeDecode(PagingObject.jinxTracks)
        #endif
    }
 
    func testUserProfile() {
        #if SWIFT_TOOLS_5_3
        encodeDecode(SpotifyUser.sampleCurrentUserProfile, areEqual: ==)
        #endif
    }

    // print(<#type#>.<#property#>, to: &sink)
    // XCTAssertEqual(Playlist.<#name#>.name, "<#name#>")
    
}
