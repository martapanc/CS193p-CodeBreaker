//
//  Code.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 15/4/26.
//


import SwiftUI
import SwiftData

@Model class Code {
    var _kind: String = Kind.unknown.description
    var pegs: [Peg]
    var timestamp: Date = Date.now

    var kind: Kind {
        get { Kind(description: _kind) }
        set { _kind = newValue.description }
    }
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)) {
        self.pegs = pegs
        self._kind = kind.description
        self.kind = kind
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kindDescription = try container.decode(String.self, forKey: .kind)
        let pegs = try container.decode([Peg].self, forKey: .pegs)
        let timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp) ?? .now

        self.init(kind: Kind(description: kindDescription), pegs: pegs)
        self.timestamp = timestamp
    }

    static let missingPeg: Peg = ""

    func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
        print(pegs.map { Color(hex: $0).description })
    }
    
    var isHidden: Bool {
        switch kind {
            case .master(let isHidden): return isHidden
            default : return false
        }
    }
    
    func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 4)
    }
    
    var matches: [Match] {
        switch kind {
            case .attempt(let matches):
                return matches
            default:
                return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .partial
            } else {
                return exactMatches[index]
            }
        }
    }
}

enum Match: String {
    case nomatch
    case exact
    case partial
}
