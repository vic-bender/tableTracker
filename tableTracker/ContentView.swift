import SwiftUI

struct ContentView: View {
    @State private var attackerName: String = "" // variable setup
    @State private var defenderName: String = ""
    @State private var gameStarted = false
    @State private var gameEnded = false

    @State private var attacker = Player(name: "") // variables for the whole game / start
    @State private var defender = Player(name: "")
    @State private var turn = 1

    // use optional Ints for blank reset
    @State private var attackerTurnPrimary: Int? = nil
    @State private var attackerTurnSecondary: Int? = nil
    @State private var defenderTurnPrimary: Int? = nil
    @State private var defenderTurnSecondary: Int? = nil

    // formatter for numeric input
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }

    var body: some View {
        VStack {
            if !gameStarted {
                VStack { // start screen
                    Text("tableTracker v1.11.3")
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
                VStack(spacing: 20) { // end of game screen
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
                        attackerTurnPrimary = nil
                        attackerTurnSecondary = nil
                        defenderTurnPrimary = nil
                        defenderTurnSecondary = nil
                    }
                }
            } else {
                VStack(spacing: 20) { // game screen
                    HStack {
                        VStack {
                            Text(attacker.name)
                                .font(.headline)
                            Text("\(attacker.totalPoints) pts")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("Turn \(turn)")
                            .font(.title3)
                        Spacer()
                        VStack {
                            Text(defender.name)
                                .font(.headline)
                            Text("\(defender.totalPoints) pts")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        VStack {
                            Text("\(attacker.name) - Attacker")
                                .font(.title2)

                            VStack {
                                TextField("Primary Points", value: $attackerTurnPrimary, formatter: numberFormatter)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical, 4)

                                TextField("Secondary Points", value: $attackerTurnSecondary, formatter: numberFormatter)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical, 4)

                                Stepper(value: $attacker.commandPoints, in: 0...1000) {
                                    Text("Command Points: \(attacker.commandPoints)")
                                }
                            }
                            .padding()
                        }

                        Divider()

                        VStack {
                            Text("\(defender.name) - Defender")
                                .font(.title2)

                            VStack {
                                TextField("Primary Points", value: $defenderTurnPrimary, formatter: numberFormatter)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical, 4)

                                TextField("Secondary Points", value: $defenderTurnSecondary, formatter: numberFormatter)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.vertical, 4)

                                Stepper(value: $defender.commandPoints, in: 0...1000) {
                                    Text("Command Points: \(defender.commandPoints)")
                                }
                            }
                            .padding()
                        }
                    }

                    HStack {
                        Button("Next Turn") { // Update totals at the end of each turn
                            attacker.primaryPoints += attackerTurnPrimary ?? 0
                            attacker.secondaryPoints += attackerTurnSecondary ?? 0
                            defender.primaryPoints += defenderTurnPrimary ?? 0
                            defender.secondaryPoints += defenderTurnSecondary ?? 0

                            attackerTurnPrimary = nil
                            attackerTurnSecondary = nil
                            defenderTurnPrimary = nil
                            defenderTurnSecondary = nil

                            turn += 1

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

