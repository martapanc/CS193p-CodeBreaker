//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 9/4/26.
//

import SwiftUI

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master, )
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = [Code]()
    let pegChoices: [Peg] = [.red, .blue, .green, .yellow]
    
    
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = [.green, .red, .red, .yellow]
    
    enum Kind {
        case master
        case guess
        case attempt
    }
}

typealias Peg = Color
