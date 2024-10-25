//
//  AppOpenAdManager.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/23.
//

import GoogleMobileAds

protocol AppOpenAdManagerDelegate: AnyObject {
    func appOpenAdDidLoad();
    func appOpenAdFailedToLoad(_ error: Error);
    func appOpenAdDidShow();
    func appOpenAdFailedToShow(_ error: Error);
}

class AppOpenAdManager: NSObject {
    /// Ad references in the app open beta will time out after four hours,
    /// but this time limit may change in future beta versions. For details, see:
    /// https://support.google.com/admob/answer/9341964?hl=en
    let timeoutInterval: TimeInterval = 4 * 3_600
    /// The app open ad.
    var appOpenAd: GADAppOpenAd?
    /// Maintains a reference to the delegate.
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
    /// Keeps track of if an app open ad is loading.
    var isLoadingAd = false
    /// Keeps track of if an app open ad is showing.
    var isShowingAd = false
    /// Keeps track of the time when an app open ad was loaded to discard expired ad.
    var loadTime: Date?
    
    static let shared = AppOpenAdManager()

    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }

    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }

    func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        print("Start loading app open ad.")
        
        GADAppOpenAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/5575463023",
            request: GADRequest()
        ) { ad, error in
            self.isLoadingAd = false
            if let error = error {
                self.appOpenAd = nil
                self.loadTime = nil
                print("App open ad failed to load with error: \(error).")
                self.appOpenAdManagerDelegate?.appOpenAdFailedToLoad(error)
                return
            }

            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            
            self.appOpenAdManagerDelegate?.appOpenAdDidLoad()
            print("App open ad loaded successfully.")
        }
    }

    func showAdIfAvailable() {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            print("App open ad is already showing.")
            return
        }
        // If the app open ad is not available yet but it is supposed to show,
        // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
        // method and load a new ad.
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            loadAd()
            return
        }
        if let ad = appOpenAd {
            print("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: nil)
        }
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad is will be presented.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        loadAd()
        appOpenAdManagerDelegate?.appOpenAdDidShow()
    }

    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error).")
        loadAd()
        appOpenAdManagerDelegate?.appOpenAdFailedToShow(error)
    }
}
