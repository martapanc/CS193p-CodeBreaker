//
//  Code+Codable.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 18/5/26.
//

import Foundation

extension Code: Codable {
    enum CodingKeys: String, CodingKey {
        case kind
        case pegs
        case timestamp
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind.description, forKey: .kind)
        try container.encode(pegs, forKey: .pegs)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
