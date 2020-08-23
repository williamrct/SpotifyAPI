import Foundation


private extension KeyedDecodingContainer {
    
    func decodeSpotifyAlbumDateFromString(
        _ dateString: String
    ) throws -> Date {
        
        if let longDate = DateFormatter.spotifyAlbumLong
                .date(from: dateString) {
            return longDate
        }
        else if let mediumDate = DateFormatter.spotifyAlbumMedium
                .date(from: dateString) {
            return mediumDate
        }
        else if let shortDate = DateFormatter.spotifyAlbumShort
                .date(from: dateString) {
            return shortDate
        }
        else {
            
            let errorMessage = """
                Could not decode Spotify album date: '\(dateString)'.
                It must be in one of the following formats:
                "YYYY-MM-DD"
                "YYYY-MM"
                "YYYY"
                """
            
            throw DecodingError.typeMismatch(
                Date.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: errorMessage
                )
            )
        }
        
    }
    
    func decodeSpotifyTimestampFromString(
        _ dateString: String
    ) throws -> Date {
        
        if let date = DateFormatter.spotifyTimeStamp.date(
            from: dateString
        ) {
            return date
        }
        else {
            
            let dateFormat = DateFormatter.spotifyTimeStamp.dateFormat
                    ?? "nil"
            
            let errorMessage = """
                Could not decode Soptify timestamp from '\(dateString)'
                It must be in the format '\(dateFormat)'
                """
            
            throw DecodingError.typeMismatch(
                Date.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: errorMessage
                )
            )
            
        }
        
    }
    
}

public extension KeyedDecodingContainer {
    
    
    // MARK: - Spotify Album Dates -
    
    /**
     Decodes a Date from a date-string with one of
     the following formats:
    
     - "YYYY-MM-DD"
     - "YYYY-MM"
     - "YYYY"
    
     - Parameter key: The key that is associated with a date string
           in one of the above formats.
     - Throws: If the value cannot be decded into a string,
           or if the format of the string does not match
           any of the above formats.
     - Returns: The decoded Date.
     */
    func decodeSpotifyAlbumDate(forKey key: Key) throws -> Date {
        
        let dateString = try self.decode(String.self, forKey: key)
        return try self.decodeSpotifyAlbumDateFromString(
            dateString
        )
        
    }
    
    /// See `decodeSpotifyAlbumDate(forKey:)`.
    func decodeSpotifyAlbumDateIfPresent(
        forKey key: Key
    ) throws -> Date? {
    
        guard let dateString = try self.decodeIfPresent(
            String.self, forKey: key
        )
        else {
            return nil
        }
        
        return try self.decodeSpotifyAlbumDateFromString(
            dateString
        )

    }
    
    // MARK: - Spotify Timestamp -
    
    func decodeSpotifyTimestamp(forKey key: Key) throws -> Date {
        
        let dateString = try self.decode(String.self, forKey: key)
        return try self.decodeSpotifyTimestampFromString(
            dateString
        )
        
    }
    
    func decodeSpotifyTimestampIfPresent(
        forKey key: Key
    ) throws -> Date? {
        
        guard let dateString = try self.decodeIfPresent(
            String.self, forKey: key
        )
        else {
            return nil
        }
        
        return try self.decodeSpotifyTimestampFromString(
            dateString
        )
        
    }
    
    // MARK: - Spotify Scopes -
    
    func decodeSpotifyScopesIfPresent(
        forKey key: Key
    ) throws -> Set<Scope>? {
        
        if let scopeString = try self.decodeIfPresent(
            String.self, forKey: key
        ) {
            return Scope.makeSet(scopeString)
        }
        else {
            return nil
        }
    }
    
    // MARK: - Expires in Seconds -
 
    func decodeDateFromExpiresInSeconds(
        forKey key: Key
    ) throws -> Date {
        
        let expiresInSeconds = try self.decode(Int.self, forKey: key)
        return Date(timeInterval: Double(expiresInSeconds), since: Date())
        
    }
    
    func decodeDateFromExpiresInSecondsIfPresent(
        forKey key: Key
    ) throws -> Date? {
        
        guard
            let expiresInSeconds = try self.decodeIfPresent(
                Int.self, forKey: key
            )
        else {
            return nil
        }
        return Date(timeInterval: Double(expiresInSeconds), since: Date())
        
    }
    
    
}


public extension KeyedEncodingContainer {
    
    // MARK: - Spotify Album Dates -
    
    /**
     Encodes a Sate to a date-string in one of
     the following formats, depending on the `datePrecision`.
     
     The expected values for `datePrecision` are:
     
     - "YYYY-MM-DD" if `datePrecision` == "day"
     - "YYYY-MM" if `datePrecision` == "month"
     - "YYYY" if `datePrecision` == "year" or == `nil`.
     
     - Parameters:
       - date: A Date.
       - datePrecision: One of the above-mentioned values.
       - key: A key to associate the Date with.
     - Throws: If the date string could not be encoded
           into the container for the given key.
     */
    mutating func encodeSpotifyAlbumDate(
        _ date: Date,
        datePrecision: String?,
        forKey key: Key
    ) throws {
        
        let formatter: DateFormatter
        
        switch datePrecision {
            case "day":
                formatter = .spotifyAlbumLong
            case "month":
                formatter = .spotifyAlbumMedium
            default:
                formatter = .spotifyAlbumShort
        }
        
        let dateString = formatter.string(from: date)
        
        try self.encode(dateString, forKey: key)
        
    }
    
    /// See `encodeSpotifyAlbumDate(_:datePrecision:forKey:)`.
    mutating func encodeSpotifyAlbumDateIfPresent(
        _ date: Date?,
        datePrecision: String?,
        forKey key: Key
    ) throws {
        
        guard let date = date else { return }
        try self.encodeSpotifyAlbumDate(
            date, datePrecision: datePrecision, forKey: key
        )
    }
    
    // MARK: - Spotify Timestamp -
    
    mutating func encodeSpotifyTimestamp(
        _ date: Date,
        forKey key: Key
    ) throws {
        
        let dateString = DateFormatter.spotifyTimeStamp.string(
            from: date
        )
        try self.encode(dateString, forKey: key)
        
    }
    
    mutating func encodeSpotifyTimestampIfPresent(
        _ date: Date?,
        forKey key: Key
    ) throws {
        
        guard let date = date else { return }
        try self.encodeSpotifyTimestamp(date, forKey: key)
        
    }
    
    // MARK: - Spotify Scopes -
    
    mutating func encodeSpotifyScopesIfPresent(
        _ scopes: Set<Scope>?, forKey key: Key
    ) throws {
        
        guard let scopes = scopes else { return }
        let scopeString = Scope.makeString(scopes)
        try self.encode(scopeString, forKey: key)
        
    }

    
}
