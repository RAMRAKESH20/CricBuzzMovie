//
//  WebView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Simple YouTube Embed Wrapper
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
