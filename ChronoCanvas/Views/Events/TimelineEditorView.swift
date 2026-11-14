//  TimelineEditorView.swift

import SwiftUI

/// 1つの年表のカレンダー画面
struct TimelineEditorView: View {
    @ObservedObject var timeline: Timeline
    @StateObject private var viewModel: CalendarViewModel

    init(timeline: Timeline) {
        self.timeline = timeline
        _viewModel = StateObject(wrappedValue: CalendarViewModel(timeline: timeline))
    }

    var body: some View {
        CalendarEventsView(viewModel: viewModel)
            .navigationTitle(timeline.displayName)
            .navigationBarTitleDisplayMode(.inline)
    }
}
