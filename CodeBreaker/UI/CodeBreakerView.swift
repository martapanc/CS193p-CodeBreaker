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
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode, selection: $selection, ancillaryView: EmptyView())
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection, ancillaryView: guessButton)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index], selection: $selection, ancillaryView: MatchMarkers(matches: game.attempts[index].matches ?? []))
                }
            }
             
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
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
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }

}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color { // Core Graphics module
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
