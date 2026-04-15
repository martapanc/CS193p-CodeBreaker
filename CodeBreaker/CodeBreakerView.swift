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
            view(for: game.masterCode)
            
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            pegChooser
        }.padding()
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
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        if selection == index, code.kind == .guess {
                            Selection.shape
                                .foregroundStyle(Selection.color)
                        }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            
            MatchMarkers(matches: code.matches).overlay {
                if code.kind == .guess {
                    guessButton
                }
            }
        }
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let color: Color = Color.gray(0.89)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
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
