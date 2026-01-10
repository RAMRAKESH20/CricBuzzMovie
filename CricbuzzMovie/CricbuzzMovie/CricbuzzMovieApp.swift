//
//  CricbuzzMovieApp.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//

import SwiftUI
import CoreData

@main
struct CricbuzzMovieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

