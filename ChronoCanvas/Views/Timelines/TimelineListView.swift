//  TimelineListView.swift

import SwiftUI

struct TimelineListView: View {
    @ObservedObject var viewModel: TimelineListViewModel
    @Binding var sheet: TimelineSheet?

    @State private var timelinePendingDeletion: Timeline?

    var body: some View {
        List {
            Section {
                NavigationLink(destination: AllTimelinesView(listViewModel: viewModel)) {
                    rowLabel(
                        title: "総合",
                        subtitle: "すべての年表のイベント",
                        systemImage: "square.stack.3d.up.fill",
                        tint: .accentColor
                    )
                }
            }

            Section {
                if viewModel.timelines.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.timelines, id: \.objectID) { timeline in
                        NavigationLink(destination: TimelineEditorView(timeline: timeline)) {
                            rowLabel(
                                title: timeline.displayName,
                                subtitle: "\(timeline.eventCount)件のイベント",
                                systemImage: "calendar",
                                tint: .orange
                            )
                        }
                        .contextMenu {
                            Button {
                                sheet = .rename(timeline)
                            } label: {
                                Label("名前を変更", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                timelinePendingDeletion = timeline
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                timelinePendingDeletion = timeline
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                            Button {
                                sheet = .rename(timeline)
                            } label: {
                                Label("名前を変更", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            } header: {
                Text("年表")
            } footer: {
                if !viewModel.timelines.isEmpty {
                    Text("長押しまたは左にスワイプで名前の変更・削除ができます")
                }
            }
        }
        .listStyle(.insetGrouped)
        .confirmationDialog(
            "「\(timelinePendingDeletion?.displayName ?? "")」を削除しますか？",
            isPresented: Binding(get: { timelinePendingDeletion != nil }, set: { if !$0 { timelinePendingDeletion = nil } }),
            titleVisibility: .visible
        ) {
            Button("削除", role: .destructive) {
                if let timeline = timelinePendingDeletion {
                    viewModel.deleteTimeline(timeline)
                }
                timelinePendingDeletion = nil
            }
        } message: {
            Text("この年表に含まれる\(timelinePendingDeletion?.eventCount ?? 0)件のイベントも削除されます。この操作は取り消せません。")
        }
    }

    private func rowLabel(title: String, subtitle: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(tint))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
            Text("年表がまだありません")
                .font(.headline)
            Text("右上の＋ボタンから最初の年表を作成しましょう")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("年表を作成") { sheet = .create }
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

/// 年表一覧で表示するシート
enum TimelineSheet: Identifiable {
    case create
    case rename(Timeline)
    case settings

    var id: String {
        switch self {
        case .create: return "create"
        case .settings: return "settings"
        case .rename(let timeline): return "rename-\(timeline.objectID.uriRepresentation().absoluteString)"
        }
    }
}
