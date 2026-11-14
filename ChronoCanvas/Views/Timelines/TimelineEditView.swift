// TimelineEditView.swift

import SwiftUI

/// 年表の作成・名前変更シート
struct TimelineEditView: View {
    /// nil の場合は新規作成
    let timeline: Timeline?
    var onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @FocusState private var isFocused: Bool

    init(timeline: Timeline?, onSave: @escaping (String) -> Void) {
        self.timeline = timeline
        self.onSave = onSave
        _name = State(initialValue: timeline?.name ?? "")
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("例：旅行の計画、歴史年表", text: $name)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit(save)
                } header: {
                    Text("年表の名前")
                }
            }
            .navigationTitle(timeline == nil ? "新しい年表" : "名前を変更")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(timeline == nil ? "作成" : "保存", action: save)
                        .disabled(trimmedName.isEmpty)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { isFocused = true }
            }
        }
    }

    private func save() {
        guard !trimmedName.isEmpty else { return }
        onSave(trimmedName)
        dismiss()
    }
}
