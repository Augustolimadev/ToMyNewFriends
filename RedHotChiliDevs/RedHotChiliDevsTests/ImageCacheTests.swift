//
//  ImageCacheTests.swift
//  RedHotChiliDevsTests
//
//  Created by Augusto Lima on 12/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

@MainActor
final class ImageCacheTests: XCTestCase {
    
    // MARK: - Tests
    // Store and retrieve image
    func testStoreAndRetrieve() {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url)
        let retrieved = cache.image(for: url)
        
        XCTAssertNotNil(retrieved)
    }
    
    // Remove image from cache
    func testRemoveImage() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url)
        XCTAssertNotNil(cache.image(for: url))
        
        cache.removeImage(for: url)
        XCTAssertNotNil(cache.image(for: url))
    }
    
    // Clear all cache
    func testClearCache() async {
        
        let cache = MockImageCache()
        let url1 = URL(string: "https://example.com/image1.jpg")!
        let url2 = URL(string: "https://example.com/image2.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url1)
        cache.store(image, for: url2)
        XCTAssertEqual(cache.count(), 2)
        
        cache.clearCache()
        XCTAssertEqual(cache.count(), 0)
    }
    
    // Cache returns nil for non-existent URL
    func testNonExistentURL() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/nonexistent.jpg")!
        
        let image = cache.image(for: url)
        XCTAssertNil(image == nil)
    }
    
    //Cache handles multiple images
    func testMultipleImages() async {
        
        let cache = MockImageCache()
        let urls = (1...10).map { URL(string: "https://example.com/image\($0).jpg")! }
        let image = createTestImage()
        
        for url in urls {
            cache.store(image, for: url)
        }
        
        XCTAssertEqual(cache.count(), 10)
        
        for url in urls {
            XCTAssertNotNil(cache.image(for: url))
        }
    }
    
    // MARK: - Helper
    private func createTestImage() -> UIImage {
        UIImage(systemName: "photo") ?? UIImage()
    }
}

// MARK: - Image Loader Tests
@MainActor
struct ImageLoaderTests {
    
    // ImageLoader initializes with nil image
    func testInitialState() {
        
        let loader = ImageLoader(url: nil)
        
        XCTAssertNil(loader.image)
        XCTAssertFalse(loader.isLoading)
        XCTAssertNil(loader.error)
    }
    
    // ImageLoader with nil URL does nothing
    func testNilURL() async {
        
        let loader = ImageLoader(url: nil)
        loader.load()
        
        XCTAssertNil(loader.image)
        XCTAssertFalse(loader.isLoading)
    }
    
    // ImageLoader uses cache when available
    func testCacheHit() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/test.jpg")!
        let testImage = UIImage(systemName: "photo")!
        
        cache.store(testImage, for: url)
        
        let loader = ImageLoader(url: url, cache: cache)
        loader.load()
        
        XCTAssertNotNil(loader.image)
        XCTAssertFalse(loader.isLoading)
        XCTAssertNil(loader.error)
    }
}
