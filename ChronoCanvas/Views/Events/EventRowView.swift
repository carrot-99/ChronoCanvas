// EventRowView.swift

import SwiftUI

/// イベント一覧の1行
struct EventRowView: View {
    @ObservedObject var event: Event
    var showsTimeline: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(event.displayColor)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.displayTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Label {
                    Text(event.dateRangeText)
                } icon: {
                    Image(systemName: event.isAllDay ? "sun.max" : "clock")
                }
                .font(.caption)
                .foregroundColor(.secondary)

                if let details = event.details, !details.isEmpty {
                    Text(details)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                if showsTimeline, let timeline = event.timeline {
                    Text(timeline.displayName)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(event.displayColor.opacity(0.15)))
                        .foregroundColor(.primary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(event.displayColor.opacity(0.12))
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
