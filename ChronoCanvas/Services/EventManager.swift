//  EventManager.swift

import CoreData
import Foundation

/// イベントの入力値。作成・更新の両方で使う
struct EventDraft {
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(3600)
    var isAllDay: Bool = false
    var details: String = ""
    var colorCode: String = PresetColors.defaultHex
    var timeline: Timeline?

    init() {}

    init(event: Event) {
        title = event.title ?? ""
        startDate = event.startDate ?? Date()
        endDate = event.endDate ?? startDate
        isAllDay = event.isAllDay
        details = event.details ?? ""
        colorCode = event.colorCode ?? PresetColors.defaultHex
        timeline = event.timeline
    }

    /// 指定日の現在時刻から1時間の予定として初期化する
    init(on day: Date, timeline: Timeline?, calendar: Calendar = .current) {
        let now = Date()
        let time = calendar.dateComponents([.hour, .minute], from: now)
        let start = calendar.date(bySettingHour: time.hour ?? 9, minute: time.minute ?? 0, second: 0, of: day) ?? day
        self.startDate = start
        self.endDate = calendar.date(byAdding: .hour, value: 1, to: start) ?? start
        self.timeline = timeline
    }

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 終日の場合は日付単位で比較する
    var isDateRangeValid: Bool {
        if isAllDay {
            return Calendar.current.startOfDay(for: startDate) <= Calendar.current.startOfDay(for: endDate)
        }
        return startDate <= endDate
    }

    var isValid: Bool {
        isDateRangeValid && timeline != nil
    }

    /// 終日イベントは開始日の 0:00 〜 終了日の 23:59:59 に正規化する
    var normalizedDates: (start: Date, end: Date) {
        guard isAllDay else { return (startDate, endDate) }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        return (start, end)
    }
}

final class EventManager {
    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
    }

    /// 指定タイムライン（nil の場合は全タイムライン）のイベントを開始日時順で取得
    func fetchEvents(in timeline: Timeline? = nil) -> [Event] {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        if let timeline {
            request.predicate = NSPredicate(format: "timeline == %@", timeline)
        } else {
            request.predicate = NSPredicate(format: "timeline != nil")
        }
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Event.startDate, ascending: true),
            NSSortDescriptor(keyPath: \Event.title, ascending: true)
        ]
        return (try? dataManager.context.fetch(request)) ?? []
    }

    @discardableResult
    func createEvent(from draft: EventDraft) -> Event? {
        guard draft.isValid else { return nil }
        let event = Event(context: dataManager.context)
        apply(draft, to: event)
        return dataManager.saveContext() ? event : nil
    }

    @discardableResult
    func updateEvent(_ event: Event, with draft: EventDraft) -> Bool {
        guard draft.isValid else { return false }
        apply(draft, to: event)
        return dataManager.saveContext()
    }

    func deleteEvent(_ event: Event) {
        dataManager.context.delete(event)
        dataManager.saveContext()
    }

    private func apply(_ draft: EventDraft, to event: Event) {
        let dates = draft.normalizedDates
        event.title = draft.trimmedTitle
        event.startDate = dates.start
        event.endDate = dates.end
        event.isAllDay = draft.isAllDay
        event.details = draft.details
        event.colorCode = draft.colorCode
        event.timeline = draft.timeline
    }
}
