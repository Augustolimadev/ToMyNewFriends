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
git clone https://github.com/yourusername/RedHotChiliDevs.git
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

TODO- Fix structure


```
RedHotChiliDevs/
├── App/
│   └── RedHotChiliDevsApp.swift
├── DI/
│   └── AppEnvironment.swift
├── Extensions/
│   ├── Date/
│   |   ├── KeyedDecodingContainer+Validation.swift
│   |   └── KeyedEncodingContainer+Validation.swift
|   ├── ArtistsListViewModelTests.swift
|   └── ArtistDetailViewModelTests.swift
├── Features/
│   ├── Artists/
│   │   ├── Views/
│   │   │   ├── ArtistsListView.swift
│   │   │   └── ArtistDetailView.swift
│   │   ├── ViewModels/
│   │   │   ├── ArtistsListViewModel.swift
│   │   │   └── ArtistDetailViewModel.swift
│   │   └── Models/
│   │       └── Artist.swift
│   ├── Venues/
│   │   └── ... (similar structure)
│   └── Shared/
│       ├── Components/
│       │   ├── EntityRowView.swift
│       │   ├── PerformanceRowView.swift
│       │   ├── AsyncEntityImage.swift
│       │   └── ErrorStateView.swift
│       └── Navigation/
│           ├── NavigationRouter.swift
│           └── NavigableView.swift
├── Core/
│   ├── Networking/
│   │   ├── NetworkService.swift
│   │   ├── APIEndpoint.swift
│   │   └── NetworkError.swift
│   ├── Cache/
│   │   ├── CacheService.swift
│   │   └── CacheServiceProtocol.swift
│   └── Repositories/
│       ├── ArtistRepository.swift
│       └── VenueRepository.swift
├── Resources/
│   └── Strings/
│       ├── Common.xcstrings
│       ├── Artists.xcstrings
│       ├── Venues.xcstrings
│       └── Performances.xcstrings
└── Tests/
    ├── ArtistsListViewModelTests.swift
    ├── ArtistDetailViewModelTests.swift
    └── ... (more tests)
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

## ♿ Accessibility

The app supports:
- VoiceOver (with proper labels and hints)
- Dynamic Type
- Reduced Motion
- High Contrast

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
