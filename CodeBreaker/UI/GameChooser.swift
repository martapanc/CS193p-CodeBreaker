//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 29/4/26.
//

import SwiftUI
import SwiftData

struct GameChooser: View {    
    @State private var selection: CodeBreaker? = nil
    @State private var sortOption: GameList.SortOption = .name
    
    var body: some View {
        NavigationSplitView (columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            GameList(sortBy: sortOption, selection: $selection)
                .navigationTitle("Code Breaker")
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
        
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
