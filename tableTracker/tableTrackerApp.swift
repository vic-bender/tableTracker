//
//  tableTrackerApp.swift
//  tableTracker
//
//  Created by vic bender on 8/2/25.
//

import SwiftUI

struct Player {
    var name: String
    var primaryPoints: Int = 0
    var secondaryPoints: Int = 0
    var commandPoints: Int = 1  // Start with 1 CP
    var totalPoints: Int {
        primaryPoints + secondaryPoints
    }
}

struct ContentView: View {
    @State private var attackerName: String = ""
    @State private var defenderName: String = ""
    @State private var gameStarted = false
    @State private var gameEnded = false

    @State private var attacker = Player(name: "")
    @State private var defender = Player(name: "")
    @State private var turn = 1
    @State private var currentPhase = "Attacker"

    // Turn-based inputs (reset each turn)
    @State private var attackerTurnPrimary = 0
    @State private var attackerTurnSecondary = 0
    @State private var defenderTurnPrimary = 0
    @State private var defenderTurnSecondary = 0

    var body: some View {
        VStack {
            if !gameStarted {
                VStack {
                    Text("tableTracker v1.9.1")
                        .font(.title)
                    Text("Simple, Free Wargaming")
                    TextField("Attacker Name", text: $attackerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Defender Name", text: $defenderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Start Game") {
                        attacker = Player(name: attackerName, commandPoints: 1)
                        defender = Player(name: defenderName, commandPoints: 1)
                        gameStarted = true
                    }
                }
                .padding()
            } else if gameEnded {
                VStack(spacing: 20) {
                    Text("End of Game")
                        .font(.largeTitle)
                    Text("5 turns elapsed")
                    Text("\(attacker.name): \(attacker.totalPoints) pts")
                    Text("\(defender.name): \(defender.totalPoints) pts")
                    Button("New Game") {
                        attackerName = ""
                        defenderName = ""
                        gameStarted = false
                        gameEnded = false
                        attacker = Player(name: "")
                        defender = Player(name: "")
                        turn = 1
                        currentPhase = "Attacker"
                        attackerTurnPrimary = 0
                        attackerTurnSecondary = 0
                        defenderTurnPrimary = 0
                        defenderTurnSecondary = 0
                    }
                }
            } else {
                VStack {
                    Text("Turn \(turn): \(currentPhase)'s Phase")
                        .font(.headline)

                    VStack {
                        VStack {
                            Text("\(attacker.name) - Attacker")
                                .font(.title2)

                            VStack {
                                Text("Primary Points (This Turn)")
                                Stepper(value: $attackerTurnPrimary, in: 0...100) {
                                    Text("\(attackerTurnPrimary)")
                                }
                                Text("Secondary Points (This Turn)")
                                Stepper(value: $attackerTurnSecondary, in: 0...100) {
                                    Text("\(attackerTurnSecondary)")
                                }
                                Stepper(value: $attacker.commandPoints, in: 0...1000) {
                                    Text("Command Points: \(attacker.commandPoints)")
                                }
                                Text("Total Score: \(attacker.totalPoints)")
                            }
                            .padding()
                        }

                        Divider()

                        VStack {
                            Text("\(defender.name) - Defender")
                                .font(.title2)

                            VStack {
                                Text("Primary Points (This Turn)")
                                Stepper(value: $defenderTurnPrimary, in: 0...100) {
                                    Text("\(defenderTurnPrimary)")
                                }
                                Text("Secondary Points (This Turn)")
                                Stepper(value: $defenderTurnSecondary, in: 0...100) {
                                    Text("\(defenderTurnSecondary)")
                                }
                                Stepper(value: $defender.commandPoints, in: 0...1000) {
                                    Text("Command Points: \(defender.commandPoints)")
                                }
                                Text("Total Score: \(defender.totalPoints)")
                            }
                            .padding()
                        }
                    }

                    HStack {
                        Button("Next Phase") {
                            // Add CP to both players
                            attacker.commandPoints += 1
                            defender.commandPoints += 1

                            if currentPhase == "Attacker" {
                                currentPhase = "Defender"
                            } else {
                                currentPhase = "Attacker"
                                turn += 1

                                // Commit the visible turn scores to each player
                                attacker.primaryPoints += attackerTurnPrimary
                                attacker.secondaryPoints += attackerTurnSecondary
                                defender.primaryPoints += defenderTurnPrimary
                                defender.secondaryPoints += defenderTurnSecondary

                                // Reset turn-based values for next turn
                                attackerTurnPrimary = 0
                                attackerTurnSecondary = 0
                                defenderTurnPrimary = 0
                                defenderTurnSecondary = 0
                            }

                            if turn > 5 {
                                gameEnded = true
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

@main
struct tableTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
