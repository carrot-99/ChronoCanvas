//  AllTimelinesView.swift

import SwiftUI

/// すべての年表のイベントをまとめて表示する「総合」画面
struct AllTimelinesView: View {
    @ObservedObject var listViewModel: TimelineListViewModel
    @StateObject private var viewModel = CalendarViewModel(timeline: nil)

    var body: some View {
        CalendarEventsView(viewModel: viewModel, timelines: listViewModel.timelines)
            .navigationTitle("総合")
            .navigationBarTitleDisplayMode(.inline)
    }
}
