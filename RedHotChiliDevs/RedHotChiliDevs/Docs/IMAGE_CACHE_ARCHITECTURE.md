# 📸 Image Caching System - Architecture Documentation

## Overview

A production-ready, two-tier image caching system with automatic cleanup, memory management, and Thread-safety.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│         AsyncEntityImage (SwiftUI)          │
│              User Interface                 │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│            ImageLoader                      │
│         (@Observable State)                 │
│  - Downloads images                         │
│  - Manages loading state                    │
│  - Handles cancellation                     │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│            ImageCache                       │
│         (Two-Tier Cache)                    │
│                                             │
│  ┌─────────────────────────────────────┐    │
│  │     Memory Cache (NSCache)          │    │
│  │  - Fast access                      │    │
│  │  - Limited capacity (50 MB)         │    │
│  │  - Automatic eviction               │    │
│  │  - Cleared on memory warning        │    │
│  └─────────────────────────────────────┘    │
│                                             │
│  ┌─────────────────────────────────────┐    │
│  │     Disk Cache (FileManager)        │    │
│  │  - Persistent storage               │    │
│  │  - Larger capacity (200 MB)         │    │
│  │  - TTL: 1 days                      │    │
│  │  - LRU eviction                     │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

## 🎯 Key Features

### 1. **Two-Tier Caching**
- **Memory Cache**: Ultra-fast, limited capacity
- **Disk Cache**: Persistent, larger capacity

### 2. **Automatic Management**
- Memory warnings trigger memory cache clear
- Expired cache cleanup (1-day TTL)
- Disk size management (LRU eviction)

### 3. **Thread Safety**
- `@unchecked Sendable` with internal synchronization
- Serial queue for disk operations
- NSCache thread-safe memory operations

### 4. **Performance Optimizations**
- Cache promotion (disk → memory)
- Lazy disk writes
- Background cleanup operations

## 📦 Components

### 1. **ImageCache.swift**

Main caching implementation.

**Key Properties:**
```swift
static let shared = ImageCache() // Singleton instance

maxMemoryCacheSizeMB: 50 MB    // Memory limit
maxDiskCacheSizeMB: 200 MB     // Disk limit
cacheTTL: 1 days               // Time-to-live
```

**Public API:**
```swift
func image(for url: URL) -> UIImage?
func store(_ image: UIImage, for url: URL)
func removeImage(for url: URL)
func clearCache()
func getCacheStatistics() -> CacheStatistics
```

**Cache Flow:**
```
1. Check memory cache → FAST PATH
   ├─ Hit: Return image ✅
   └─ Miss: ↓

2. Check disk cache → SLOW PATH
   ├─ Hit: Promote to memory, return ✅
   └─ Miss: Return nil ❌
```

---

### 2. **ImageLoader.swift**

Observable loader for SwiftUI integration.

**Features:**
- `@Observable` for automatic UI updates
- Automatic cancellation on deinit
- Cache integration
- Error handling

**State:**
```swift
@Observable
final class ImageLoader {
    private(set) var image: UIImage?
    private(set) var isLoading: Bool
    private(set) var error: Error?
}
```

**Usage:**
```swift
@State private var loader = ImageLoader(url: imageURL)

loader.image      // Current image
loader.isLoading  // Loading state
loader.error      // Error if any
```

---

### 3. **AsyncEntityImage.swift**

SwiftUI view component.

**Features:**
- Automatic loading via `.task`
- Placeholder during loading
- Error state UI
- Accessibility support

**Usage:**
```swift
AsyncEntityImage(url: artist.imageURL)

AsyncEntityImage(
    url: venue.imageURL,
    cornerRadius: 16,
    aspectRatio: .fit
)
```

---

## 🔄 Data Flow

### Loading an Image

```
User View → AsyncEntityImage
              │
              ├─ .task { loader.load() }
              │
              ▼
         ImageLoader.load()
              │
              ├─ Check cache
              │   ├─ Hit: Update UI ✅
              │   └─ Miss: ↓
              │
              ├─ Download from network
              │   ├─ Success: Store in cache
              │   └─ Error: Set error state
              │
              └─ Update @Observable state
                   │
                   └─ SwiftUI auto-updates UI
```

### Cache Lookup

```
image(for: url)
    │
    ├─ 1. Memory Cache Lookup
    │   └─ NSCache.object(forKey:)
    │       ├─ Hit → Return (< 1ms) ✅
    │       └─ Miss → ↓
    │
    ├─ 2. Disk Cache Lookup
    │   ├─ Check file exists
    │   ├─ Check expiration (1 days)
    │   ├─ Load from disk
    │   ├─ Promote to memory cache
    │   └─ Return (10-50ms) ✅
    │
    └─ 3. Cache Miss
        └─ Return nil ❌
```

---

## 🧹 Cache Management

### Memory Pressure

```swift
// Automatic on memory warning
NotificationCenter.default.addObserver(
    selector: #selector(clearMemoryCache),
    name: UIApplication.didReceiveMemoryWarningNotification
)
```

### Disk Size Management

```swift
// Triggered after each save
cleanupIfNeeded()
    │
    ├─ Calculate total cache size
    ├─ If > 200 MB:
    │   ├─ Sort files by modification date
    │   └─ Remove oldest until < 200 MB
    └─ Done
```

### TTL Expiration

```swift
// On app launch and periodically
cleanupExpiredCache()
    │
    ├─ Enumerate all cached files
    ├─ For each file:
    │   ├─ Check modification date
    │   └─ If > 1 days: Delete
    └─ Done
```

---

## 🔒 Thread Safety

### Memory Cache
- `NSCache` is inherently thread-safe ✅

### Disk Cache
- Serial dispatch queue:
```swift
private let diskQueue = DispatchQueue(
    label: "com.redhotchilidevs.imagecache.disk",
    qos: .utility
)
```

### Sendable Compliance
```swift
final class ImageCache: @unchecked Sendable {
    // Internal synchronization via NSCache + DispatchQueue
}
```

---

## 📊 Performance Characteristics

| Operation | Memory Hit | Disk Hit | Network |
|-----------|------------|----------|---------|
| **Speed** | < 1ms | 10-50ms | 500-2000ms |
| **Reliability** | Volatile | Persistent | Variable |
| **Capacity** | 50 MB | 200 MB | Unlimited |

---

## 🧪 Testing

### Unit Tests

**ImageCacheTests.swift** includes:
- ✅ Store and retrieve
- ✅ Remove image
- ✅ Clear cache
- ✅ Multiple images
- ✅ Non-existent URLs

**ImageLoaderTests.swift** includes:
- ✅ Initial state
- ✅ Nil URL handling
- ✅ Cache integration

### Integration Tests

```swift
@Test("Full cache flow")
func testFullFlow() async {
    let url = URL(string: "https://example.com/test.jpg")!
    
    // 1. Download and cache
    let loader = ImageLoader(url: url)
    await loader.load()
    
    // 2. Should be in memory cache
    let cached = ImageCache.shared.image(for: url)
    #expect(cached != nil)
    
    // 3. New loader should use cache
    let loader2 = ImageLoader(url: url)
    await loader2.load()
    #expect(loader2.isLoading == false)
}
```

---

## 🎓 Usage Examples

### Basic Usage

```swift
struct ArtistRow: View {
    let artist: Artist
    
    var body: some View {
        HStack {
            AsyncEntityImage(url: artist.imageURL)
                .frame(width: 60, height: 60)
            
            Text(artist.name)
        }
    }
}
```

### Custom Configuration

```swift
AsyncEntityImage(
    url: venue.imageURL,
    cornerRadius: 16,
    aspectRatio: .fit
)
.frame(height: 250)
```

### Manual Cache Management

```swift
// Get statistics
let stats = ImageCache.shared.getCacheStatistics()
print("Disk cache: \(stats.diskCacheSizeMB) MB")
print("Files: \(stats.diskCacheFileCount)")

// Clear cache manually
ImageCache.shared.clearCache()

// Remove specific image
ImageCache.shared.removeImage(for: url)
```

### Direct ImageLoader Usage

```swift
@State private var loader = ImageLoader(url: imageURL)

var body: some View {
    VStack {
        if let image = loader.image {
            Image(uiImage: image)
        } else if loader.isLoading {
            ProgressView()
        } else if let error = loader.error {
            Text("Error: \(error.localizedDescription)")
        }
    }
    .task {
        await loader.load()
    }
}
```

---

## 🔧 Configuration

### Adjust Cache Limits

```swift
// In ImageCache.swift

private let maxMemoryCacheSizeMB: Int = 50  // ← Increase for more memory cache
private let maxDiskCacheSizeMB: Int = 200   // ← Increase for more disk cache
private let cacheTTL: TimeInterval = 24 * 60 * 60 // ← Change TTL
```

### Custom Cache Instance

```swift
let customCache = ImageCache.shared // Use singleton

// Or create protocol-conforming mock for tests
struct MockImageCache: ImageCacheProtocol {
    // Custom implementation
}
```

---

## 🐛 Debugging

### Enable Logging

Add to `ImageCache.swift`:

```swift
private func logCacheOperation(_ operation: String, url: URL) {
    print("[ImageCache] \(operation): \(url.lastPathComponent)")
}

// Usage:
func image(for url: URL) -> UIImage? {
    logCacheOperation("Lookup", url: url)
    // ...
}
```

### View Cache Statistics

```swift
let stats = ImageCache.shared.getCacheStatistics()
print("""
Cache Statistics:
- Memory cache items: \(stats.memoryCacheCount)
- Disk cache size: \(String(format: "%.2f MB", stats.diskCacheSizeMB))
- Disk cache files: \(stats.diskCacheFileCount)
""")
```
