//  ChronoCanvasApp.swift

import GoogleMobileAds
import SwiftUI

@main
struct ChronoCanvasApp: App {
    private let dataManager = DataManager.shared

    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataManager.context)
        }
    }
}
