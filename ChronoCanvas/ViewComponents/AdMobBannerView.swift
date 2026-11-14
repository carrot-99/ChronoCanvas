//  AdMobBannerView.swift

import GoogleMobileAds
import SwiftUI

/// 画面幅に合わせたアダプティブバナー。広告ユニットIDが未設定の場合は何も表示しない
struct AdMobBannerView: View {
    private let adUnitID = Bundle.main.infoDictionary?["AdBannerUnitID"] as? String

    var body: some View {
        if let adUnitID, !adUnitID.isEmpty {
            GeometryReader { geometry in
                BannerRepresentable(adUnitID: adUnitID, width: geometry.size.width)
            }
            .frame(height: 50)
        }
    }
}

private struct BannerRepresentable: UIViewRepresentable {
    let adUnitID: String
    let width: CGFloat

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))
        banner.adUnitID = adUnitID

        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive } ?? UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = scene?.windows.first { $0.isKeyWindow }?.rootViewController

        let request = GADRequest()
        request.scene = scene
        banner.load(request)
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
