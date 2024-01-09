//  TimelineEditorViewModel.swift

import Foundation
import SwiftUI

class TimelineEditorViewModel: ObservableObject {
    // MARK: - Properties
    @Published var timeline: Timeline
    @Published var events: [Event]
    @Published var timelineName: String
    @Published var showAddEventView = false
    var calendarViewModel: CalendarViewModel?
    
    private let eventManager: EventManager
    private let dataManager: DataManager
    
    // MARK: - Initializer
    init(timeline: Timeline, eventManager: EventManager = EventManager(), dataManager: DataManager = .shared) {
        self.timeline = timeline
        self.eventManager = eventManager
        self.dataManager = dataManager
        self.events = eventManager.fetchEvents(for: timeline)
        self.timelineName = timeline.name ?? ""
    }
    
    // MARK: - Timeline Methods
    
    // 年表を保存
    func saveTimeline() {
        timeline.name = timelineName
        DataManager.shared.saveContext()
    }
    
    // 新しいイベントを追加
    func addEvent(title: String, startDate: Date, endDate:Date, isAllDay: Bool, details: String, colorCode: String) {
        var adjustedStartDate = startDate
        var adjustedEndDate = endDate
        if isAllDay {
            let startOfDay = Calendar.current.startOfDay(for: startDate)
            adjustedStartDate = startOfDay
            adjustedEndDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        }
        
        let newEvent = eventManager.createEvent(
            title: title,
            startDate: adjustedStartDate,
            endDate: adjustedEndDate,
            isAllDay: isAllDay,
            details: details,
            colorCode: colorCode,
            in: timeline
        )
        events.append(newEvent)
        saveTimeline()
        calendarViewModel?.loadEvents(for: events)
    }
    
    func updateEvent(_ updatedEvent: Event) {
        // 対象のイベントを更新
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
            saveTimeline()
        }
        calendarViewModel?.loadEvents(for: events)
    }
    
    func saveSelectedColor(for event: Event, color: Color) {
        // SwiftUIのColorをUIColorに変換して、RGB値を取得
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // RGB値を16進数の文字列に変換
        let colorCode = String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        
        // EventのcolorCode属性に保存
        event.colorCode = colorCode
        DataManager.shared.saveContext()
    }
    
    // イベントを削除
    func deleteEvent(_ event: Event) {
        // DataManagerを使用してCoreDataからイベントを削除
        eventManager.deleteEvent(event)
        // ビューモデルのイベントリストからも削除
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
        }
    }
    
    func eventsOnDay(_ date: Date) -> [Event] {
        events.filter { event in
            guard let startDate = event.startDate, let endDate = event.endDate else { return false }
            let startDay = Calendar.current.startOfDay(for: startDate)
            let endDay = Calendar.current.startOfDay(for: endDate)
            let day = Calendar.current.startOfDay(for: date)
            let range = startDay...endDay
            return range.contains(day)
        }.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
    }
}
