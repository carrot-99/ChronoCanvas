//  DayData.swift

import Foundation

struct DayData: Identifiable {
    let id: String 
    let date: Date
    
    init(date: Date) {
        self.date = date
        self.id = "\(date.timeIntervalSinceReferenceDate)"
    }
}
