//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 21/4/26.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 0.4)
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

    var hex: String {
        let resolved = resolve(in: EnvironmentValues())
        return String(
            format: "#%02X%02X%02X",
            Int(round(Double(resolved.red) * 255)),
            Int(round(Double(resolved.green) * 255)),
            Int(round(Double(resolved.blue) * 255))
        )
    }

    init(hex stringValue: String) {
        var hex = stringValue
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6, let value = UInt64(hex, radix: 16) else {
            self = .clear
            return
        }
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}
