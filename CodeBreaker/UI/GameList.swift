//
//  GameList.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 6/5/26.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]

    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker? = nil
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game._attempts.contains(where: { $0.pegs == game.masterCode.pegs })) &&
            (search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch))
        }
        
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    var summarySize: GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnification
    }
    
    @State private var staticSummarySize: GameSummary.Size = .large
    @State private var dynamicSummarySizeMagnification: CGFloat = 1.0
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game, size: summarySize)
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
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .gesture(summarySizeMagnifier)
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
            EditButton() // Editing the List of games
        }
        .onAppear { addSampleGames() }
    }
    
    var summarySizeMagnifier: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnification = 1.0
            }
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
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
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
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow, .black]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.yellow, .orange, .brown, .black,]))
            modelContext.insert(CodeBreaker(name: "Undersea", pegChoices: [.indigo, .blue, .cyan]))
        }
    }
}

extension GameSummary.Size {
    static func * (lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
            case 2.0...: return lhs.larger.larger
            case 1.5...: return lhs.larger
            case ...0.5: return lhs.smaller
            case ...0.35: return lhs.smaller.smaller
            default: return lhs
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
            GameList(selection: $selection)
    }
}
