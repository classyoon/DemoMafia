//
//  DayView.swift
//  DemoMafia
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var game: MafiaGame
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 38

    var body: some View {
        ZStack {
            MafiaUI.Gradients.day
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if !game.gameTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(game.gameTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(MafiaUI.Colors.textMuted)
                    }

                    Text("DAY \(game.dayNum)")
                        .kerning(6)
                        .font(.system(size: titleSize, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    switch game.dayPhase {
                    case .news:
                        NewsPhaseView(game: game)
                    case .detectiveReport:
                        DetectiveReportView(game: game)
                    case .discussion:
                        DiscussionPhaseView(game: game)
                    case .voting:
                        VotingPhaseView(game: game)
                    case .results:
                        ResultsPhaseView(game: game)
                    default:
                        Text("Unknown phase")
                    }
                }
                .mafiaContentFrame()
            }
        }
    }
}

struct NewsPhaseView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 16) {
            Text("Morning News")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(game.news)
                .font(.body)
                .foregroundColor(MafiaUI.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .mafiaCard(cornerRadius: 8)

            Text("Players")
                .font(.headline)
                .foregroundColor(.white)

            PeopleListView(people: game.players)

            Button("Continue") {
                let hasDetectives = game.players.contains { $0.role == .detective }
                game.dayPhase = hasDetectives ? .detectiveReport : .discussion
            }
            .buttonStyle(MafiaPrimaryButtonStyle(fill: .blue))
            .accessibilityIdentifier("day.newsContinueButton")
        }
    }
}

struct DiscussionPhaseView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 16) {
            Text("Discussion Phase")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Discuss among yourselves who might be the Mafia...")
                .font(.body)
                .foregroundColor(MafiaUI.Colors.textSecondary)
                .multilineTextAlignment(.center)

            PeopleListView(people: game.players)

            Button("Begin Voting") {
                game.startVoting()
            }
            .buttonStyle(MafiaPrimaryButtonStyle(fill: .orange))
            .accessibilityIdentifier("day.beginVotingButton")
        }
    }
}

struct VotingPhaseView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 16) {
            if game.allPlayersVoted {
                VStack(spacing: 16) {
                    Text("All players have cast their votes")
                        .font(.headline)
                        .foregroundColor(.white)

                    Button("Tally Votes") {
                        game.tallyVotes()
                    }
                    .buttonStyle(MafiaPrimaryButtonStyle(fill: .purple))
                    .accessibilityIdentifier("day.tallyVotesButton")
                }
            } else if let currentVoter = game.getCurrentActor() {
                PlayerVoteView(game: game, voter: currentVoter)
            } else {
                Text("Error: No current voter")
                    .foregroundColor(.red)
            }
        }
    }
}

struct PlayerVoteView: View {
    @ObservedObject var game: MafiaGame
    let voter: Player

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Current Voter".uppercased())
                    .font(.caption)
                    .foregroundColor(MafiaUI.Colors.textMuted)

                Text(voter.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.2))
            .cornerRadius(12)

            Text("Who do you want to execute?")
                .font(.headline)
                .foregroundColor(.white)

            PeopleListView(
                people: eligibleTargets,
                selectedPlayerID: game.selectedTargetID,
                onSelect: { targetID in
                    game.selectedTargetID = targetID
                },
                showOnlyAlive: true
            )

            Button("Cast Vote") {
                game.submitVote()
            }
            .buttonStyle(MafiaPrimaryButtonStyle(fill: game.selectedTargetID != nil ? .green : .gray))
            .disabled(game.selectedTargetID == nil)
            .accessibilityIdentifier("day.castVoteButton")
        }
    }

    var eligibleTargets: [Player] {
        return game.players.filter { $0.id != voter.id && $0.isAlive }
    }
}

struct ResultsPhaseView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 16) {
            Text("Execution Results")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(game.news)
                .font(.body)
                .foregroundColor(MafiaUI.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .mafiaCard(cornerRadius: 8)

            Text("Remaining Players")
                .font(.headline)
                .foregroundColor(.white)

            PeopleListView(people: game.players)

            Button("Continue to Night") {
                game.startNight()
            }
            .buttonStyle(MafiaPrimaryButtonStyle(fill: .indigo))
            .accessibilityIdentifier("day.continueToNightButton")
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
    DayView(game: MafiaGame())

    }
}
