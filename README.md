# CricBuzzMovie 🎬

## Movie App (TMDb)

A modern iOS application built using **Swift & SwiftUI** that integrates with **The Movie Database (TMDb) API** to display popular movies, detailed information, trailers, search, and favorites.

This project demonstrates clean architecture, API integration, pagination, and real-world media playback handling.

---

## 📱 App Features

### 🎞 Popular Movies List
- Fetches and displays popular movies from TMDb  
- Pagination support for seamless scrolling  

### 🔍 Search Movies
- Search movies by title using TMDb Search API  
- Real-time results with optimized API calls  

### ❤️ Favorites
- Add or remove movies from favorites  
- Favorites accessible via a dedicated tab  

### 📄 Movie Detail View
- Displays movie overview, poster, rating, release date, and more  
- Clean and user-friendly UI  

### ▶️ Play Trailer
- Watch official movie trailers  
- Uses **SFSafariViewController** for reliable YouTube playback  

### 🧭 Tab Bar Navigation
- **Home** – Movies list  
- **Favorites** – Saved movies  

---

## 📸 Screenshots

<img width="1206" height="2622" alt="Home Screen" src="https://github.com/user-attachments/assets/846d5328-2980-4677-ab23-23ad6d950bf5" />

<img width="1206" height="2622" alt="Detail Screen" src="https://github.com/user-attachments/assets/ae6b085d-e245-447d-84f9-3c478d257b6b" />

---

## ⚠️ YouTube Playback Note

YouTube does **not officially guarantee playback stability** when embedded inside `WKWebView`.

For **100% compliance, reliability, and App Store safety**, this app uses  
**`SFSafariViewController`** for trailer playback, as recommended by Apple.

---

## 🛠 Tech Stack
- **Language:** Swift  
- **UI:** SwiftUI  
- **Architecture:** MVVM  
- **Networking:** URLSession  
- **API:** The Movie Database (TMDb)  
- **Media Playback:** SFSafariViewController  

---

## 🎯 Task – Movie App (TMDb)

Build a simple iOS app that integrates with the TMDb API to:
- Display popular movies  
- Show detailed movie information  
- Play trailers  
- Support search functionality  
- Allow users to favorite movies  

---

## 🚀 Purpose

This project is created to demonstrate:
- API integration with pagination  
- SwiftUI navigation and state management  
- Search implementation  
- Favorites handling  
- Best practices for third-party media playback
