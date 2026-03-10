//
//  InvestigationLogView.swift
//  DemoMafia
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
                    .foregroundColor(.cyan)
                Text("Detective Investigation Log")
                    .font(.headline)
                    .foregroundColor(.cyan)
            }

            if results.isEmpty {
                Text("No investigations yet")
                    .font(.caption)
                    .foregroundColor(MafiaUI.Colors.textMuted)
                    .italic()
            } else {
                ForEach(results) { result in
                    InvestigationResultRow(result: result)
                }
            }
        }
        .mafiaCard(fill: MafiaUI.Colors.cardFill, stroke: MafiaUI.Colors.cardStroke, cornerRadius: 12)
    }
}

struct InvestigationResultRow: View {
    let result: InvestigationResult

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Night \(result.nightNumber)")
                    .font(.caption)
                    .foregroundColor(MafiaUI.Colors.textMuted)

                HStack {
                    Text(result.targetName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(MafiaUI.Colors.textSecondary)

                    Text("is")
                        .font(.caption)
                        .foregroundColor(MafiaUI.Colors.textMuted)

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

struct InvestigationLogView_Previews: PreviewProvider {
    static var previews: some View {
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
}
