//
//  GameList.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 6/5/26.
//

import SwiftUI

struct GameList: View {
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?

    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    @State private var gameToEdit: CodeBreaker? = nil
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game)
                        .tint(.accentColor)
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
        .navigationDestination(for: CodeBreaker.self) { game in
            CodeBreakerView(game: game)
                .navigationTitle(game.name)
                .navigationBarTitleDisplayMode(.inline)
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // Editing list of games
        }
        .onAppear { addSampleGames() }
    }

    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue, .green])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool>(get: {
            gameToEdit != nil
        }, set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        })
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow, .black]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.yellow, .orange, .brown, .black,]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.indigo, .blue, .cyan]))
            selection = games.first
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
            GameList(selection: $selection)
    }
    
}
