//  EventListView.swift

import Foundation
import SwiftUI

struct EventListView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel: TimelineEditorViewModel
    var events: [Event]
    @State private var editingEvent: Event? = nil
    @State private var showingEditView = false
    var selectedDate: Date
    
    var body: some View {
        List {
            ForEach(viewModel.eventsOnDay(selectedDate), id: \.self) { event in
                VStack(alignment: .leading, spacing: 10) {
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
                    self.showingEditView = true
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteEvent)
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 5)
        .sheet(isPresented: $showingEditView) {
            EventEditView(event: $editingEvent, isPresented: $showingEditView, onSave: { updatedEvent in
                viewModel.updateEvent(updatedEvent)
            })
            .environment(\.managedObjectContext, context)
        }
    }
    
    private func deleteEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = events.sorted { $0.startDate ?? Date() < $1.startDate ?? Date() }[index]
            viewModel.deleteEvent(event)
        }
    }
}
