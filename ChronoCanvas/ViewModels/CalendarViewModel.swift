//  CalendarViewModel.swift

import Combine
import CoreData
import SwiftUI

/// カレンダーの1マス分のデータ
struct CalendarDay: Identifiable, Hashable {
    let date: Date
    let isCurrentMonth: Bool
    var id: Date { date }
}

/// カレンダー表示と、選択日のイベント一覧を管理する。
/// `timeline` が nil の場合は全タイムライン（総合）のイベントを扱う。
final class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date {
        didSet { if !calendar.isDate(oldValue, equalTo: selectedDate, toGranularity: .month) { rebuildDays() } }
    }
    @Published private(set) var events: [Event] = []
    @Published private(set) var days: [CalendarDay] = []

    let timeline: Timeline?
    let calendar: Calendar
    private let eventManager: EventManager
    private var eventsByDay: [Date: [Event]] = [:]
    private var cancellables = Set<AnyCancellable>()

    var isOverview: Bool { timeline == nil }

    init(timeline: Timeline?,
         selectedDate: Date = Date(),
         eventManager: EventManager = EventManager(),
         dataManager: DataManager = .shared,
         calendar: Calendar = .current) {
        self.timeline = timeline
        self.selectedDate = selectedDate
        self.eventManager = eventManager
        self.calendar = calendar
        rebuildDays()
        reload()

        // どの画面で編集・削除されても自動で再読み込みする
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: dataManager.context)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.reload() }
            .store(in: &cancellables)
    }

    // MARK: - Data

    func reload() {
        if let timeline, timeline.isDeleted || timeline.managedObjectContext == nil {
            events = []
        } else {
            events = eventManager.fetchEvents(in: timeline)
        }
        indexEvents()
    }

    func delete(_ event: Event) {
        eventManager.deleteEvent(event)
    }

    // MARK: - Calendar

    var displayedMonth: Date {
        calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
    }

    var weekdaySymbols: [String] { calendar.orderedWeekdaySymbols }

    var numberOfWeeks: Int { max(days.count / 7, 1) }

    var isShowingToday: Bool {
        calendar.isDateInToday(selectedDate)
    }

    func changeMonth(by months: Int) {
        if let newDate = calendar.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newDate
        }
    }

    func selectToday() {
        selectedDate = Date()
    }

    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    func events(on date: Date) -> [Event] {
        eventsByDay[calendar.startOfDay(for: date)] ?? []
    }

    var eventsForSelectedDate: [Event] {
        events(on: selectedDate)
    }

    // MARK: - Private

    private func rebuildDays() {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return }
        let firstDay = monthInterval.start
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDay)?.count ?? 30

        let leading = (calendar.component(.weekday, from: firstDay) - calendar.firstWeekday + 7) % 7
        let total = leading + daysInMonth
        let trailing = (7 - total % 7) % 7

        days = (-leading..<(daysInMonth + trailing)).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: firstDay) else { return nil }
            return CalendarDay(date: date, isCurrentMonth: (0..<daysInMonth).contains(offset))
        }
        indexEvents()
    }

    /// 表示中の日付ごとにイベントを振り分けておき、各マスの描画で毎回フィルタしないようにする
    private func indexEvents() {
        guard let first = days.first?.date, let last = days.last?.date else { return }
        var result: [Date: [Event]] = [:]
        for event in events {
            guard let start = event.startDate, let end = event.endDate else { continue }
            var day = max(calendar.startOfDay(for: start), first)
            let lastDay = min(calendar.startOfDay(for: max(start, end)), last)
            while day <= lastDay {
                result[day, default: []].append(event)
                guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
                day = next
            }
        }
        eventsByDay = result
        objectWillChange.send()
    }
}
