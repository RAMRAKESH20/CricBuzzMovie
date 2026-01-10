# CricBuzzMovie

🎬 Movie App (TMDb)

A modern iOS application built using Swift & SwiftUI that integrates with The Movie Database (TMDb) API to display popular movies, detailed information, trailers, search, and favorites.

This project demonstrates clean architecture, API integration, pagination, and real-world media playback handling.

📱 App Features

🎞 Popular Movies List

Fetches and displays popular movies from TMDb

Pagination support for seamless scrolling

🔍 Search Movies

Search movies by title using TMDb search API

Real-time results with optimized API calls

❤️ Favorites

Add/remove movies to favorites

Favorites accessible via a dedicated tab

📄 Movie Detail View

Displays movie overview, poster, rating, release date, and more

Clean and user-friendly UI

▶️ Play Trailer

Watch official movie trailers

Uses SFSafariViewController for reliable YouTube playback

🧭 Tab Bar Navigation

Home (Movies)

Favorites
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-01-10 at 12 31 15" src="https://github.com/user-attachments/assets/846d5328-2980-4677-ab23-23ad6d950bf5" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-01-10 at 12 31 10" src="https://github.com/user-attachments/assets/ae6b085d-e245-447d-84f9-3c478d257b6b" />



⚠️ YouTube Playback Note

YouTube does not officially guarantee playback stability when embedded inside WKWebView.
For 100% compliance, reliability, and App Store safety, this app uses
SFSafariViewController for trailer playback, as recommended by Apple.
