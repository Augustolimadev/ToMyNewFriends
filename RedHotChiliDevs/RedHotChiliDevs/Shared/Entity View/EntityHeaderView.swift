//
//  EntityHeaderView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI

/// Reusable header image for detail views
struct EntityHeaderView: View {
    
    let imageURL: URL?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(imageURL: URL?, height: CGFloat = 250, cornerRadius: CGFloat = 16) {
        self.imageURL = imageURL
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        AsyncEntityImage(url: imageURL, cornerRadius: cornerRadius, aspectRatio: .fit)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.horizontal)
    }
}

#Preview {
    EntityHeaderView(imageURL: nil)
}
