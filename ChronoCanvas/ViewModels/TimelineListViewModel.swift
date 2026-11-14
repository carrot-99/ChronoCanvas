//  TimelineListViewModel.swift

import Combine
import CoreData
import Foundation

final class TimelineListViewModel: ObservableObject {
    @Published private(set) var timelines: [Timeline] = []
    private let timelineManager: TimelineManager
    private var cancellables = Set<AnyCancellable>()

    init(timelineManager: TimelineManager = TimelineManager(), dataManager: DataManager = .shared) {
        self.timelineManager = timelineManager
        loadTimelines()

        // イベント数の表示を最新に保つため、変更があれば再読み込みする
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: dataManager.context)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.loadTimelines() }
            .store(in: &cancellables)
    }

    func loadTimelines() {
        timelines = timelineManager.fetchTimelines()
    }

    func addTimeline(named name: String) {
        timelineManager.createTimeline(name: name)
    }

    func rename(_ timeline: Timeline, to name: String) {
        timelineManager.renameTimeline(timeline, to: name)
    }

    func deleteTimeline(_ timeline: Timeline) {
        timelineManager.deleteTimeline(timeline)
    }
}
