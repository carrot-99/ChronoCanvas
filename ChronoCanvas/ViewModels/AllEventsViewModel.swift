//  AllEventsViewModel.swift

import Foundation

class AllEventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var timelineListViewModel: TimelineListViewModel
    private let eventManager: EventManager

    init(timelineListViewModel: TimelineListViewModel, eventManager: EventManager = EventManager()) {
        self.timelineListViewModel = timelineListViewModel
        self.eventManager = eventManager
        loadAllEvents()
    }
    
    func loadAllEvents() {
        let allTimelines = timelineListViewModel.timelines
        var allEvents = [Event]()
        for timeline in allTimelines {
            let events = eventManager.fetchEvents(for: timeline)
            allEvents.append(contentsOf: events)
        }
        self.events = allEvents
    }
}
