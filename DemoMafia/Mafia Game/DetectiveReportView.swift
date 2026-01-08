//
//  DetectiveReportView.swift
//  DemoMafia
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct DetectiveReportView: View {
    @ObservedObject var game: MafiaGame
    @State private var selectedDetectiveID: UUID? = nil
    @State private var showReport: Bool = false

    var detectives: [Player] {
        return game.players.filter { $0.role == .detective }
    }

    var body: some View {
        VStack(spacing: 20) {
            if !showReport {
                // Selection screen
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Detective Investigation Reports")
                        .font(.title2)
                        .fontWeight(.bold)

                    if detectives.isEmpty {
                        Text("No detectives in this game")
                            .foregroundColor(.secondary)

                        Button("Continue") {
                            game.dayPhase = .discussion
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Text("Select your detective to view results:")
                            .font(.body)
                            .foregroundColor(.secondary)

                        VStack(spacing: 12) {
                            ForEach(detectives) { detective in
                                Button(action: {
                                    selectedDetectiveID = detective.id
                                    withAnimation {
                                        showReport = true
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "person.badge.shield.checkmark.fill")
                                            .foregroundColor(.blue)

                                        Text(detective.name)
                                            .font(.headline)

                                        Spacer()

                                        if !detective.isAlive {
                                            Text("(Dead)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)

                        Button("Skip Report") {
                            game.dayPhase = .discussion
                        }
                        .buttonStyle(.bordered)
                    }
                }
            } else if let detectiveID = selectedDetectiveID {
                // Show report for selected detective
                ScrollView {
                    VStack(spacing: 20) {
                        if let detective = detectives.first(where: { $0.id == detectiveID }) {
                            Text("\(detective.name)'s Investigations")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        let results = game.getInvestigationResults(for: detectiveID)
                        InvestigationLogView(results: results)
                            .padding(.horizontal)

                        Button("Continue") {
                            game.dayPhase = .discussion
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    DetectiveReportView(game: MafiaGame())
}
