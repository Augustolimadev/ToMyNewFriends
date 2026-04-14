# RedHotChiliDevs

A modern iOS app showcasing upcoming performances by artists at various venues.

## 📱 Features

- Browse artists and venues
- View upcoming performances (next 14 days)
- Clean, accessible UI with iOS design guidelines
- Offline-ready with intelligent caching
- Full localization support

## 🏗️ Architecture

This project follows **Clean Architecture** principles with MVVM pattern:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Views, ViewModels, Navigation)        │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Models, Repository Protocols)         │
├─────────────────────────────────────────┤
│           Data Layer                    │
│  (Repository Implementations,           │
│   NetworkService, CacheService)         │
└─────────────────────────────────────────┘
```

### Key Patterns

- **MVVM**: Separation between UI and business logic
- **Repository Pattern**: Abstraction over data sources
- **Router Pattern**: Centralized navigation management
- **Dependency Injection**: Via SwiftUI Environment
- **Protocol-Oriented**: Testable, mockable components

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Augustolimadev/RedHotChiliDevs.git
cd RedHotChiliDevs
```

2. Open the project:
```bash
open RedHotChiliDevs.xcodeproj
```

3. Build and run (⌘R)

### API Configuration

Endpoints:
- `GET /artists` - List all artists
- `GET /venues` - List all venues  
- `GET /artists/{id}/performances?from=...&to=...` - Artist performances
- `GET /venues/{id}/performances?from=...&to=...` - Venue performances

## 📂 Project Structure

```
RedHotChiliDevs/
├── App/
│   └── RedHotChiliDevsApp.swift          # App entry point
│
├── DI/
│   └── AppEnvironment.swift              # Environment keys & values
│
├── Extensions/
│   ├── Date/
│   │   │── Date+Format.swift
│   │   │── DateFormatter+Patterns.swift
│   │   └── String+Hash.swift
│   │   
│   ├── Localizable.xcstrings
│   └── Assets.xcassets
|
├── Features/
│   ├── Artists/
│   │   ├── ArtistDetail/
│   │   │   ├── ArtistDetailView.swift
│   │   │   └── ArtistDetailViewModel.swift
│   │   │   
│   │   └── ArtistList/
│   │       └── ArtistsListView.swift
│   │       └── ArtistsListViewModel.swift
│   │
│   ├── Main/
│   │   └── MainTabView.swift
│   │
│   └── Venues/
│       ├── VenueDetail/
│       │   ├── VenueDetailView.swift
│       │   └── VenueDetailViewModel.swift
│       │   
│       └── VenuesList/
│           ├── VenuesListView.swift
│           └── VenuesListViewModel.swift
│
├── Models/
│   ├── Artist.swift
│   ├── Venue.swift
│   └── Performance.swift
│
├── Networking/
│   ├── Networking/
│   │   └── NetworkService.swift
│   │
│   ├── Cache/
│   │   ├── CacheService.swift
│   │   ├── CacheServiceProtocol.swift
│   │   └── MockCacheService.swift
│   │
│   ├── Repositories/
│   │   ├── ArtistRepository.swift
│   │   ├── ArtistRepositoryProtocol.swift
│   │   ├── VenueRepository.swift
│   │   └── VenueRepositoryProtocol.swift
│   │
│   ├── APIEndpoint.swift
│   ├── MockNetworkService.swift
│   ├── NetworkError.swift
│   ├── NetworkService.swift
│   └── VenueRepositoryProtocol.swift
│
├── Resources/
│   ├── Strings/
│   │   ├── Artists.xcstrings
│   │   ├── Common.xcstrings
│   │   ├── NetworkErrors.xcstrings
│   │   ├── Performances.xcstrings
│   │   └── Venues.xcstrings
│   │   
│   ├── Assets.xcstrings
│   └── Strings.xcassets
│
│── Shared/
│   ├── Entity View/
│   │   ├── EntityHeaderView.swift
│   │   └── EntityRowView.swift
│   │
│   ├── Image loader/
│   │   ├── AsyncEntityImage.swift
│   │   ├── ImageCache.swift
│   │   ├── ImageLoader.swift
│   │   └── MockImageCache.swift
│   │   
│   ├── Navigation/
│   │   ├── NavigableView.swift
│   │   └── NavigationRouter.swift
│   │   
│   ├── Performance/
│   │   ├── PerformanceRowView.swift
│   │   └── PerformancesListView.swift
│   │
│   └── ErrorStateView.swift
│
└── Tests/
    ├── Images/
    │   ├── ImageCacheTests.swift
    │   └── ImageLoaderTests.swift
    │   
    ├── Networking/
    │   ├── APIEndpointTests.swift
    │   └── CacheServiceTests.swift
    │   
    └── ViewModels/
        ├── Artist/
        │   ├── ArtistDetailViewModelTests.swift
        │   └── ArtistsListViewModelTests.swift
        │   
        └── Venue/
            ├── VenueDetailViewModelTests.swift
            └── VenuesListViewModelTests.swift
                 
```

## 🧪 Testing

Run tests with:
```bash
⌘U (in Xcode)
```

Or via command line:
```bash
xcodebuild test -scheme RedHotChiliDevs -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage

- ✅ Unit tests for all ViewModels
- ✅ Repository tests with mocks
- ✅ Cache service tests

## 🌍 Localization

The app is ready for localization with:
- Centralized `Strings.swift` for type-safe string access
- `.xcstrings` files for translations
- Support for multiple languages

To add a new language:
1. In Xcode: Project → Info → Localizations → +
2. Open `.xcstrings` files and add translations
3. No code changes needed!

## 📱 Supported Devices

- iPhone (iOS 17+)
- iPad (iOS 17+)
- Optimized for all screen sizes

## 🔧 Dependencies

This project uses **zero third-party dependencies**, relying entirely on:
- SwiftUI
- Swift Concurrency
- Foundation
- Observation Framework


## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Augusto Lima
