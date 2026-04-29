//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 29/4/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List($games, id: \.pegChoices, editActions: [.delete, .move]) { $game in
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameSummary(game: game)
                }
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow, .black]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.yellow, .orange, .brown, .black,]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.indigo, .blue, .cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
