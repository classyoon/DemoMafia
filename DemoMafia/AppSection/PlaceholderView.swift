//
//  PlaceholderView.swift
//  DemoMafia
//
//  Created by OpenAI on 4/16/25.
//

import SwiftUI

struct PlaceholderView: View {
    let title: String
    let description: String
    let missingItems: [String]
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "hammer.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Missing wiring:")
                    .font(.headline)
                ForEach(missingItems, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                        Text(item)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: onBack) {
                Text("Back to Menu")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    PlaceholderView(
        title: "Find Game",
        description: "Online matchmaking isn’t wired up yet.",
        missingItems: [
            "Networked lobby and matchmaking",
            "Invite/link sharing",
            "Online game state sync"
        ],
        onBack: {}
    )
}
