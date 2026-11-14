// CalendarEventsView.swift

import SwiftUI

/// カレンダーと選択日のイベント一覧を組み合わせた画面。
/// 個別の年表画面と総合画面の両方で使う。
struct CalendarEventsView: View {
    @ObservedObject var viewModel: CalendarViewModel
    /// 総合画面でイベントの所属年表を選ぶための一覧
    var timelines: [Timeline] = []

    @State private var formMode: EventFormView.Mode?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                CustomCalendarView(viewModel: viewModel)
                    .frame(height: geometry.size.height * 0.62)

                Divider()

                EventListView(
                    viewModel: viewModel,
                    onSelect: { formMode = .edit($0) },
                    onAdd: addEvent
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addEvent) {
                    Image(systemName: "plus")
                }
                .disabled(!canAddEvent)
                .accessibilityLabel("イベントを追加")
            }
        }
        .sheet(item: $formMode) { mode in
            EventFormView(mode: mode, timelines: viewModel.isOverview ? timelines : [])
        }
    }

    private var canAddEvent: Bool {
        !viewModel.isOverview || !timelines.isEmpty
    }

    private func addEvent() {
        guard canAddEvent else { return }
        formMode = .create(day: viewModel.selectedDate, timeline: viewModel.timeline)
    }
}
