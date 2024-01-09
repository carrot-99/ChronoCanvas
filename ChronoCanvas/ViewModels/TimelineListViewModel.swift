//  TimelineListViewModel.swift

import Foundation

class TimelineListViewModel: ObservableObject {
    @Published var timelines: [Timeline] = []
    private let timelineManager: TimelineManager
    
    init(timelineManager: TimelineManager = TimelineManager()) {
        self.timelineManager = timelineManager
        loadTimelines()
    }
    
    // TimelineManagerを使用してタイムラインをロード
    func loadTimelines() {
        self.timelines = timelineManager.fetchTimelines()
    }
    
    // TimelineManagerを使用して新しいタイムラインを追加
    func addTimeline() {
        _ = timelineManager.createTimeline(name: "名称未設定（長押しで変更）")
        loadTimelines()
    }
    
    // TimelineManagerを使用してタイムラインを削除
    func deleteTimeline(_ timeline: Timeline) {
        timelineManager.deleteTimeline(timeline)
        loadTimelines()
    }
}
