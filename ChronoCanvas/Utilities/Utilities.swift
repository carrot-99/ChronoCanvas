// Utilities.swift

import Foundation
import SwiftUI

/// 日付フォーマッタ（生成コストが高いため使い回す）
enum DateFormats {
    private static func make(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter
    }

    /// 2024年1月
    static let month = make("yyyy年M月")
    /// 1
    static let dayNumber = make("d")
    /// 2024/01/05(金)
    static let day = make("yyyy/MM/dd(E)")
    /// 1月5日(金)
    static let dayHeader = make("M月d日(E)")
    /// 13:30
    static let time = make("HH:mm")
    /// 2024/01/05 13:30
    static let dateTime = make("yyyy/MM/dd HH:mm")
}

extension Calendar {
    /// firstWeekday を考慮した曜日の短縮表記（例: 日 月 火 ...）
    var orderedWeekdaySymbols: [String] {
        var calendar = self
        calendar.locale = Locale(identifier: "ja_JP")
        let symbols = calendar.veryShortWeekdaySymbols
        let offset = firstWeekday - 1
        return Array(symbols[offset...] + symbols[..<offset])
    }

    /// 並び替え後の曜日インデックスから weekday（1=日曜 … 7=土曜）を求める
    func weekday(atColumn column: Int) -> Int {
        (firstWeekday - 1 + column) % 7 + 1
    }
}

/// プリセットの色（16進コードで保持し、色空間変換による不一致を避ける）
enum PresetColors {
    static let hexes = [
        "#FF3B30", // red
        "#FF9500", // orange
        "#FFCC00", // yellow
        "#34C759", // green
        "#30B0C7", // teal
        "#007AFF", // blue
        "#5856D6", // indigo
        "#AF52DE", // purple
        "#FF2D55", // pink
        "#8E8E93"  // gray
    ]
    static let defaultHex = "#007AFF"
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0x00, 0x7A, 0xFF)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

/// 白背景のカード風スタイル（ダークモード対応）
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
