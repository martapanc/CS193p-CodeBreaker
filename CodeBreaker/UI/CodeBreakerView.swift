//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 9/4/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared with me
    @Binding var game: CodeBreaker
    
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime).flexibleSystemFont()
                    .monospaced()
                    .lineLimit(1)
            }
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection.animation(Animation.selection)) {
                        Button("Guess", action: guess).flexibleSystemFont(minimum: 10)
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers {
                            MatchMarkers(matches: attempt.matches)
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
        .toolbar {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        withAnimation(.selection) {
            game.setGuessPeg(peg, at: selection)
            selection = (selection + 1) % game.masterCode.pegs.count
        }
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
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
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [.blue, .red, .orange])
    NavigationStack {
        CodeBreakerView(game: $game)
    }
}
