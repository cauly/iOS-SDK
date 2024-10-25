//
//  SplashViewController.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/23.
//

import UIKit
import UserMessagingPlatform
import GoogleMobileAds

class SplashViewController: UIViewController, AppOpenAdManagerDelegate {
    /// Number of seconds remaining to show the app open ad.
    /// This simulates the time needed to load the app.
    ///
    /// Use a boolean to initialize the Google Mobile Ads SDK and load ads once.
    private var isMobileAdsStartCalled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
        
        initializeUMP()
    }

    func initializeUMP() {
        let parameters = UMPRequestParameters()
        
        /*** UMP 테스트 모드 설정  **/
        let debugSettings = UMPDebugSettings()
        
        // 테스트 기기 설정
        debugSettings.testDeviceIdentifiers = [""]
        // EEA 지역 설정
        debugSettings.geography = .EEA
        parameters.debugSettings = debugSettings
        /*** UMP 테스트 모드 설정  **/
        
        // Request an update for the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: nil) { [weak self] requestConsentError in
            guard let self else { return }
            
            if let consentError = requestConsentError {
                // Consent gathering failed.
                return print("Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] loadAndPresentError in
                guard let self else { return }
                
                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                // Consent has been gahtered.
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        // Check if you can initialize the Google Mobile Ads SDK in parallel
        // while checking for new consent information. Consent obtained in
        // the previous session can be used to request ads.
        if UMPConsentInformation.sharedInstance.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            
            self.isMobileAdsStartCalled = true
            
            // Initialize the Google Mobile Ads SDK.
            GADMobileAds.sharedInstance().start { status in
                // Optional: Log each adapter's initialization latency.
                // 미디에이션 어댑터 연결 정보 확인
                let adapterStatuses = status.adapterStatusesByClassName
                for adapter in adapterStatuses {
                    let adapterStatus = adapter.value
                    NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key, adapterStatus.description, adapterStatus.latency)
                }
                
                // Start loading ads here ...
                AppOpenAdManager.shared.loadAd()
            }
        }
    }
    
    // 메인 화면으로 이동
    func startMainScreen() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MainStoryBoard")
        
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController = mainViewController
    }
    
    // MARK: AppOpenAdManagerDelegate
    
    // 앱 오프닝 광고 수신 성공
    func appOpenAdDidLoad() {
        print("appOpenAdDidLoad")
        AppOpenAdManager.shared.showAdIfAvailable()
    }
    
    // 앱 오프닝 광고 수신 실패
    func appOpenAdFailedToLoad(_ error: any Error) {
        print("appOpenAdFailedToLoad: \(error)");
        startMainScreen()
    }
    
    // 앱 오프닝 광고 노출 성공
    func appOpenAdDidShow() {
        print("appOpenAdDidShow")
        startMainScreen()
    }
    
    // 앱 오프닝 광고 노출 실패
    func appOpenAdFailedToShow(_ error: any Error) {
        print("appOpenAdFailedToShow: \(error)");
        startMainScreen()
    }
}
