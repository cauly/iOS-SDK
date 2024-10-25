//
//  ViewController.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/21.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency


class ViewController: UIViewController, GADBannerViewDelegate, GADFullScreenContentDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate {

    @IBOutlet var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    private var adLoader: GADAdLoader?
    
    @IBOutlet var nativeAdPlaceholder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Replace this ad unit ID with your own ad unit ID.
        // admob test unit ID 입니다.
        // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        // admob test unit ID 입니다.
        // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        // Requests test ads on devices you specify. Your test device ID is printed to the console when an ad request is made.
        // GADBannerView automatically returns test ads when running on a simulator.
        // 앱을 출시하기 전에 테스트 설정 코드를 반드시 삭제해야 합니다.
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["2077ef9a63d2b398840261c8221a0c9b"]
    }
    
    // 광고 검사기 호출
    @IBAction func showAdInspector(_ sender: UIButton) {
        GADMobileAds.sharedInstance().presentAdInspector(from: self) { error in
            if error != nil {
                print("ad inspector error: \(String(describing: error))")
            }
        }
    }
    
    // 배너 광고 요청
    @IBAction func bannerAdRequest(_ sender: UIButton) {
        print("bannerAdRequest")
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
    }

    // MARK: - bannerDelegate
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
    
    // 전면 광고 요청
    @IBAction func interstitialAdRequest(_ sender: UIButton) {
        print("interstitialAdRequest")
        let request = GADRequest()
        // admob test unit ID 입니다.
        // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                            request: request,
                            completionHandler: { [self] ad, error in
                                if let error = error {
                                    // 전면 광고 요청 실패
                                    print("Failed to load interstitial ad with error: \(error)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                            }
        )
    }
    
    // 전면 광고 표시
    @IBAction func interstitialAdShow(_ sender: UIButton) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    
    // 리워드 광고 요청
    @IBAction func rewardAdRequest(_ sender: UIButton) {
        print("rewardAdRequest")
        let request = GADRequest()
        // admob test unit ID 입니다.
        // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                // 리워드 광고 요청 실패
                print("Failed to load rewarded ad with error: \(error)")
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    // 리워드 광고 표시 및 리워드 이벤트 처리
    @IBAction func rewardAdShow(_ sender: UIButton) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    // MARK: - interstitalDelegate
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content. error: \(error)")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    
    // 네이티브 광고 요청
    @IBAction func nativeAdRequest(_ sender: UIButton) {
        print("nativeAdRequest")
        // admob test unit ID 입니다.
        // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511",
                               rootViewController: self,
                               adTypes: [ .native],
                               options: nil)
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    // MARK: - GADNativeAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader,didReceive nativeAd: GADNativeAd) {
        // A native ad has loaded, and can be displayed.
        print("Received native ad: \(nativeAd)")
        
        // Create and place ad in view hierarchy.
        let nibView = Bundle.main.loadNibNamed("ExampleNativeAdView", owner: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else {
            return
        }
        
        setAdView(nativeAdView)
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            let heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint.isActive = true
        }
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
            from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        if let nativeView = nativeAd.extraAssets?["view"] as? UIView, let mediaAspectRatio = nativeAd.extraAssets?["mediaAspectRatio"] as? CGFloat {
            let screenMinWidth = min(nativeAdPlaceholder.bounds.width, nativeAdPlaceholder.bounds.height)
            let mediaHeight = screenMinWidth / mediaAspectRatio
            nativeView.frame = nativeAdPlaceholder.bounds.divided(atDistance: mediaHeight + 130 , from: .minYEdge).slice
            nativeView.contentMode = .scaleToFill
            nativeAdView.mediaView?.isHidden = true
            
            nativeAdPlaceholder.addSubview(nativeView)
        }
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }
    
    func setAdView(_ view: GADNativeAdView) {
        // Remove the previous ad view.
        nativeAdPlaceholder.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": view]
        self.view.addConstraints(
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[_nativeAdView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[_nativeAdView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
    
    /// Returns a `UIImage` representing the number of stars from the given star rating; returns `nil`
    /// if the star rating is less than 3.5 stars.
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader didFailToReceiveAdWithError \(error)")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        // The native ad shown.
        print("nativeAdDidRecordImpression")
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        // The native ad was clicked on.
        print("nativeAdDidRecordClick")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        // The native ad will present a full screen view.
        print("nativeAdWillPresentScreen")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad will dismiss a full screen view.
        print("nativeAdWillDismissScreen")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad did dismiss a full screen view.
        print("nativeAdDidDismissScreen")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        // The native ad will cause the app to become inactive and
        // open a new app.
        print("nativeAdWillLeaveApplication")
    }
    
}

