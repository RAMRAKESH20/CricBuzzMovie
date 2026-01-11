//
//  FavoritesView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import CoreData

// MARK: - FavoritesView
/// Displays the list of movies marked as favorites by the user.
/// Data is persisted using Core Data.
struct FavoritesView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: FavoritesViewModel
    
    // Custom initializer to ensure viewModel gets context
    init() {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                if viewModel.favorites.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(viewModel.favorites, id: \.self) { movieEntity in
                        let movie = Movie(
                            id: Int(movieEntity.id),
                            title: movieEntity.title ?? "Unknown",
                            posterPath: movieEntity.posterPath,
                            overview: "",
                            voteAverage: movieEntity.voteAverage,
                            releaseDate: movieEntity.releaseDate
                        )
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MovieRow(
                                movie: movie,
                                isFavorite: true,
                                toggleFavorite: { viewModel.removeFavorite(movie) }
                            )
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
