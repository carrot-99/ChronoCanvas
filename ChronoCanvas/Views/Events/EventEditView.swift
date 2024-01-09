// EventEditView.swift

import SwiftUI

struct EventEditView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var event: Event?
    @Binding var isPresented: Bool
    var onSave: (Event) -> Void
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isAllDay: Bool = false
    @State private var details: String = ""
    @State private var selectedColorCode: String = "#FFFFFF"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("イベント情報")) {
                    TextField("タイトル", text: $title)
                    
                    Toggle("終日", isOn: $isAllDay)

                    DatePicker("開始日", selection: $startDate, displayedComponents: .date)
                    if !isAllDay {
                        DatePicker("開始時間", selection: $startDate, displayedComponents: .hourAndMinute)
                    }
                    DatePicker("終了日", selection: $endDate, displayedComponents: .date)
                    if !isAllDay {
                        DatePicker("終了時間", selection: $endDate, displayedComponents: .hourAndMinute)
                    }
                    
                    TextField("メモ", text: $details)
                }
                
                Section(header: Text("色選択")) {
                    ColorPickerView(selectedColorCode: $selectedColorCode)
                }
                
                if startDate <= endDate {
                    Section {
                        Button("保存") {
                            if let existingEvent = event {
                                // 既存のイベントを更新
                                existingEvent.title = title
                                existingEvent.startDate = startDate
                                existingEvent.endDate = endDate
                                existingEvent.isAllDay = isAllDay
                                existingEvent.details = details
                                existingEvent.colorCode = selectedColorCode
                                onSave(existingEvent)
                            } else {
                                // 新しいイベントを作成
                                let newEvent = Event(context: context)
                                newEvent.title = title
                                newEvent.startDate = startDate
                                newEvent.endDate = endDate
                                newEvent.isAllDay = isAllDay
                                newEvent.details = details
                                newEvent.colorCode = selectedColorCode
                                onSave(newEvent)
                            }
                            isPresented = false
                        }
                    }
                } else {
                    Text("日時が不正です。")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle(event == nil ? "イベントを追加" : "イベントを編集", displayMode: .inline)
            .onAppear {
                if let event = event {
                    title = event.title ?? ""
                    startDate = event.startDate ?? Date()
                    endDate = event.endDate ?? Date()
                    isAllDay = event.isAllDay
                    details = event.details ?? ""
                    selectedColorCode = event.colorCode ?? "#FFFFFF"
                }
            }
        }
    }
}
