//
//  ContentView.swift
//  Rock Paper Scissors Lizard Spock
//
//  Created by Vishrut Jha on 5/1/24.
//

import SwiftUI

struct GameMove {
    let name: String
    let symbol: String
    var defeats: [(GameMove) -> String]
}

struct GameMoveButton: View {
    var move: GameMove
    var action: () -> Void
    var clickable: Bool = true
    
    var body: some View {
        Button(action: clickable ? action : {}) {
            VStack {
                Image(systemName: move.symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text(move.name)
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 100)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(!clickable)
    }
}

struct ContentView: View {
    @State private var moves: [GameMove] = []
    @State private var userMove: GameMove?
    @State private var cpuMove: GameMove?
    @State private var resultMessage: String = "Make your move!"
    @State private var userScore: Int = 0
    @State private var cpuScore: Int = 0
    @State private var turnsLeft: Int = 10
    @State private var showAlert: Bool = false
    
    func initializeMoves() {
        let rock = GameMove(name: "Rock", symbol: "bubbles.and.sparkles.fill", defeats: [])
        let paper = GameMove(name: "Paper", symbol: "doc.fill", defeats: [])
        let scissors = GameMove(name: "Scissors", symbol: "scissors", defeats: [])
        let lizard = GameMove(name: "Lizard", symbol: "lizard.fill", defeats: [])
        let spock = GameMove(name: "Spock", symbol: "hand.raised.fill", defeats: [])
        
        moves = [rock, paper, scissors, lizard, spock]
        moves[0].defeats = [
            { _ in "Rock crushes Scissors" },
            { _ in "Rock crushes Lizard" }
        ]
        moves[1].defeats = [
            { _ in "Paper covers Rock" },
            { _ in "Paper disproves Spock" }
        ]
        moves[2].defeats = [
            { _ in "Scissors cut Paper" },
            { _ in "Scissors decapitate Lizard" }
        ]
        moves[3].defeats = [
            { _ in "Lizard poisons Spock" },
            { _ in "Lizard eats Paper" }
        ]
        moves[4].defeats = [
            { _ in "Spock smashes Scissors" },
            { _ in "Spock vaporizes Rock" }
        ]
    }
    
    func makeAMove(move: GameMove) {
        if turnsLeft > 0 {
            cpuMove = moves.randomElement()
            userMove = move
            if let userMove = userMove, let cpuMove = cpuMove {
                resultMessage = determineWinner(userMove: userMove, cpuMove: cpuMove)
            }
        } else {
            showAlert = true
        }
    }
    
    func determineWinner(userMove: GameMove, cpuMove: GameMove) -> String {
        if userMove.name == cpuMove.name {
            return "It's a tie!"
        } else if let defeat = userMove.defeats.first(where: { $0(cpuMove).contains(cpuMove.name) }) {
            userScore += 1
            turnsLeft -= 1
            return "You win! \(defeat(cpuMove))"
        } else {
            cpuScore += 1
            turnsLeft -= 1
            return "You lose! \(cpuMove.defeats.first { $0(userMove).contains(userMove.name) }!(userMove))"
        }
    }
    
    func startNewGame() {
        initializeMoves()
        userScore = 0
        cpuScore = 0
        turnsLeft = 10
        resultMessage = "Make your move!"
        cpuMove = nil
        showAlert = false
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 10/255, green: 147/255, blue: 150/255), Color(red: 0/255, green: 109/255, blue: 119/255)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("CPU Chose: \(cpuMove?.name ?? "None")").padding()
                if let cpuMove = cpuMove {
                    GameMoveButton(move: cpuMove, action: {}, clickable: false)
                } else {
                    GameMoveButton(move: GameMove(name: "None", symbol: "questionmark", defeats: []), action: {}, clickable: false)
                }
                Spacer()
                Text(resultMessage).padding()
                HStack {
                    ForEach(Array(moves.prefix(3)), id: \.name) { move in
                        GameMoveButton(move: move) {
                            makeAMove(move: move)
                        }
                    }
                }
                HStack {
                    ForEach(Array(moves.suffix(2)), id: \.name) { move in
                        GameMoveButton(move: move) {
                            makeAMove(move: move)
                        }
                    }
                }
                Spacer()
                HStack {
                    Text("User Score: \(userScore)")
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                    Text("CPU Score: \(cpuScore)")
                        .foregroundColor(.red)
                        .padding(.trailing)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Game Over"),
                      message: Text("The game has ended. \(userScore > cpuScore ? "You won!" : "CPU won!")"),
                      primaryButton: .default(Text("New Game"), action: startNewGame),
                      secondaryButton: .destructive(Text("Cancel"), action: { showAlert = false }))
            }
        }
        .onAppear(perform: initializeMoves)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
