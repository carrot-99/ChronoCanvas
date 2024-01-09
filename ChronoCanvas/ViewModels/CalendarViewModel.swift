//  CalendarViewModel.swift

import SwiftUI
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var events: [Event]
    private let eventManager: EventManager

    init(selectedDate: Date, events: [Event], eventManager: EventManager = EventManager()) {
        self.selectedDate = selectedDate
        self.events = events
        self.eventManager = eventManager
    }
    
    func loadEvents(for events: [Event]) {
        self.events = events
    }

    func updateEvents(for timeline: Timeline) {
        self.events = eventManager.fetchEvents(for: timeline)
    }

    var yearMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
    }

    func changeMonth(by months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: selectedDate) {
            self.selectedDate = newDate
        }
    }

    func isSameDay(_ date1: Date?, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1 ?? Date(), inSameDayAs: date2)
    }

    func eventsCountOnDay(_ date: Date) -> Int {
        events.filter { event in
            guard let startDate = event.startDate, let endDate = event.endDate else { return false }
            let startDay = Calendar.current.startOfDay(for: startDate)
            let endDay = Calendar.current.startOfDay(for: endDate)
            let day = Calendar.current.startOfDay(for: date)
            let range = startDay...endDay
            return range.contains(day)
        }.count
    }

    func generateDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        var dates: [Date?] = []
        
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        let startOfMonth = calendar.date(from: components)!
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var daysToAdd = firstWeekday - calendar.firstWeekday
        if daysToAdd < 0 {
            daysToAdd += 7
        }
        
        if daysToAdd > 0 {
            let lastDayOfPrevMonth = calendar.date(byAdding: .day, value: -1, to: startOfMonth)!
            for day in (0..<daysToAdd).reversed() {
                if let prevDay = calendar.date(byAdding: .day, value: -day, to: lastDayOfPrevMonth) {
                    dates.append(prevDay)
                }
            }
        }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!.count
        for day in 1...daysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
            dates.append(date)
        }
        
        let extraDaysNeeded = (7 - dates.count % 7) % 7
        if extraDaysNeeded > 0 {
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            for day in 1...extraDaysNeeded {
                let nextDay = calendar.date(byAdding: .day, value: day - 1, to: nextMonth)
                dates.append(nextDay)
            }
        }
        
        return dates
    }
    
    func colorCodesForDay(_ date: Date) -> [Color] {
        let dayStart = Calendar.current.startOfDay(for: date)
        let eventsForDay = events.filter { event in
            guard let startDate = event.startDate, let endDate = event.endDate else { return false }
            let startDay = Calendar.current.startOfDay(for: startDate)
            let endDay = Calendar.current.startOfDay(for: endDate)
            return (startDay...endDay).contains(dayStart)
        }
//        print("Found \(eventsForDay.count) events for \(date)")
        let colorCodes = eventsForDay.compactMap { event in
            Color(hex: event.colorCode ?? "#FFFFFF")
        }
//        print("Colors for \(date): \(colorCodes)")
        return colorCodes
    }
}
