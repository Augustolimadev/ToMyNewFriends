//
//  ErrorStateView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI

/// Reusable error view with retry action
struct ErrorStateView: View {
    
    let message: String
    let retryAction: () async -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label(Strings.Common.failedToLoad, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(Strings.Common.retry) {
                Task { await retryAction() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ErrorStateView(message: "Something went wrong") {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
