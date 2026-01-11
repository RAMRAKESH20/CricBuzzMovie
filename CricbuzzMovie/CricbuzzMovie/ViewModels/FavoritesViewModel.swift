//
//  FavoritesViewModel.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import CoreData
import Combine

class FavoritesViewModel: NSObject, ObservableObject {
    @Published var favorites: [MovieEntity] = []
    private var viewContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<MovieEntity>
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>?
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        let request = MovieEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
        self.fetchRequest = request
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: viewContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultsController?.delegate = self
        fetchFavorites()
    }

    private func fetchFavorites() {
        do {
            try fetchedResultsController?.performFetch()
            favorites = fetchedResultsController?.fetchedObjects ?? []
        } catch {
            print("Failed to fetch favorites: \(error)")
            favorites = []
        }
    }

    // MARK: - Methods

    /// Deletes favorites from the list via swipe gesture.
    func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.map { favorites[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting favorite: \(error)")
            }
        }
        fetchFavorites()
    }
    
    /// Removes a specific movie from favorites via the button.
    func removeFavorite(_ movie: Movie) {
        if let entity = favorites.first(where: { $0.id == Int64(movie.id) }) {
            viewContext.delete(entity)
            do {
                try viewContext.save()
            } catch {
                print("Error removing favorite: \(error)")
            }
        }
        fetchFavorites()
    }
}

extension FavoritesViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // This delegate keeps the favorites array up to date
        favorites = fetchedResultsController?.fetchedObjects ?? []
    }
}
