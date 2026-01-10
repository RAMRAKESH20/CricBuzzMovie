import Foundation

// MARK: - MovieService
class MovieService {
    
    // MARK: - Properties
    static let shared = MovieService()
    
    private let apiKey = "b2c8fd39e973cec56c0d13635dc4cb40"
    private let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
    
    // MARK: - API Methods
    
    /// Fetches a list of popular movies with pagination support.
    /// - Parameter page: The page number to fetch (default is 1).
    /// - Returns: An array of `Movie` objects.
    func fetchPopular(page: Int = 1) async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")!
        print("🌍 [API] Request: \(url.absoluteString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            print("✅ [API] Success: fetchPopular (Page \(page)), Count: \(response.results.count)")
            return response.results
        } catch {
            print("❌ [API] Error: fetchPopular failed - \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Fetches detailed information for a specific movie.
    /// - Parameter id: The TMDb ID of the movie.
    /// - Returns: A `MovieDetail` object.
    func fetchDetails(id: Int) async throws -> MovieDetail {
        let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)")!
        print("🌍 [API] Request: \(url.absoluteString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
            print("✅ [API] Success: fetchDetails for ID: \(id)")
            return detail
        } catch {
            print("❌ [API] Error: fetchDetails failed - \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Fetches available videos (trailers, etc.) for a movie.
    /// - Parameter id: The TMDb ID of the movie.
    /// - Returns: An array of `Video` objects filtered for YouTube trailers.
    func fetchTrailers(id: Int) async throws -> [Video] {
        let url = URL(string: "\(baseURL)/movie/\(id)/videos?api_key=\(apiKey)")!
        print("🌍 [API] Request: \(url.absoluteString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(VideoResponse.self, from: data)
            // Filter to only include YouTube Trailers
            let trailers = response.results.filter { $0.site == "YouTube" && $0.type == "Trailer" }
            print("✅ [API] Success: fetchTrailers for ID: \(id), Count: \(trailers.count)")
            return trailers
        } catch {
            print("❌ [API] Error: fetchTrailers failed - \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Searches for movies by title.
    /// - Parameter query: The search string.
    /// - Returns: An array of matching `Movie` objects.
    func search(query: String) async throws -> [Movie] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)")!
        print("🌍 [API] Request: \(url.absoluteString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            print("✅ [API] Success: search query '\(query)', Count: \(response.results.count)")
            return response.results
        } catch {
            print("❌ [API] Error: search failed - \(error.localizedDescription)")
            throw error
        }
    }
}
