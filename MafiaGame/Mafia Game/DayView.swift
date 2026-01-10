//
//  DayView.swift
//  MafiaGame
//
//  Created by Conner Yoon on 4/7/25.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("DAY \(game.dayNum)")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Show different content based on day phase
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
            .padding()
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

            Text(game.news)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)

            Divider()

            Text("Players")
                .font(.headline)

            PeopleListView(people: game.players)

            Button(action: {
                // Check if there are any detectives in the game
                let hasDetectives = game.players.contains { $0.role == .detective }
                game.dayPhase = hasDetectives ? .detectiveReport : .discussion
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
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

            Text("Discuss among yourselves who might be the Mafia...")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            PeopleListView(people: game.players)

            Button(action: {
                game.startVoting()
            }) {
                Text("Begin Voting")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

struct VotingPhaseView: View {
    @ObservedObject var game: MafiaGame

    var body: some View {
        VStack(spacing: 16) {
            if game.allPlayersVoted {
                // All players have voted
                VStack(spacing: 16) {
                    Text("All players have cast their votes")
                        .font(.headline)

                    Button(action: {
                        game.tallyVotes()
                    }) {
                        Text("Tally Votes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            } else if let currentVoter = game.getCurrentActor() {
                // Show current voter's UI
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
            // Current voter indicator
            VStack(spacing: 8) {
                Text("Current Voter")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(voter.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)

            Text("Who do you want to execute?")
                .font(.headline)

            // Target selection
            PeopleListView(
                people: eligibleTargets,
                selectedPlayerID: game.selectedTargetID,
                onSelect: { targetID in
                    game.selectedTargetID = targetID
                },
                showOnlyAlive: true
            )

            // Submit button
            Button(action: {
                game.submitVote()
            }) {
                Text("Cast Vote")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(game.selectedTargetID != nil ? Color.green : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(game.selectedTargetID == nil)
            .padding(.horizontal)
        }
    }

    var eligibleTargets: [Player] {
        // Can vote for anyone except yourself
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

            Text(game.news)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)

            Divider()

            Text("Remaining Players")
                .font(.headline)

            PeopleListView(people: game.players)

            Button(action: {
                game.startNight()
            }) {
                Text("Continue to Night")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    DayView(game: MafiaGame())
}
