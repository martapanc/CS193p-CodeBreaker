//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 21/4/26.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 0.3)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200) // {0,0} is top-left
    
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing)
        )
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color { // Core Graphics module
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}
