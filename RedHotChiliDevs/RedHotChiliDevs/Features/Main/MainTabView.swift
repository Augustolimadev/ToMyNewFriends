//
//  MainTabView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            ArtistsListView()
                .tabItem {
                    Label("Artists", systemImage: "music.microphone")
                }

            VenuesListView()
                .tabItem {
                    Label("Venues", systemImage: "building.2")
                }
        }
    }
}

#Preview {
    MainTabView()
}
