#if TEST
import Foundation
import Swifter

/// Manages a server that can be started to listen for when the Spotify
/// web API redirects to "http://localhost:8080".
public struct RedirectListener {
    
    let server = HttpServer()
    
    private var didRun = false

    /**
     Starts the server. Does not block; returns immediately after the
     server starts.
    
     - Parameter receiveURL: A closure that is called when the server
           receives the URL.
     */
    public mutating func start(
        receiveURL: @escaping (URL) -> Void
    ) throws {
        
        precondition(!self.didRun, "can only run once")
        self.didRun = true

        self.server[""] = { request in
            var urlComponents = URLComponents(
                url: localHostURL,
                resolvingAgainstBaseURL: false
            )!
            let query = request.queryParams
            urlComponents.queryItems = query.map { query in
                URLQueryItem(name: query.0, value: query.1)
            }
            let url = urlComponents.url!
            receiveURL(url)
            return .ok(.text("received redirect"))
        }
        
        try self.server.start()

    }

    /// Stops the server.
    public mutating func shutdown() {
        self.server.stop()
    }
    
    
}

#endif
