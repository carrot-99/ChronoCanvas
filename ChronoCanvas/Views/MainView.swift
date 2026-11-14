//  MainView.swift

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = TimelineListViewModel()
    @State private var sheet: TimelineSheet?

    var body: some View {
        TimelineListView(viewModel: viewModel, sheet: $sheet)
            .navigationTitle("ChronoCanvas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        sheet = .settings
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("設定")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheet = .create
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("年表を追加")
                }
            }
            .sheet(item: $sheet) { sheet in
                switch sheet {
                case .create:
                    TimelineEditView(timeline: nil) { viewModel.addTimeline(named: $0) }
                case .rename(let timeline):
                    TimelineEditView(timeline: timeline) { viewModel.rename(timeline, to: $0) }
                case .settings:
                    SettingsView()
                }
            }
    }
}
