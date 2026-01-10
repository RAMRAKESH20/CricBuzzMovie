//
//  MovieDetailView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import CoreData

// MARK: - MovieDetailView
/// Displays detailed information about a selected movie, including title, overview, rating, and trailer.
/// Allows the user to toggle "Favorite" status and play videos in a Safari sheet.
struct MovieDetailView: View {
    
    // MARK: - Properties
    
    let movieId: Int
    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Tracks the video selected for playback to present the Safari sheet.
    @State private var selectedVideo: Video?
    
    // MARK: - Initialization
    
    init(movieId: Int) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Loading State
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                } 
                // Error State
                else if let error = viewModel.error {
                    VStack(spacing: 12) {
                        Text("Failed to load details")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {}
                            .buttonStyle(.bordered)
                            .task {
                                await viewModel.loadDetails()
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
                } 
                // Success State
                else {
                    headerSection
                    detailsSection
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                 // Favorite Toggle Button
                 if let movie = viewModel.movie {
                     Button(action: {
                         viewModel.toggleFavorite(context: viewContext, movie: movie)
                     }) {
                         Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                             .foregroundColor(.red)
                     }
                 }
            }
        }
        // Present Safari View when a video is selected
        .sheet(item: $selectedVideo) { video in
            if let url = video.youtubeURL {
                SafariView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Invalid Video URL")
            }
        }
        .task {
            await viewModel.loadDetails()
            viewModel.checkFavoriteStatus(context: viewContext)
        }
    }
    
    // MARK: - Subviews
    
    /// Displays the movie poster and the "Play Trailer" button.
    @ViewBuilder
    private var headerSection: some View {
        ZStack(alignment: .bottomTrailing) {
            if let movie = viewModel.movie, let url = movie.posterURL {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
            } else {
               Rectangle()
                   .fill(Color.gray.opacity(0.3))
                   .frame(height: 300)
            }
            
             // Show Play button only if a trailer exists
             if let video = viewModel.trailers.first, let _ = video.youtubeURL {
                 Button(action: {
                     print("🎬 Play Trailer tapped for video: \(video.id)")
                     selectedVideo = video
                 }) {
                     Label("Play Trailer", systemImage: "play.circle.fill")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .background(.ultraThinMaterial)
                         .cornerRadius(10)
                 }
                 .padding(12)
             }
        }
    }
    
    /// Displays textual details about the movie.
    @ViewBuilder
    private var detailsSection: some View {
        if let movie = viewModel.movie {
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title ?? "Unknown Title")
                    .font(.title)
                    .bold()
                
                HStack {
                    if let rating = movie.voteAverage {
                        Text("⭐ \(String(format: "%.1f", rating))")
                            .foregroundColor(.orange)
                    } else {
                        Text("⭐ N/A")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    if let runtime = movie.runtime {
                        Text("\(runtime) min")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let genres = movie.genres {
                    Text("Genres: " + genres.compactMap { $0.name }.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Divider()
                
                Text("Overview")
                    .font(.headline)
                if let overview = movie.overview, !overview.isEmpty {
                    Text(overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    Text("No overview available.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            .padding(.horizontal)
        }
    }
}

