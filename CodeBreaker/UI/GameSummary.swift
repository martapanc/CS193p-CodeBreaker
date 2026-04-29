//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 29/4/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 60)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
//    GameSummary("Game")
}
