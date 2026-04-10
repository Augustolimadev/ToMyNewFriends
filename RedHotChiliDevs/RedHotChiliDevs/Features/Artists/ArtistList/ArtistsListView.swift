//
//  ArtistsListView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

struct ArtistsListView: View {

    @State private var viewModel: ArtistsListViewModel?

    var body: some View {
        
        NavigationStack {
            content
                .navigationTitle("Artists")
        }
    }
    
    @ViewBuilder
    private var content: some View {
        Text("My srtists list")
    }
}

#Preview {
    ArtistsListView()
}



