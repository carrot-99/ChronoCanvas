//  TimelineManager.swift

import CoreData
import Foundation

final class TimelineManager {
    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
    }

    @discardableResult
    func createTimeline(name: String) -> Timeline {
        let timeline = Timeline(context: dataManager.context)
        timeline.name = Timeline.normalizedName(name)
        dataManager.saveContext()
        return timeline
    }

    func renameTimeline(_ timeline: Timeline, to name: String) {
        timeline.name = Timeline.normalizedName(name)
        dataManager.saveContext()
    }

    /// すべての Timeline を作成順で取得
    func fetchTimelines() -> [Timeline] {
        let request: NSFetchRequest<Timeline> = Timeline.fetchRequest()
        let timelines = (try? dataManager.context.fetch(request)) ?? []
        return timelines.sorted { $0.creationOrder < $1.creationOrder }
    }

    /// Timeline を所属イベントごと削除する（モデルの削除ルールが Nullify のため明示的に削除）
    func deleteTimeline(_ timeline: Timeline) {
        timeline.eventArray.forEach(dataManager.context.delete)
        dataManager.context.delete(timeline)
        dataManager.saveContext()
    }
}
