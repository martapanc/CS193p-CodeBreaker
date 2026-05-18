//
//  CodeBreaker+Codable.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 18/5/26.
//

import Foundation

extension CodeBreaker: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case masterCode
        case guess
        case attempts
        case pegChoices
        case endTime
        case elapsedTime
        case lastAttemptDate
        case isOver
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(masterCode, forKey: .masterCode)
        try container.encode(guess, forKey: .guess)
        try container.encode(_attempts, forKey: .attempts)
        try container.encode(pegChoices, forKey: .pegChoices)
        try container.encodeIfPresent(endTime, forKey: .endTime)
        try container.encode(elapsedTime, forKey: .elapsedTime)
        try container.encodeIfPresent(lastAttemptDate, forKey: .lastAttemptDate)
        try container.encode(isOver, forKey: .isOver)
    }
}
