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

    // Fetch favorite movies sorted by title
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<MovieEntity>
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                if favorites.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(favorites, id: \.self) { movieEntity in
                        // Convert Core Data entity to Movie model for display
                        let movie = Movie(
                            id: Int(movieEntity.id),
                            title: movieEntity.title ?? "Unknown",
                            posterPath: movieEntity.posterPath,
                            overview: "", // Not stored for list
                            voteAverage: movieEntity.voteAverage,
                            releaseDate: movieEntity.releaseDate
                        )
                        
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MovieRow(
                                movie: movie,
                                isFavorite: true,
                                toggleFavorite: { removeFavorite(movie) }
                            )
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    // MARK: - Methods
    
    /// Deletes favorites from the list via swipe gesture.
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { favorites[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting favorite: \(error)")
            }
        }
    }
    
    /// Removes a specific movie from favorites via the button.
    private func removeFavorite(_ movie: Movie) {
        if let entity = favorites.first(where: { $0.id == Int64(movie.id) }) {
            viewContext.delete(entity)
            do {
                try viewContext.save()
            } catch {
                print("Error removing favorite: \(error)")
            }
        }
    }
}
