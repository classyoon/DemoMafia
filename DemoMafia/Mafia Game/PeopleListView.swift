//
//  PeopleListView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct PeopleListView: View {
    var people: [Player]
    var selectedPlayerID: UUID? = nil
    var onSelect: ((UUID) -> Void)? = nil
    var showOnlyAlive: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            ForEach(filteredPeople) { person in
                PlayerRowView(
                    player: person,
                    isSelected: selectedPlayerID == person.id,
                    onSelect: onSelect
                )
            }
        }
        .padding(.horizontal)
    }

    var filteredPeople: [Player] {
        if showOnlyAlive {
            return people.filter { $0.isAlive }
        }
        return people
    }
}

struct PlayerRowView: View {
    let player: Player
    let isSelected: Bool
    let onSelect: ((UUID) -> Void)?

    var body: some View {
        Button(action: {
            if player.isAlive, let onSelect = onSelect {
                onSelect(player.id)
            }
        }) {
            HStack {
                Circle()
                    .fill(player.isAlive ? Color.green : Color.red)
                    .frame(width: 10, height: 10)

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.16))
                        .frame(width: 34, height: 34)
                    Text(String(player.name.prefix(1)).uppercased())
                        .font(.caption.weight(.black))
                        .foregroundColor(.white)
                }

                Text(player.name)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(MafiaUI.Colors.textPrimary.opacity(player.isAlive ? 0.96 : 0.55))

                Spacer()

                if !player.isAlive {
                    Text("Dead")
                        .font(.caption)
                        .foregroundColor(MafiaUI.Colors.textMuted)
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: MafiaUI.Layout.rowCornerRadius)
                    .fill(isSelected ? MafiaUI.Colors.selectedFill : MafiaUI.Colors.cardFillSoft)
            )
            .overlay(
                RoundedRectangle(cornerRadius: MafiaUI.Layout.rowCornerRadius)
                    .stroke(isSelected ? MafiaUI.Colors.selectedStroke : MafiaUI.Colors.cardStroke.opacity(0.6), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(!player.isAlive || onSelect == nil)
        .opacity((player.isAlive && onSelect != nil) ? 1.0 : 0.74)
    }
}

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
    PeopleListView(people: [
        Player(name: "Alice", id: UUID(), role: .villager, isAlive: true),
        Player(name: "Bob", id: UUID(), role: .mafia, isAlive: true),
        Player(name: "Charlie", id: UUID(), role: .detective, isAlive: false)
    ])

    }
}

