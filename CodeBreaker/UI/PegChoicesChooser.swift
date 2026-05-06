//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 6/5/26.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Peg]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    button("Peg choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            
            button("Add Peg", systemImage: "plus.circle", color: .green) {
                pegChoices.append(.green)
            }
        }
    }
    
    func button(
        _ title: String,
        systemImage: String,
        color: Color? = nil,
            action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation{
                    action()
                }
        } label: {
            Image(systemName: systemImage).tint(color)
        }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [.green, .orange, .yellow]
    
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
