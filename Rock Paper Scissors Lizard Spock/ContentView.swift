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
    
    var body: some View {
        Button(action: action) {
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
    }
}

struct ContentView: View {
    @State private var moves: [GameMove] = []
    @State private var userMove: GameMove?
    @State private var cpuMove: GameMove?
    @State private var resultMessage: String = "Make your move!"
    
    @State private var numberOfTurns: Int = 10
    
    func initializeMoves() {
        let rock = GameMove(name: "Rock", symbol: "mountain.2.fill", defeats: [])
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
    
    func determineWinner(userMove: GameMove, cpuMove: GameMove) -> String {
        if userMove.name == cpuMove.name {
            return "It's a tie!"
        } else if let defeat = userMove.defeats.first(where: { $0(cpuMove).contains(cpuMove.name) }) {
            return "You win! \(defeat(cpuMove))"
        } else {
            return "You lose! \(cpuMove.defeats.first { $0(userMove).contains(userMove.name) }!(userMove))"
        }
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(red: 10/255, green: 147/255, blue: 150/255),
                                    Color(red: 0/255, green: 109/255, blue: 119/255)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text(resultMessage).padding()
                ForEach(moves, id: \.name) { move in
                    GameMoveButton(move: move) {
                        cpuMove = moves.randomElement()
                        userMove = move
                        if let userMove = userMove, let cpuMove = cpuMove {
                            resultMessage = determineWinner(userMove: userMove, cpuMove: cpuMove)
                        }
                    }
                }
            }
        }
        .onAppear(perform: initializeMoves)
    }
}

#Preview {
    ContentView()
}
