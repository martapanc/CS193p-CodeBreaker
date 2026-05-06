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
    
    // MARK: Data Owned By Me
    @State private var showInvalidGameAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled(true)
                        .onSubmit {
                            done()
                        }
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
                            done()
                        }
                        .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                            Button("OK") {
                                showInvalidGameAlert = false
                            }
                        } message: {
                            Text("A game must have a name and at least two unique pegs")
                        }
                    
                    }
                }
        }
    }
    
    func done() {
        if game.isValid {
            
        onChoose()
        dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeBreaker {
    var isValid: Bool {
        !name.isEmpty && Set(pegChoices).count >= 2
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.orange, .purple, .pink])
    GameEditor(game: game) {
            print("game name changed to \(game.name)")
            print("game pegs changed to \(game.pegChoices)")
    }
}
