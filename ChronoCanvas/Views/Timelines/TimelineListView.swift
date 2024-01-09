//  TimelineListView.swift

import SwiftUI

struct TimelineListView: View {
    @ObservedObject var viewModel: TimelineListViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    var timelines: [Timeline]
    @State private var selectedTimeline: Timeline?
    
    var body: some View {
        List {
            // ここでAllTimelinesViewへのリンクを追加
            NavigationLink(destination: AllTimelinesView(viewModel: viewModel, allEventsViewModel: AllEventsViewModel(timelineListViewModel: viewModel))) {
                Text("総合")
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .shadow(radius: 2)
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(timelines, id: \.self) { timeline in
                NavigationLink(
                    destination: TimelineEditorView(
                        viewModel: TimelineEditorViewModel(
                            timeline: timeline
                        ),
                        calendarViewModel: calendarViewModel
                    )
                ) {
                    Text(timeline.name ?? "タイムライン名未設定")
                }
                .contextMenu {
                    Button("名前を編集") {
                        self.selectedTimeline = timeline
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .shadow(radius: 2)
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteTimeline)
        }
        .sheet(item: $selectedTimeline) { timeline in
            TimelineEditView(timeline: timeline, isPresented: $selectedTimeline) {
                self.viewModel.loadTimelines()
            }
        }
    }
    
    private func deleteTimeline(at offsets: IndexSet) {
        offsets.forEach { index in
            let timeline = timelines[index]
            viewModel.deleteTimeline(timeline)
        }
    }
}
