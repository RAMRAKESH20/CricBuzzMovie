//
//  Models.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import Foundation

// MARK: - API Response Models

/// Represents the top-level response for a movie list (e.g., popular movies).
struct MovieResponse: Decodable {
    let results: [Movie]
}

// MARK: - Movie Models

/// Represents a movie in a list (lightweight data).
struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String?
    let posterPath: String?
    let overview: String?
    let voteAverage: Double?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }

    /// Computed property to generate the full poster image URL.
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

/// Represents detailed information about a specific movie.
struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let title: String?
    let posterPath: String?
    let overview: String?
    let voteAverage: Double?
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

// MARK: - Supporting Models

struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String?
}

// MARK: - Video Models

struct VideoResponse: Decodable {
    let results: [Video]
}

/// Represents a video (trailer, teaser, etc.) associated with a movie.
struct Video: Decodable, Identifiable {
    let id: String
    let key: String?
    let name: String?
    let site: String?
    let type: String?
    
    /// Computed property to generate the valid YouTube Watch URL.
    var youtubeURL: URL? {
        // Ensure it's a YouTube video and has a valid key
        guard site == "YouTube", let key = key else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
