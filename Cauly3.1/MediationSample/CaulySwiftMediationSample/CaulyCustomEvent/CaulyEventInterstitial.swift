//
//  CaulyEventInterstitial.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/24.
//

import Foundation
import GoogleMobileAds

class CaulyEventInterstitial: NSObject, GADMediationInterstitialAd, CaulyInterstitialAdDelegate {
    /// The Cauly Ad Network interstitial.
    var interstitial: CaulyInterstitialAd?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationInterstitialAdEventDelegate?
    
    var completionHandler: GADMediationInterstitialLoadCompletionHandler?
    
    func loadInterstitial( for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelTrace)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        caulySetting?.closeOnLanding = true             // App 으로 이동할 때 webview popup 창을 자동으로 닫아줍니다. 기본값을 false
        
        self.interstitial = CaulyInterstitialAd.init(parentViewController: adConfiguration.topViewController)
        self.interstitial?.delegate = self;              // 전면 delegate 설정
        self.completionHandler = completionHandler
        self.interstitial?.startRequest()                // 전면광고 요청
    }
    
    // MARK: - GADMediationInterstitialAd implementation
    required override init() {
        super.init()
    }
    
    func present(from viewController: UIViewController) {
        if interstitial != nil {
            interstitial?.show(withParentViewController: viewController)
        }
    }
    
    // MARK: - CaulyInterstitialAdDelegate
    // 광고 정보 수신 성공
    func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
        print("didReceiveInterstitialAd")
        interstitial = interstitialAd
        
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    // Interstitial 형태의 광고가 닫혔을 때
    func didClose(_ interstitialAd: CaulyInterstitialAd!) {
        print("didCloseInterstitialAd")
    }
    
    // Interstitial 형태의 광고가 보여지기 직전
    func willShow(_ interstitialAd: CaulyInterstitialAd!) {
        print("willShowInterstitialAd")
    }
    
    // 광고 정보 수신 실패
    func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
        print("Receive fail interstitial errorCode:\(errorCode)(\(errorMsg!)")
        
        interstitial = nil
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
}
