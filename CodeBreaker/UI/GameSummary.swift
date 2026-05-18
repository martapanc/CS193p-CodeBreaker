//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 29/4/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var size: Size = .large
    
    enum Size {
        case compact
        case regular
        case large
        
        var larger: Size {
            return switch self {
                case .compact: .regular
                default: .large
            }
        }
        
        var smaller: Size {
            return switch self {
                case .large: .regular
                default: .compact
            }
        }
    }
    
    var body: some View {
        let layout = size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))
        layout {
            Text(game.name).font(size == .compact ? .body : .title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 60)
            if size == .large {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: CodeBreaker( name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    List {
        GameSummary(game: CodeBreaker( name: "Preview", pegChoices: [.orange, .green, .purple, .pink]), size: .regular)
    }
    List {
        GameSummary(game: CodeBreaker( name: "Preview", pegChoices: [.blue, .black, .white]), size: .compact)
    }
}
