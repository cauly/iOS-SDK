//
//  CaulyEvent.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/24.
//

import Foundation
import GoogleMobileAds

class CaulyEvent: NSObject, GADMediationAdapter {
    
    fileprivate var bannerAd: CaulyEventBanner?
    
    fileprivate var interstitialAd: CaulyEventInterstitial?
    
    fileprivate var nativeAd: CaulyEventNative?
    
    required override init() {
        super.init()
    }
    
    // MARK: - Cauly Banner Ad Request
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        self.bannerAd = CaulyEventBanner()
        self.bannerAd?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }
    
    // MARK: - Cauly Interstitial Ad Request
    func loadInterstitial(for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        self.interstitialAd = CaulyEventInterstitial()
        self.interstitialAd?.loadInterstitial(for: adConfiguration, completionHandler: completionHandler)
    }
    
    // MARK: - Cauly Native Ad Request
    func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        self.nativeAd = CaulyEventNative()
        self.nativeAd?.loadNativeAd(for: adConfiguration, completionHandler: completionHandler)
    }

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        // This is where you will initialize the SDK that this custom event is built
        // for. Upon finishing the SDK initialization, call the completion handler
        // with success.
        completionHandler(nil)
    }

    static func adapterVersion() -> GADVersionNumber {
        let adapterVersion = "1.0.0.0"
        let versionComponents = adapterVersion.components(separatedBy: ".")
        var version = GADVersionNumber()
        if versionComponents.count == 4 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = (Int(versionComponents[2]) ?? 0) * 100 + (Int(versionComponents[3]) ?? 0)
        }
        return version
    }

    static func adSDKVersion() -> GADVersionNumber {
        let versionComponents = CAULY_SDK_VERSION.components(separatedBy: ".")
        
        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0
            
            return GADVersionNumber(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
        }
        
        return GADVersionNumber()
    }

    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
}
