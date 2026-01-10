//
//  YouTubePlayerView.swift
//  CricbuzzMovie
//
//  Created by Rakesh on 09/01/26.
//
import SwiftUI
import WebKit

struct VideoPlayerView: View {
    let url: URL
 
    var body: some View {
        YouTubePlayerView(url: url)
            .background(Color.black)
    }
}
 
struct YouTubePlayerView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator

        print("🎬 Created WKWebView for YouTube player")
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let videoID = extractYouTubeID(from: url) else {
            print("❌ Failed to extract YouTube video ID from URL: \(url.absoluteString)")
            return
        }

        print("🎬 Loading YouTube video with ID: \(videoID)")

        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    background-color: black;
                    overflow: hidden;
                }
                .video-container {
                    position: relative;
                    width: 100vw;
                    height: 100vh;
                }
                iframe {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    border: none;
                }
            </style>
        </head>
        <body>
            <div class="video-container">
                <iframe
                    src="https://www.youtube.com/embed/\(videoID)?playsinline=1&modestbranding=1&rel=0&enablejsapi=1" 
                    allowfullscreen
                    frameborder="0">
                </iframe>
            </div>
        </body>
        </html>
        """

        webView.loadHTMLString(embedHTML, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func extractYouTubeID(from url: URL) -> String? {
        let cleaned = url.absoluteString
            .components(separatedBy: "?")
            .first ?? url.absoluteString

        if cleaned.contains("youtube.com/embed/") {
            return cleaned.split(separator: "/").last.map(String.init)
        }

        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let v = components.queryItems?.first(where: { $0.name == "v" })?.value {
            return v
        }

        if cleaned.contains("youtu.be/") {
            return url.lastPathComponent
        }

        return nil
    }


    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ YouTube player loaded successfully")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ YouTube player failed to load: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ YouTube player provisional navigation failed: \(error.localizedDescription)")
        }
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        print("🎬 Cleaning up WKWebView")
        uiView.stopLoading()
        uiView.loadHTMLString("", baseURL: nil)
        uiView.navigationDelegate = nil
    }
}
