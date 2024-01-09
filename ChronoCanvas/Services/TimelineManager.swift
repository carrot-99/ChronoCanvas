//  TimelineManager.swift

import Foundation
import CoreData

class TimelineManager {
    private let dataManager: DataManager
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
    }

    // 新しいTimelineを作成
    func createTimeline(name: String) -> Timeline {
        let timeline = Timeline(context: dataManager.context)
        timeline.name = name
        dataManager.saveContext()
        return timeline
    }

    // すべてのTimelineを取得
    func fetchTimelines() -> [Timeline] {
        let request: NSFetchRequest<Timeline> = Timeline.fetchRequest()
        do {
            return try dataManager.context.fetch(request)
        } catch {
            print("Error fetching timelines: \(error)")
            return []
        }
    }

    // Timelineを削除
    func deleteTimeline(_ timeline: Timeline) {
        dataManager.context.delete(timeline)
        dataManager.saveContext()
    }
}
