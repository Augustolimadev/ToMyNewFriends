//
//  MockImageCache.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import UIKit

// MARK: - Mock Cache
final class MockImageCache: ImageCacheProtocol {
    
    private var storage: [URL: UIImage] = [:]
    
    func image(for url: URL) -> UIImage? {
        storage[url]
    }
    
    func store(_ image: UIImage, for url: URL) {
        storage[url] = image
    }
    
    func removeImage(for url: URL) {
        storage.removeValue(forKey: url)
    }
    
    func clearCache() {
        storage.removeAll()
    }
    
    func count() -> Int {
        storage.count
    }
}
