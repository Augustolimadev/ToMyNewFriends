//
//  ImageLoaderTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 13/4/2026.
//

import Testing
import UIKit
@testable import RedHotChiliDevs

// MARK: - Image Loader Tests
@Suite("Image Loader Tests")
@MainActor
struct ImageLoaderTests {
    
    @Test("ImageLoader initializes with nil image")
    func initialState() {
        
        let loader = ImageLoader(url: nil)
        
        #expect(loader.image == nil)
        #expect(loader.isLoading == false)
        #expect(loader.error == nil)
    }
    
    @Test("ImageLoader with nil URL does nothing")
    func nilURL() async {
        
        let loader = ImageLoader(url: nil)
        loader.load()
        
        #expect(loader.image == nil)
        #expect(loader.isLoading == false)
    }
    
    @Test("ImageLoader uses cache when available")
    func cacheHit() async {
        
        let cache = MockImageCache()
        let url = URL(string: "https://example.com/test.jpg")!
        let testImage = UIImage(systemName: "photo")!
        
        cache.store(testImage, for: url)
        
        let loader = ImageLoader(url: url, cache: cache)
        loader.load()
        
        #expect(loader.image != nil)
        #expect(loader.isLoading == false)
        #expect(loader.error == nil)
    }
}
