# Navigation Architecture Guide

## 📊 Overview

This app uses a **centralized Router pattern** for navigation, providing a scalable and testable architecture.

## 🏗️ Architecture Components

### 1. **NavigationRouter** (`NavigationRouter.swift`)
- **Centralized navigation state** using `@Observable`
- Manages the navigation path
- Provides methods for programmatic navigation
- Type-safe with `Route` enum

### 2. **Route Enum**
Defines all possible navigation destinations:
```swift
enum Route: Hashable {
    case artistDetail(Artist)
    case venueDetail(Venue)
    // Future routes easily added here
}
```

### 3. **NavigableView** (`NavigableView.swift`)
- Wrapper that creates a `NavigationStack` with router support
- Automatically injects router into environment
- Sets up navigation destinations

## 🎯 How to Use

### Basic Navigation

From any view, access the router and navigate:

```swift
@Environment(\.navigationRouter) private var router

Button("View Artist") {
    router.navigate(to: .artistDetail(artist))
}
```

### Navigation Methods

```swift
// Navigate forward
router.navigate(to: .artistDetail(artist))

// Navigate back one level
router.navigateBack()

// Navigate to root
router.navigateToRoot()

// Pop to specific depth
router.popToDepth(2)
```

## ✅ Benefits

### 1. **Centralized Navigation Logic**
- All routes defined in one place
- Easy to see all possible navigation paths
- Single source of truth

### 2. **Type Safety**
- Compile-time checking of routes
- No string-based navigation
- Associated values for route parameters

### 3. **Testability**
```swift
func testNavigation() {
    let router = NavigationRouter()
    router.navigate(to: .artistDetail(artist))
    #expect(router.path.count == 1)
}
```

### 4. **Programmatic Navigation**
Easy to navigate from:
- ViewModels (via dependency injection)
- Deep links
- Push notifications
- Business logic

### 5. **Easy to Extend**
Add new routes without touching existing code:

```swift
enum Route: Hashable {
    case artistDetail(Artist)
    case venueDetail(Venue)
    case performanceDetail(Performance) // ← Just add here
    case settings                       // ← and here
}

// Then add destination:
private extension Route {
    @ViewBuilder
    var destination: some View {
        switch self {
        // ... existing cases
        case .performanceDetail(let performance):
            PerformanceDetailView(performance: performance)
        case .settings:
            SettingsView()
        }
    }
}
```

### 6. **Deep Linking Support**
Easy to implement:

```swift
func handleDeepLink(url: URL) {
    if let route = parseRoute(from: url) {
        router.navigate(to: route)
    }
}
```

### 7. **Analytics Integration**
Track all navigation in one place:

```swift
extension NavigationRouter {
    func navigate(to route: Route) {
        Analytics.track("navigation", properties: ["route": route])
        path.append(route)
    }
}
```

## 🚀 Future Enhancements

### 1. **Tab Persistence**
Save and restore navigation state per tab:

```swift
@Observable
final class TabRouter {
    var artistsRouter = NavigationRouter()
    var venuesRouter = NavigationRouter()
    
    func saveState() { /* persist paths */ }
    func restoreState() { /* restore paths */ }
}
```

### 2. **Conditional Navigation**
```swift
func navigateToArtist(_ artist: Artist) {
    guard userHasAccess else {
        navigate(to: .login)
        return
    }
    navigate(to: .artistDetail(artist))
}
```

### 3. **Navigation Interceptors**
```swift
func navigate(to route: Route) {
    for interceptor in interceptors {
        if !interceptor.shouldNavigate(to: route) {
            return
        }
    }
    path.append(route)
}
```

## 📱 Current Structure

```
MainTabView
├── NavigableView (Artists Tab)
│   ├── ArtistsListView
│   └── .withAppNavigationDestinations()
│       ├── .artistDetail → ArtistDetailView
│       └── .venueDetail → VenueDetailView
│
└── NavigableView (Venues Tab)
    ├── VenuesListView
    └── .withAppNavigationDestinations()
        ├── .artistDetail → ArtistDetailView
        └── .venueDetail → VenueDetailView
```

Each tab has its own independent navigation stack!

## 🎓 Best Practices

1. ✅ **Always use the router** for navigation
2. ✅ **Add new routes to the enum** first
3. ✅ **Keep route destinations simple** - just create the view
4. ✅ **Use router for programmatic navigation** from ViewModels
5. ✅ **Don't use NavigationLink with values** - use Button + router instead
6. ❌ **Don't create NavigationStack** in child views - use NavigableView at root
7. ❌ **Don't scatter .navigationDestination** - keep centralized in Route extension
