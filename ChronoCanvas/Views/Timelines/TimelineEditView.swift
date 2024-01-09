// TimelineEditView.swift

import SwiftUI

struct TimelineEditView: View {
    @ObservedObject var timeline: Timeline
    @State private var newName: String = ""
    @Binding var isPresented: Timeline?
    var onSaved: () -> Void

    var body: some View {
        Form {
            Section(header: Text("名前を編集")) {
                TextField("タイトル", text: $newName, onCommit: saveName)
            }
            Section {
                Button("保存") {
                    saveName()
                    self.isPresented = nil
                    self.onSaved()
                }
            }
        }
        .onAppear {
            self.newName = timeline.name ?? ""
        }
    }
    
    private func saveName() {
        timeline.name = newName.isEmpty ? "タイムライン名未設定" : newName
        DataManager.shared.saveContext()
    }
}
