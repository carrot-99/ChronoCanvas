//  TermsAndPrivacyAgreementView.swift

import AppTrackingTransparency
import SwiftUI

/// 初回起動時の規約同意画面
struct TermsAndPrivacyAgreementView: View {
    var onAgree: () -> Void

    private enum Document: String, Identifiable {
        case terms, privacy
        var id: String { rawValue }
    }

    @State private var presentedDocument: Document?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(.accentColor)

            VStack(spacing: 8) {
                Text("ChronoCanvas へようこそ")
                    .font(.title2.bold())
                Text("年表ごとにイベントを整理し、カレンダーでまとめて振り返ることができます。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("本アプリでは、お客様の体験を向上させるために広告を表示します。ご利用の前に、以下の利用規約とプライバシーポリシーをご確認ください。")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    documentButton("利用規約", document: .terms)
                    documentButton("プライバシーポリシー", document: .privacy)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.secondarySystemBackground)))

            Spacer()

            Button {
                onAgree()
                requestTrackingPermission()
            } label: {
                Text("同意してはじめる")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .sheet(item: $presentedDocument) { document in
            NavigationView {
                Group {
                    switch document {
                    case .terms: TermsView()
                    case .privacy: PrivacyPolicyView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("閉じる") { presentedDocument = nil }
                    }
                }
            }
        }
    }

    private func documentButton(_ title: String, document: Document) -> some View {
        Button {
            presentedDocument = document
        } label: {
            Text(title)
                .font(.footnote.weight(.semibold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func requestTrackingPermission() {
        // 画面遷移直後はダイアログが表示されないことがあるため少し待つ
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
