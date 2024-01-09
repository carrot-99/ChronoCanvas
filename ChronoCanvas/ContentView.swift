//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")
    
    var body: some View {
        if hasAgreedToTerms {
            NavigationView {
                MainView()
                    .overlay(
                        VStack {
                            Spacer()
                            AdMobBannerView()
                                .frame(width: UIScreen.main.bounds.width, height: 50)
                                .background(Color.gray.opacity(0.1))
                        },
                        alignment: .bottom
                    )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
        }
    }
}
