//
//  SearchViewModel.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import Foundation
import Combine

// MARK: - SearchViewModel
/// Manages search functionality with debouncing to reduce API calls.
@MainActor
class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The current search query typed by the user.
    @Published var query = ""
    
    /// List of search results.
    @Published var results: [Movie] = []
    
    /// Loading state for search requests.
    @Published var isLoading = false
    
    /// Error message for failed search.
    @Published var error: String?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        // Debounce search input: Wait 0.5s after user stops typing before searching
        $query
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    private func performSearch(query: String) {
        // Clear results if query is empty
        guard !query.isEmpty else {
            results = []
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let movies = try await MovieService.shared.search(query: query)
                results = movies
                isLoading = false
            } catch {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }
}
