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
                    .frame(width: 12, height: 12)

                Text(player.name)
                    .font(.headline)
                    .foregroundColor(player.isAlive ? .primary : .secondary)

                Spacer()

                if !player.isAlive {
                    Text("Dead")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .disabled(!player.isAlive || onSelect == nil)
        .opacity((player.isAlive && onSelect != nil) ? 1.0 : 0.6)
    }
}

#Preview {
    PeopleListView(people: [
        Player(name: "Alice", id: UUID(), role: .villager, isAlive: true),
        Player(name: "Bob", id: UUID(), role: .mafia, isAlive: true),
        Player(name: "Charlie", id: UUID(), role: .detective, isAlive: false)
    ])
}
