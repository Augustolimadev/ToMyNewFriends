//
//  NavigableTabView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI

/// A view that wraps content in a NavigationStack with routing support
struct NavigableView<Content: View>: View {
    
    @State private var router = NavigationRouter()
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .withAppNavigationDestinations()
        }
        .environment(\.navigationRouter, router)
    }
}
