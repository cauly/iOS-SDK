//
//  AdFitEvent.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/28.
//


import Foundation
import GoogleMobileAds

class AdFitEvent: NSObject, GADMediationAdapter {
    
    fileprivate var nativeAd: AdFitEventNative?
    
    required override init() {
        super.init()
    }
    
    // MARK: - AdFit Native Ad Request
    func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        self.nativeAd = AdFitEventNative()
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
