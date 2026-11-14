//  EventFormView.swift

import SwiftUI

/// イベントの作成・編集フォーム
struct EventFormView: View {
    enum Mode: Identifiable {
        case create(day: Date, timeline: Timeline?)
        case edit(Event)

        var id: String {
            switch self {
            case .create(let day, _): return "create-\(day.timeIntervalSinceReferenceDate)"
            case .edit(let event): return event.objectID.uriRepresentation().absoluteString
            }
        }
    }

    let mode: Mode
    /// タイムラインを選択可能にするか（総合画面からの作成・編集で使う）
    let timelines: [Timeline]

    @Environment(\.dismiss) private var dismiss
    @State private var draft: EventDraft
    @State private var showingDeleteConfirmation = false
    private let eventManager: EventManager

    init(mode: Mode, timelines: [Timeline] = [], eventManager: EventManager = EventManager()) {
        self.mode = mode
        self.timelines = timelines
        self.eventManager = eventManager
        switch mode {
        case .create(let day, let timeline):
            _draft = State(initialValue: EventDraft(on: day, timeline: timeline ?? timelines.first))
        case .edit(let event):
            _draft = State(initialValue: EventDraft(event: event))
        }
    }

    private var editingEvent: Event? {
        if case .edit(let event) = mode { return event }
        return nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("タイトル", text: $draft.title)
                        .font(.headline)
                    if timelines.count > 1 || draft.timeline == nil {
                        Picker("年表", selection: $draft.timeline) {
                            ForEach(timelines, id: \.objectID) { timeline in
                                Text(timeline.displayName).tag(Optional(timeline))
                            }
                        }
                    }
                }

                Section {
                    Toggle("終日", isOn: $draft.isAllDay.animation())
                    DatePicker("開始", selection: $draft.startDate, displayedComponents: dateComponents)
                    DatePicker("終了", selection: $draft.endDate, displayedComponents: dateComponents)
                    if !draft.isDateRangeValid {
                        Label("終了日時は開始日時より後にしてください", systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }

                Section("色") {
                    ColorPickerView(selectedColorCode: $draft.colorCode)
                }

                Section("メモ") {
                    TextEditor(text: $draft.details)
                        .frame(minHeight: 80)
                }

                if editingEvent != nil {
                    Section {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            Label("イベントを削除", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(editingEvent == nil ? "新規イベント" : "イベントを編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingEvent == nil ? "追加" : "保存", action: save)
                        .disabled(!draft.isValid)
                }
            }
            .onChange(of: draft.startDate) { [oldStart = draft.startDate] newStart in
                // 開始を動かしたら、期間を保ったまま終了も追従させる
                let duration = draft.endDate.timeIntervalSince(oldStart)
                if draft.endDate < newStart || duration >= 0 {
                    draft.endDate = newStart.addingTimeInterval(max(duration, 0))
                }
            }
            .confirmationDialog("このイベントを削除しますか？", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("削除", role: .destructive, action: delete)
            }
        }
    }

    private var dateComponents: DatePickerComponents {
        draft.isAllDay ? [.date] : [.date, .hourAndMinute]
    }

    private func save() {
        if let event = editingEvent {
            eventManager.updateEvent(event, with: draft)
        } else {
            eventManager.createEvent(from: draft)
        }
        dismiss()
    }

    private func delete() {
        if let event = editingEvent {
            eventManager.deleteEvent(event)
        }
        dismiss()
    }
}
