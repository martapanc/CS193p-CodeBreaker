//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 9/4/26.
//

import Foundation
import SwiftData

@Model class CodeBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var pegChoices: [Peg] // Could be a Set<Peg>
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp }}
        set { _attempts = newValue }
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.0001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )
        
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset()
        
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return } 
        
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}

typealias Peg = String
