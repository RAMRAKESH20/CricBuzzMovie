//
//  HomeViewModel.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import Foundation
import Combine

// MARK: - HomeViewModel
/// Manages the state for the Home screen, including fetching popular movies and handling pagination.
@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// List of popular movies to display.
    @Published var movies: [Movie] = []
    
    /// Indicates if a network request is currently in progress.
    @Published var isLoading = false
    
    /// Holds any error message from network requests.
    @Published var error: String?
    
    // MARK: - Private Properties
    
    private var currentPage = 1
    private var canLoadMore = true

    // MARK: - Methods
    
    /// Fetches the next page of popular movies from the API.
    /// Resets error state on new attempt.
    func loadPopularMovies() async {
        // Prevent multiple simultaneous requests or loading when no more data is available
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        error = nil // Reset error on new attempt
        
        
            do {
                let newMovies = try await MovieService.shared.fetchPopular(page: currentPage)
                
                if newMovies.isEmpty {
                    // No more movies to load from API
                    canLoadMore = false
                } else {
                    // Append new movies to the existing list
                    movies.append(contentsOf: newMovies)
                    currentPage += 1
                }
                isLoading = false
            } catch {
                self.error = error.localizedDescription
                isLoading = false
            }
        
    }
    
    /// Checks if pagination should be triggered based on the current visible item.
    /// - Parameter currentItem: The movie currently appearing on screen.
    func loadMoreMovies(currentItem: Movie) async {
        // Trigger load when the user reaches the 5th item from the end
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if let movieIndex = movies.firstIndex(where: { $0.id == currentItem.id }),
           movieIndex >= thresholdIndex {
            await loadPopularMovies()
        }
    }
}
