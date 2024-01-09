//  MainView.swift

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = TimelineListViewModel()
    @StateObject var calendarViewModel = CalendarViewModel(selectedDate: Date(), events: [])
    @State private var showingSettings = false

    var body: some View {
        TimelineListView(viewModel: viewModel, calendarViewModel: calendarViewModel, timelines: viewModel.timelines)
            .navigationBarItems(
                leading: Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                },
                trailing: Button(action: {
                    viewModel.addTimeline()
                }) {
                    Image(systemName: "plus")
                }
            )
            .fullScreenCover(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear {
                viewModel.loadTimelines()
            }
    }
}
