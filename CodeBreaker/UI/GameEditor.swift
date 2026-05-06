//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 6/5/26.
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data (Function) in
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var game: CodeBreaker
    
    // MARK: Action Function
    let onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                }
                Section("Pegs") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            onChoose()
                            dismiss()
                        }
                    }
                }
        }
        
        
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple, .pink])
    GameEditor(game: game) {
            print("game name changed to \(game.name)")
            print("game pegs changed to \(game.pegChoices)")
    }
}
