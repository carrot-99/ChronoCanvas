//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingRecord = false
    @State private var showingTerms = false
    @State private var showingPrivacyPolicy = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section() {                        
                        Button("利用規約") {
                            showingTerms = true
                        }
                        .sheet(isPresented: $showingTerms) {
                            TermsView()
                        }
                        
                        Button("プライバシーポリシー") {
                            showingPrivacyPolicy = true
                        }
                        .sheet(isPresented: $showingPrivacyPolicy) {
                            PrivacyPolicyView()
                        }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .shadow(radius: 2)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .navigationBarTitle("設定", displayMode: .inline)
                .navigationBarItems(trailing: Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}
