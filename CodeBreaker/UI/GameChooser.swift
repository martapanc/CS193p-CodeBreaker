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
    
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView (columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    .contextMenu {
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            withAnimation {
                                games.removeAll { $0 == game }
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .onChange(of: games) {
                if let selection, !games.contains(selection) {
                    self.selection = nil
                }
            }
            .navigationTitle("Code Breaker")
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
                    .navigationTitle(game.name)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow, .black]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.yellow, .orange, .brown, .black,]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.indigo, .blue, .cyan]))
            selection = games.first
        }
    }
}

#Preview {
    GameChooser()
}
