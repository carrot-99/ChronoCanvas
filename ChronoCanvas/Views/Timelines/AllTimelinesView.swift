//  AllTimelinesView.swift

import SwiftUI

struct AllTimelinesView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel: TimelineListViewModel
    @StateObject var calendarViewModel = CalendarViewModel(selectedDate: Date(), events: [])
    @ObservedObject var allEventsViewModel: AllEventsViewModel
    @State private var selectedEvent: Event?
    @State private var editingEvent: Event? = nil
    @State private var showingDetailView = false
    
    // 選択された日付に関連するイベントをフィルタリングして返す
    private var eventsForSelectedDate: [Event] {
        let selectedDate = calendarViewModel.selectedDate
        return allEventsViewModel.events.filter { event in
            guard let startDate = event.startDate, let endDate = event.endDate else { return false }
            let startDay = Calendar.current.startOfDay(for: startDate)
            let endDay = Calendar.current.startOfDay(for: endDate)
            let day = Calendar.current.startOfDay(for: selectedDate)
            let range = startDay...endDay
            return range.contains(day)
        }.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CustomCalendarView(viewModel: calendarViewModel)
                    .frame(height: (geometry.size.height - 55) * 2 / 3)
                
                // 全てのタイムラインのイベントを表示するリスト
                List {
                    ForEach(eventsForSelectedDate, id: \.self) { event in
                        VStack(alignment: .leading) {
                            Text(
                                event.isAllDay ? "\(event.startDate ?? Date(), formatter: Formatter.monthDayFormatter)終日 - \(event.endDate ?? Date(), formatter: Formatter.monthDayFormatter)終日" : "\(event.startDate ?? Date(), formatter: Formatter.itemFormatter) - \(event.endDate ?? Date(), formatter: Formatter.itemFormatter)"
                            )
                                .font(.caption)
                            Text(event.title ?? "無題のイベント")
                                .font(.headline)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: event.colorCode ?? "#3F3FDD")))
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            self.editingEvent = event
                            self.showingDetailView = true
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .frame(width: geometry.size.width - 10, height: (geometry.size.height - 55) * 1 / 3)
            }
            .onAppear {
                allEventsViewModel.loadAllEvents()
                calendarViewModel.events = allEventsViewModel.events
            }
            .sheet(isPresented: $showingDetailView) {
                EventDetailView(event: $editingEvent, isPresented: $showingDetailView)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
