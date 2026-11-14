//  EventListView.swift

import SwiftUI

/// 選択日のイベント一覧
struct EventListView: View {
    @ObservedObject var viewModel: CalendarViewModel
    var onSelect: (Event) -> Void
    var onAdd: () -> Void

    @State private var eventPendingDeletion: Event?

    var body: some View {
        let events = viewModel.eventsForSelectedDate

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(DateFormats.dayHeader.string(from: viewModel.selectedDate))
                    .font(.subheadline.weight(.semibold))
                if !events.isEmpty {
                    Text("\(events.count)件")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            if events.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(events, id: \.objectID) { event in
                        Button {
                            onSelect(event)
                        } label: {
                            EventRowView(event: event, showsTimeline: viewModel.isOverview)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                eventPendingDeletion = event
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .confirmationDialog(
            "「\(eventPendingDeletion?.displayTitle ?? "")」を削除しますか？",
            isPresented: Binding(get: { eventPendingDeletion != nil }, set: { if !$0 { eventPendingDeletion = nil } }),
            titleVisibility: .visible
        ) {
            Button("削除", role: .destructive) {
                if let event = eventPendingDeletion {
                    viewModel.delete(event)
                }
                eventPendingDeletion = nil
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 28))
                .foregroundColor(.secondary)
            Text("この日の予定はありません")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("イベントを追加", action: onAdd)
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
