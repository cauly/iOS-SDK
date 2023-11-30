//
//  AdFitEventNative.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/28.
//

import Foundation
import GoogleMobileAds
import AdFitSDK
import UIKit

class AdFitEventNative: NSObject, GADMediationNativeAd, AdFitNativeAdDelegate, AdFitNativeAdLoaderDelegate {
    /// The Sample Ad Network native ad.
    var nativeAd: AdFitNativeAd?
    
    var nativeAdLoader: AdFitNativeAdLoader?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationNativeAdEventDelegate?
    
    /// Completion handler called after ad load
    var completionHandler: GADMediationNativeLoadCompletionHandler?
    
    var nativeAdView: MyNativeAdView?
    
    func loadNativeAd( for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        self.completionHandler = completionHandler
        
        nativeAdLoader = AdFitNativeAdLoader(clientId: adUnit ?? "")
        nativeAdLoader?.delegate = self
        
        /**
         광고 뷰 내에서 정보 아이콘이 표시될 위치.
         이 아이콘을 표시하기 위해 별다른 처리는 필요하지 않으며, 지정된 위치에 자동으로 표시됩니다.
         기본값은 **topRight** (우측 상단) 입니다.
         
         ***topRight**(우측 상단), **topLeft**(좌측 상단), **bottomRight**(우측 하단), **bottomLeft**(좌측 하단)
         */
        nativeAdLoader?.infoIconPosition = .topRight
        nativeAdLoader?.loadAd()
    }
    
    // MARK: - GADMediationNative Mapping
    required override init() {
        super.init()
    }
    
    var headline: String? {
        return nil
    }
    
    var images: [GADNativeAdImage]?
    
    var body: String? {
        return nil
    }
    
    var icon: GADNativeAdImage?
    
    var callToAction: String? {
        return nil
    }
    
    var starRating: NSDecimalNumber? {
        return nil
    }
    
    var store: String? {
        return nil
    }
    
    var price: String? {
        return nil
    }
    
    var advertiser: String? {
        return nil
    }
    
    var extraAssets: [String : Any]? {
        return [
            "mediaAspectRatio" : nativeAd?.mediaAspectRatio as Any,
            "view" : nativeAdView as Any
        ]
    }
    
    var adChoicesView: UIView?
  
    var mediaView: UIView?
    
    
    // MARK: - AdFit NativeAdLoader Delegate
    func nativeAdLoaderDidReceiveAd(_ nativeAd: AdFitNativeAd) {
        let message = "delegate: nativeAdDidReceiveAd"
        print(message)
        
        if let nativeAdView = Bundle.main.loadNibNamed("MyNativeAdView", owner: nil, options: nil)?.first as? MyNativeAdView {
            self.nativeAd = nativeAd
            nativeAdView.backgroundColor = .white
            nativeAd.bind(nativeAdView)
            
            self.nativeAdView = nativeAdView
            
            mediaView = nativeAdView.adMediaView()
        }
        
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    func nativeAdLoaderDidFailToReceiveAd(_ nativeAdLoader: AdFitNativeAdLoader, error: Error) {
        let message = "delegate: nativeAdLoaderDidFailToReceiveAd, error: \(error.localizedDescription)"
        print(message)
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    func nativeAdDidClickAd(_ nativeAd: AdFitNativeAd) {
        let message = "delegate: nativeAdDidClickAd"
        print(message)
        
        delegate?.reportClick()
    }
    
}
