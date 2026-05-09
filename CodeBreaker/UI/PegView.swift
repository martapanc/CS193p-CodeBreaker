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
    
    let pegShape = Circle()
    
    private var isEmpty: Bool { peg == Code.missingPeg }

    var body: some View {
        pegShape
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(isEmpty ? Color.primary.opacity(0.08) : Color(hex: peg))
            .overlay(pegShape.strokeBorder(Color.primary.opacity(isEmpty ? 0.15 : 0.25), lineWidth: 1.5))
    }
}

#Preview {
    PegView(peg: Color.blue.hex).padding()
}
