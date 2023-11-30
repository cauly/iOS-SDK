//
//  CaulyEventBanner.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/24.
//

import Foundation
import GoogleMobileAds
import UIKit

class CaulyEventBanner: NSObject, GADMediationBannerAd, CaulyAdViewDelegate {
    /// The Cauly Ad Network banner ad.
    var adView: CaulyAdView?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationBannerAdEventDelegate?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var completionHandler: GADMediationBannerLoadCompletionHandler?
    
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        // Create the bannerView with the appropriate size.
        let adSize = adConfiguration.adSize
        
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelTrace)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        caulySetting?.animType = CaulyAnimNone          // 화면 전환 효과
        caulySetting?.closeOnLanding = true             // App 으로 이동할 때 webview popup 창을 자동으로 닫아줍니다. 기본값을 false
        caulySetting?.useDynamicReloadTime = false
        
        adView = CaulyAdView.init()
        adView?.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height)
        adView?.bounds = frame
        
        self.completionHandler = completionHandler
        adView?.startBannerAdRequest()      // 배너 광고 요청
    }
    
    // MARK: - GADMediationBannerAd implementation
    var view: UIView {
        return adView ?? UIView()
    }
    
    required override init() {
        super.init()
    }
    
    // MARK: - CaulyAdViewDelegate
    // 광고 정보 수신 성공
    func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
        print("Loaded didReceiveAd callback")
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    // 광고 정보 수신 실패
    func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!) {
        print("didFailToReceiveAd: \(errorCode)(\(errorMsg!)")
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    // 랜딩 화면 표시
    func willShowLanding(_ adView: CaulyAdView!) {
        print("willShowLandingView")
        delegate?.reportClick()
    }
    
    // 랜딩 화면이 닫혔을 때
    func didCloseLanding(_ adView: CaulyAdView!) {
        print("didCloseLandingView")
    }
}
