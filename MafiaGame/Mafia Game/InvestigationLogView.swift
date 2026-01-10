//
//  InvestigationLogView.swift
//  MafiaGame
//
//  Created by Claude on 1/8/26.
//

import SwiftUI

struct InvestigationLogView: View {
    let results: [InvestigationResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                Text("Detective Investigation Log")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            if results.isEmpty {
                Text("No investigations yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(results) { result in
                    InvestigationResultRow(result: result)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InvestigationResultRow: View {
    let result: InvestigationResult

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Night \(result.nightNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Text(result.targetName)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("is")
                        .font(.caption)

                    Text(result.isMafia ? "MAFIA" : "NOT Mafia")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(result.isMafia ? .red : .green)
                }
            }

            Spacer()

            Image(systemName: result.isMafia ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .foregroundColor(result.isMafia ? .red : .green)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InvestigationLogView(results: [
        InvestigationResult(
            detectiveID: UUID(),
            targetID: UUID(),
            targetName: "Alice",
            isMafia: true,
            nightNumber: 1
        ),
        InvestigationResult(
            detectiveID: UUID(),
            targetID: UUID(),
            targetName: "Bob",
            isMafia: false,
            nightNumber: 2
        )
    ])
    .padding()
}
