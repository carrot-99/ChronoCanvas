//  AddEventView.swift

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: TimelineEditorViewModel
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var details: String = ""
    @State private var selectedColorCode: String = "#3F3FDD"
    @Binding var showingAddEventView: Bool
    
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
                        Button("イベントを追加") {
                                viewModel.addEvent(
                                    title: title,
                                    startDate: startDate,
                                    endDate: endDate,
                                    isAllDay: isAllDay,
                                    details: details,
                                    colorCode: selectedColorCode
                                )
                                showingAddEventView = false
                        }
                    }
                } else {
                    Text("日時が不正です。")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle("イベントを追加", displayMode: .inline)
        }
    }
}
