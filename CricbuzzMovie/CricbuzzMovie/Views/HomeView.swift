//
//  HomeView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import CoreData

// MARK: - HomeView
/// The main view of the application, displaying a list of popular movies and a search bar.
struct HomeView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all favorites to efficiently check status in list
    // Sorted alphabetically for consistency if displayed elsewhere
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<MovieEntity>
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                // Section: Search Results or Popular Movies
                if !searchViewModel.query.isEmpty {
                    searchContent
                } else {
                    popularMoviesContent
                }
            }
            .listStyle(.plain)
            .navigationTitle("Popular Movies")
            .searchable(text: $searchViewModel.query, prompt: "Search movies")
            .task {
                // Initial load
                if viewModel.movies.isEmpty {
                    await viewModel.loadPopularMovies()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Content displayed when a search query is active.
    @ViewBuilder
    private var searchContent: some View {
        if searchViewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
        } else if let error = searchViewModel.error {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if searchViewModel.results.isEmpty {
             Text("No results found for '\(searchViewModel.query)'")
                 .foregroundColor(.secondary)
                 .frame(maxWidth: .infinity, alignment: .center)
                 .padding()
                 .listRowSeparator(.hidden)
        } else {
            ForEach(searchViewModel.results) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                     MovieRow(movie: movie, isFavorite: isFav(movie), toggleFavorite: { toggle(movie) })
                }
            }
        }
    }
    
    /// Content displaying the list of popular movies with pagination.
    @ViewBuilder
    private var popularMoviesContent: some View {
        if let error = viewModel.error {
            VStack {
                Text("Failed to load movies")
                    .font(.headline)
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                Button("Retry") {
                    Task {
                       await viewModel.loadPopularMovies()
                    }
                    
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        } else if viewModel.movies.isEmpty && !viewModel.isLoading {
            Text("No movies available")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        } else {
            ForEach(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    MovieRow(movie: movie, isFavorite: isFav(movie), toggleFavorite: { toggle(movie) })
                        .task {
                            // Trigger pagination when reaching end of list
                            await viewModel.loadMoreMovies(currentItem: movie)
                        }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Checks if a movie is in the favorites list.
    private func isFav(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == Int64(movie.id) }
    }
    
    /// Toggles the favorite status for a movie in Core Data.
    private func toggle(_ movie: Movie) {
        if let existing = favorites.first(where: { $0.id == Int64(movie.id) }) {
            viewContext.delete(existing)
        } else {
            let entity = MovieEntity(context: viewContext)
            entity.id = Int64(movie.id)
            entity.title = movie.title ?? "Unknown"
            entity.posterPath = movie.posterPath
            entity.voteAverage = movie.voteAverage ?? 0.0
            entity.releaseDate = movie.releaseDate
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving fav: \(error)")
        }
    }
}

// MARK: - Subcomponents

/// A single row in the movie list.
struct MovieRow: View {
    let movie: Movie
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title ?? "Unknown Title")
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.releaseDate ?? "Unknown")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let rating = movie.voteAverage {
                    Text("⭐ \(String(format: "%.1f", rating))")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("⭐ N/A")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            // Ensure button tap doesn't trigger NavigationLink
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
