//  Event+Extensions.swift

import CoreData
import SwiftUI

extension Event {
    var displayTitle: String {
        let trimmed = (title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "無題のイベント" : trimmed
    }

    var displayColor: Color {
        Color(hex: colorCode ?? PresetColors.defaultHex)
    }

    /// 指定日にこのイベントが含まれるか（複数日にまたがるイベントも考慮）
    func occurs(on day: Date, calendar: Calendar = .current) -> Bool {
        guard let startDate, let endDate else { return false }
        let target = calendar.startOfDay(for: day)
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: max(startDate, endDate))
        return (start...end).contains(target)
    }

    /// 一覧表示用の日時テキスト
    var dateRangeText: String {
        guard let startDate, let endDate else { return "" }
        let calendar = Calendar.current
        if isAllDay {
            let start = DateFormats.day.string(from: startDate)
            if calendar.isDate(startDate, inSameDayAs: endDate) {
                return "\(start) 終日"
            }
            return "\(start) 〜 \(DateFormats.day.string(from: endDate)) 終日"
        }
        if calendar.isDate(startDate, inSameDayAs: endDate) {
            return "\(DateFormats.day.string(from: startDate)) \(DateFormats.time.string(from: startDate)) 〜 \(DateFormats.time.string(from: endDate))"
        }
        return "\(DateFormats.dateTime.string(from: startDate)) 〜 \(DateFormats.dateTime.string(from: endDate))"
    }
}

extension Timeline {
    static let defaultName = "名称未設定"

    static func normalizedName(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? defaultName : trimmed
    }

    var displayName: String {
        let trimmed = (name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? Timeline.defaultName : trimmed
    }

    var eventArray: [Event] {
        let set = events as? Set<Event> ?? []
        return set.sorted { ($0.startDate ?? .distantPast) < ($1.startDate ?? .distantPast) }
    }

    var eventCount: Int {
        events?.count ?? 0
    }

    /// SQLite ストアの主キー（p1, p2, ...）から作成順を推定する。
    /// モデルに作成日時の属性がないため、マイグレーションなしで安定した並び順を得る目的で使う。
    var creationOrder: Int {
        guard !objectID.isTemporaryID else { return .max }
        let key = objectID.uriRepresentation().lastPathComponent.dropFirst()
        return Int(key) ?? .max
    }
}
