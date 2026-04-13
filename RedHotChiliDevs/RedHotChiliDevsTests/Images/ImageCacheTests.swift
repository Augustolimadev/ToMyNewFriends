//
//  ImageCacheTests.swift
//  RedHotChiliDevsTests
//
//  Created by Augusto Lima on 12/4/2026.
//

import Testing
import UIKit
@testable import RedHotChiliDevs

@Suite("Image Cache Tests")
@MainActor
struct ImageCacheTests {
    
    // MARK: - Tests
    @Test("Store and retrieve image")
    func storeAndRetrieve() {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url)
        let retrieved = cache.image(for: url)
        
        #expect(retrieved != nil)
    }
    
    @Test("Remove image from cache")
    func removeImage() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url)
        #expect(cache.image(for: url) != nil)
        
        cache.removeImage(for: url)
        #expect(cache.image(for: url) == nil)
    }
    
    @Test("Clear all cache")
    func clearCache() async {
        
        let cache = MockImageCache()
        let url1 = URL(string: "https://example.com/image1.jpg")!
        let url2 = URL(string: "https://example.com/image2.jpg")!
        let image = createTestImage()
        
        cache.store(image, for: url1)
        cache.store(image, for: url2)
        #expect(cache.count() == 2)
        
        cache.clearCache()
        #expect(cache.count() == 0)
    }
    
    @Test("Cache returns nil for non-existent URL")
    func nonExistentURL() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/nonexistent.jpg")!
        
        let image = cache.image(for: url)
        #expect(image == nil)
    }
    
    @Test("Cache handles multiple images")
    func multipleImages() async {
        
        let cache = MockImageCache()
        let urls = (1...10).map { URL(string: "https://example.com/image\($0).jpg")! }
        let image = createTestImage()
        
        for url in urls {
            cache.store(image, for: url)
        }
        
        #expect(cache.count() == 10)
        
        for url in urls {
            #expect(cache.image(for: url) != nil)
        }
    }
    
    // MARK: - Helper
    private func createTestImage() -> UIImage {
        UIImage(systemName: "photo") ?? UIImage()
    }
}
