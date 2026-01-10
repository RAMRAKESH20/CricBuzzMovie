//
//  SafariView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import SafariServices

// MARK: - SafariView
/// A wrapper around `SFSafariViewController` to display web content (e.g., YouTube trailers) within SwiftUI.
/// Provides a standard in-app browser experience with native controls.
struct SafariView: UIViewControllerRepresentable {
    
    /// The URL to load in the browser.
    let url: URL
    
    // MARK: - UIViewControllerRepresentable Methods
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Initialize with default configuration for best compatibility
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed for static URL presentation
    }
}
