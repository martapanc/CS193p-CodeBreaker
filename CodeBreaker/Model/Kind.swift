//
//  Kind.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 7/5/26.
//

import Foundation

enum Kind: Equatable {
    case master(isHidden: Bool)
    case guess
    case attempt([Match])
    case unknown

    var description: String {
        switch self {
        case .master(let isHidden):
            return "master:\(isHidden)"
        case .guess:
            return "guess"
        case .attempt(let matches):
            let joined = matches.map(\.rawValue).joined(separator: ",")
            return "attempt:\(joined)"
        case .unknown:
            return "unknown"
        }
    }

    init(description: String) {
        let parts = description.split(separator: ":", maxSplits: 1).map(String.init)
        switch parts.first {
        case "master":
            self = .master(isHidden: parts.last == "true")
        case "guess":
            self = .guess
        case "attempt":
            let matches = (parts.last ?? "")
                .split(separator: ",")
                .compactMap { Match(rawValue: String($0)) }
            self = .attempt(matches)
        default:
            self = .unknown
        }
    }
}
