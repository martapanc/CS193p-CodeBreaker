//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 9/4/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black])
    
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
            
            CodeView(code: game.masterCode)
            
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont(minimum: 10)
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers && index != game.attempts.count - 1
                        if showMarkers {
                            MatchMarkers(matches: game.attempts[index].matches)
                        }
                    }.transition(
                        AnyTransition.attempt(game.isOver)
                    )
                }
            }
            
            if !game.isOver {
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(AnyTransition.pegChooser)
            }
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(Animation.restart) {
                game.restart()
                selection = 0
                restarting = false
            }
        }
    }
    
    var pegChooser: some View {
        HStack {
            ForEach(game.pegChoices, id:\.self) { peg in
                Button {
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.masterCode.pegs.count
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
    
    func guess() {
        withAnimation(Animation.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
