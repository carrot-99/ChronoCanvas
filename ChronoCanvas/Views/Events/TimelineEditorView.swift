//  TimelineEditorView.swift

import SwiftUI

struct TimelineEditorView: View {
    @ObservedObject var viewModel: TimelineEditorViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State private var showingList = false
    @State private var showingAddEventView = false
    @State private var selectedDate = Date()
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    
    private var sortedEvents: [Event] {
        viewModel.events.sorted { (event1, event2) in
            (event1.startDate ?? Date()) < (event2.startDate ?? Date())
        }
    }
    
    private var sortedEventsForSelectedDate: [Event] {
        sortedEvents.filter { isSameDay($0.startDate, selectedDate) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CustomCalendarView(viewModel: calendarViewModel)
                    .frame(height: (geometry.size.height - 55) * 2 / 3)
                    .onChange(of: calendarViewModel.selectedDate) { newDate in
                        self.selectedDate = newDate
                    }
                    .onAppear {
                        calendarViewModel.loadEvents(for: viewModel.events)
                    }

                EventListView(viewModel: viewModel, events: sortedEventsForSelectedDate, selectedDate: selectedDate)
                    .frame(width: geometry.size.width - 10, height: (geometry.size.height - 55) * 1 / 3)
            }
            .navigationBarTitle(viewModel.timelineName.isEmpty ? "年表編集" : viewModel.timelineName, displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    // 更新ボタン
                    Button(action: {
                        updateViews()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    
                    // イベント追加ボタン
                    Button(action: {
                        updateStartAndEndDates()
                        showingAddEventView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
            .sheet(isPresented: $showingAddEventView) {
                AddEventView(
                    viewModel: viewModel,
                    startDate: $startDate,
                    endDate: $endDate,
                    showingAddEventView: $showingAddEventView
                )
            }
        }
    }
    
    private func updateViews() {
        calendarViewModel.loadEvents(for: viewModel.events)
    }
    
    private func isSameDay(_ date1: Date?, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1 ?? Date(), inSameDayAs: date2)
    }
    
    private func updateStartAndEndDates() {
        let calendar = Calendar.current
        let now = Date()
        let selectedDayComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let currentTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
        startDate = calendar.date(from: DateComponents(year: selectedDayComponents.year,
                                                       month: selectedDayComponents.month,
                                                       day: selectedDayComponents.day,
                                                       hour: currentTimeComponents.hour,
                                                       minute: currentTimeComponents.minute,
                                                       second: currentTimeComponents.second)) ?? now
        endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) ?? now.addingTimeInterval(3600)
    }
}
