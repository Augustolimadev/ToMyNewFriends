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
            NavigableView {
                ArtistsListView()
            }
            .tabItem {
                Label(Strings.Artists.tabTitle, systemImage: "music.microphone")
            }
            
            NavigableView {
                VenuesListView()
            }
            .tabItem {
                Label(Strings.Venues.tabTitle, systemImage: "building.2")
            }
        }
    }
}

#Preview {
    MainTabView()
}
