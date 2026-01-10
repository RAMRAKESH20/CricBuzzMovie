//
//  MovieDetailViewModel.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import Foundation
import CoreData
import SwiftUI
import Combine

// MARK: - MovieDetailViewModel
/// Manages the data and logic for the Movie Detail screen.
/// Includes fetching details, trailers, and managing Favorite status via Core Data.
@MainActor
class MovieDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The detailed movie information.
    @Published var movie: MovieDetail?
    
    /// List of available trailers (YouTube videos).
    @Published var trailers: [Video] = []
    
    /// Loading state.
    @Published var isLoading = false
    
    /// Indicates if the movie is marked as a favorite.
    @Published var isFavorite = false
    
    /// Error message if data fetching fails.
    @Published var error: String?

    // MARK: - Private Properties
    private let movieId: Int

    // MARK: - Initialization
    init(movieId: Int) {
        self.movieId = movieId
    }

    // MARK: - Methods
    
    /// Fetches movie details and trailers from the API.
    func loadDetails() async {
        isLoading = true
        error = nil
        
            do {
                // Fetch details and trailers concurrently
                async let detailTask = MovieService.shared.fetchDetails(id: movieId)
                async let trailersTask = MovieService.shared.fetchTrailers(id: movieId)
                
                movie = try await detailTask
                trailers = try await trailersTask
                isLoading = false
            } catch {
                self.error = error.localizedDescription
                isLoading = false
            }
        
    }
    
    /// Checks if the current movie is saved in Core Data favorites.
    /// - Parameter context: The Core Data managed object context.
    func checkFavoriteStatus(context: NSManagedObjectContext) {
        let request = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        request.predicate = NSPredicate(format: "id == %d", Int64(movieId))
        do {
            let count = try context.count(for: request)
            isFavorite = count > 0 // Update UI based on existence
        } catch {
            print("Error checking favorites: \(error)")
        }
    }
    
    /// Toggles the favorite status of the movie (Save/Delete).
    /// - Parameters:
    ///   - context: The Core Data managed object context.
    ///   - movie: The movie details to save (if adding).
    func toggleFavorite(context: NSManagedObjectContext, movie: MovieDetail) {
        let request = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        request.predicate = NSPredicate(format: "id == %d", Int64(movie.id))
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                // Remove from Favorites
                context.delete(entity)
                isFavorite = false
                print("🗑️ Removed from Favorites: \(movie.title ?? "Unknown")")
            } else {
                // Add to Favorites
                let entity = MovieEntity(context: context)
                entity.id = Int64(movie.id)
                entity.title = movie.title ?? "Unknown"
                entity.posterPath = movie.posterPath
                entity.voteAverage = movie.voteAverage ?? 0.0
                entity.releaseDate = movie.releaseDate
                isFavorite = true
                print("❤️ Added to Favorites: \(movie.title ?? "Unknown")")
            }
            // Save Changes
            try context.save()
        } catch {
            print("❌ Error toggling favorite: \(error)")
        }
    }
}
