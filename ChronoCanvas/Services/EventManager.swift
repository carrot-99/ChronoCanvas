//  EventManager.swift

import Foundation

class EventManager {
    private let dataManager: DataManager
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
    }
    
    // 特定のタイムラインに対するイベントを取得
    func fetchEvents(for timeline: Timeline) -> [Event] {
        let eventsSet = timeline.events as? Set<Event> ?? []
        return Array(eventsSet).sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() })
    }

    // 新しいEventを作成
    func createEvent(title: String, startDate: Date, endDate: Date, isAllDay: Bool, details: String, colorCode: String, in timeline: Timeline) -> Event {
        let event = Event(context: dataManager.context)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.details = details
        event.colorCode = colorCode
        timeline.addToEvents(event)
        dataManager.saveContext()
        return event
    }

    // Eventを削除
    func deleteEvent(_ event: Event) {
        dataManager.context.delete(event)
        dataManager.saveContext()
    }
}
