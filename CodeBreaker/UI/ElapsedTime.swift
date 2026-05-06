//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by Marta Pancaldi on 23/4/26.
//

import SwiftUI

struct ElapsedTime: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format: SystemFormatStyle.DateOffset {
        .offset(to: (startTime ?? .now) - elapsedTime, allowedFields: [.minute, .second])
    }
    var body: some View {
        if startTime != nil {
            if let endTime {
                Text(endTime, format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        } else {
            Image(systemName: "pause")
        }
    }
}
