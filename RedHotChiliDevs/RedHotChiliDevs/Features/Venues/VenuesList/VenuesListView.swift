//
//  VenuesListView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

struct VenuesListView: View {
    
    @State private var viewModel: VenuesListViewModel?

    var body: some View {
        
        NavigationStack {
            content
                .navigationTitle("Venues")
        }
    }
    
    @ViewBuilder
    private var content: some View {
        Text("My venues list")
    }
}

#Preview {
    VenuesListView()
}
