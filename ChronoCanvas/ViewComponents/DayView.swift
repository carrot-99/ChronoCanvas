//  DayView.swift

import SwiftUI

/// カレンダーの1マス
struct DayView: View {
    let day: CalendarDay
    let isSelected: Bool
    let isToday: Bool
    let weekday: Int
    let colors: [Color]

    private let maxBars = 3

    private var textColor: Color {
        if isSelected && isToday { return .white }
        if !day.isCurrentMonth { return .secondary.opacity(0.5) }
        switch weekday {
        case 1: return .red
        case 7: return .blue
        default: return .primary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(DateFormats.dayNumber.string(from: day.date))
                .font(.system(size: 14, weight: isToday ? .bold : .regular))
                .foregroundColor(textColor)
                .frame(width: 24, height: 24)
                .background(
                    Circle().fill(isToday ? (isSelected ? Color.accentColor : Color.accentColor.opacity(0.15)) : .clear)
                )

            ForEach(Array(colors.prefix(maxBars).enumerated()), id: \.offset) { _, color in
                Capsule()
                    .fill(color.opacity(day.isCurrentMonth ? 1 : 0.4))
                    .frame(height: 5)
            }

            if colors.count > maxBars {
                Text("+\(colors.count - maxBars)")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 1.5)
                .padding(1)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(DateFormats.dayHeader.string(from: day.date))、イベント\(colors.count)件"))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
