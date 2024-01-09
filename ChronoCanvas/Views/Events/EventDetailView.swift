// EventDetailView.swift

import SwiftUI

struct EventDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var event: Event?
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isAllDay: Bool = false
    @State private var details: String = ""
    @State private var colorCode: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("イベント情報")) {
                    Text("タイトル: \(title)")

                    if isAllDay {
                        // 終日の場合、日付をmonthDayFormatterに従って表示し、「終日」と加える
                        Text("開始日: \(Formatter.monthDayFormatter.string(from: startDate)) 終日")
                        Text("終了日: \(Formatter.monthDayFormatter.string(from: endDate)) 終日")
                    } else {
                        // 終日でない場合、日時をitemFormatterに従って表示する
                        Text("開始日時: \(Formatter.itemFormatter.string(from: startDate))")
                        Text("終了日時: \(Formatter.itemFormatter.string(from: endDate))")
                    }
                    
                    Text("メモ: \(details)")
//                    Text("色コード: \(colorCode)")
                }

                Section {
                    Button("閉じる") {
                        isPresented = false
                    }
                }
            }
            .navigationBarTitle("イベント詳細", displayMode: .inline)
            .onAppear {
                loadEventData()
            }
        }
    }

    private func loadEventData() {
        if let event = event {
            title = event.title ?? ""
            startDate = event.startDate ?? Date()
            endDate = event.endDate ?? Date()
            isAllDay = event.isAllDay
            details = event.details ?? ""
            colorCode = event.colorCode ?? ""
        }
    }
}
