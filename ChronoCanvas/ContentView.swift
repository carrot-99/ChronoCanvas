//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @AppStorage("hasAgreedToTerms") private var hasAgreedToTerms = false

    var body: some View {
        if hasAgreedToTerms {
            NavigationView {
                MainView()
            }
            .navigationViewStyle(.stack)
            // 広告がリストの末尾を隠さないよう、セーフエリアとして確保する
            .safeAreaInset(edge: .bottom, spacing: 0) {
                AdMobBannerView()
                    .background(Color(.systemBackground))
            }
        } else {
            TermsAndPrivacyAgreementView {
                hasAgreedToTerms = true
            }
        }
    }
}
