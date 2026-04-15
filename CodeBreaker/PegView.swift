//
//  PegView.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 15/4/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: .blue).padding()
}
