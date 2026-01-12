//
//  ViewController.swift
//  CaulySample
//
//  Created by FSN on 11/7/23.
//

import UIKit
import AppTrackingTransparency

class ViewController: UIViewController, CaulyAdViewDelegate, CaulyInterstitialAdDelegate, CaulyNativeAdDelegate {
    
    @IBOutlet var bannerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bannerViewHeightConstraint: NSLayoutConstraint!
    
    var orientaionLock: Bool = false
    var keyboardIsShown: Bool = false
    var currentResponder: UITextField?
    
    var adView: CaulyAdView?
    var interstitialAd: CaulyInterstitialAd?
    var nativeAd: CaulyNativeAd?
    var nativeAdItem: Dictionary<String, Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:       // 승인
                        print("Authorized")
                    case .denied:           // 거부
                        print("Denied")
                    case .notDetermined:        // 미결정
                        print("Not Determined")
                    case .restricted:           // 제한
                        print("Restricted")
                    @unknown default:           // 알려지지 않음
                        print("Unknow")
                    }
                })
            }
        }
        
        keyboardIsShown = false
        orientaionLock = false
        
        
        let adSetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelTrace)      //  Cauly Log 레벨
        adSetting?.appId = "1234567"                        //  App Store 에 등록된 App ID 정보 (필수)
        adSetting?.appCode = "Cauly"                        //  Cauly AppCode
        adSetting?.animType = CaulyAnimNone                 // 화면 전환 효과
        
        // iPhone 인 경우
        if UIDevice.current.userInterfaceIdiom == .phone {
            // 광고 View 크기
            adSetting?.adSize = CaulyAdSize_IPhone
            
            bannerViewHeightConstraint.constant = 50.0
        }
        
        // iPad 인 경우
        else {
            // 광고 View 크기
            adSetting?.adSize = CaulyAdSize_IPadSmall
        }
        
        
        adSetting?.reloadTime = CaulyReloadTime_30          // 광고 자동 갱신 시간 (기본값)
        adSetting?.useDynamicReloadTime = true;             // 광고 자동 갱신 사용 여부 (기본값)
        adSetting?.closeOnLanding = true;                   // 광고 랜딩 시 WebView 제거 여부
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CaulyAdViewDelegate
    // 배너 광고 정보 수신 성공
    func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
        NSLog("didReceiveAd")
        
        // 미디에이션일 경우에만 필요
        self.adView?.show(withParentViewController: self, target: bannerView)
    }
    
    // 배너 광고 정보 수신 실패
    func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!) {
        NSLog("didFailToReceiveAd : %d(%@)", errorCode, errorMsg)
    }
    
    // 배너 광고 랜딩 화면 표시
    func willShowLanding(_ adView: CaulyAdView!) {
        NSLog("willShowLandingView")
    }
    
    // 배너 광고 랜딩 화면 닫음
    func didCloseLanding(_ adView: CaulyAdView!) {
        NSLog("didCloseLandingView")
    }
    
    // MARK: - CaulyInterstitialAd
    // 전면 광고 정보 수신 성공
    func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
        NSLog("didReceiveInterstitialAd")
        self.interstitialAd?.show(withParentViewController: self)
    }
    
    // 전면 광고 정보 수신 실패
    func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
        NSLog("didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg)
    }
    
    // 전면 광고 표시
    func willShow(_ interstitialAd: CaulyInterstitialAd!) {
        NSLog("willShowInterstitialAd");
    }

    // 전면 광고 닫음
    func didClose(_ interstitialAd: CaulyInterstitialAd!) {
        NSLog("didCloseInterstitialAd")
        self.interstitialAd = nil;
    }
    
    // MARK: - Native delegates
    
    // 네이티브 광고 정보 수신 성공
    func didReceive(_ nativeAd: CaulyNativeAd!, isChargeableAd: Bool) {
        NSLog("didReceiveNativeAd")

        guard let caulyNativeAd = nativeAd.nativeAdItem(at: 0) else {
            NSLog("receive native ad no fill")
            return
        }

        // JSON parse
        do {
            nativeAdItem = try JSONSerialization.jsonObject(
                with: Data(caulyNativeAd.nativeAdJSONString.utf8),
                options: []
            ) as? [String: Any]
        } catch {
            NSLog("nativeAdItem parse error: %@", error.localizedDescription)
            nativeAdItem = nil
        }

        // NativeAdViewViewController
        let areaSelectView = NativeAdViewViewViewController(
            nibName: "NativeAdViewViewController",
            bundle: nil
        )
        areaSelectView.nativeAd = nativeAd

        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(areaSelectView, animated: false, completion: nil)

        areaSelectView.view.alpha = 0

        // ---- (1) 텍스트/옵션 UI 바인딩----
        areaSelectView.mainTitle.text = nativeAdItem?["title"] as? String
        areaSelectView.subTitle.text = nativeAdItem?["subtitle"] as? String
        areaSelectView.descriptionLabel.text = nativeAdItem?["description"] as? String
        areaSelectView.link = nativeAdItem?["link"] as? NSString
        areaSelectView.jsonStringTextView.text = caulyNativeAd.nativeAdJSONString

        if let opt = nativeAdItem?["opt"] as? String {
            areaSelectView.optOutButton.isHidden = (opt == "N")
        } else {
            areaSelectView.optOutButton.isHidden = true
        }

        // ---- (2) 이미지 URL 추출 ----
        let iconURLString = nativeAdItem?["icon"] as? String
        let imageURLString = nativeAdItem?["image"] as? String

        // ---- (3) 아이콘/메인 이미지 비동기 로드 후 UI 업데이트 ----
        let group = DispatchGroup()

        var loadedIcon: UIImage?
        var loadedImage: UIImage?

        group.enter()
        ImageLoader.shared.loadImage(from: iconURLString) { image in
            loadedIcon = image
            group.leave()
        }

        if imageURLString != nil {
            group.enter()
            ImageLoader.shared.loadImage(from: imageURLString) { image in
                loadedImage = image
                group.leave()
            }
        }

        group.notify(queue: .main) {
            // 이미지 반영
            areaSelectView.icon.image = loadedIcon
            areaSelectView.image.image = loadedImage

            UIView.animate(withDuration: 0.5) {
                areaSelectView.view.alpha = 1
            }
        }
    }
    

    // 네이티브 광고 정보 수신 실패
    func didFail(toReceive nativeAd: CaulyNativeAd!, errorCode: Int32, errorMsg: String!) {
        NSLog("didFailToReceiveNativeAd : %d(%@)", errorCode, errorMsg)
    }
    

    // 배너 광고 요청
    @IBAction func bannerAdRequest(_ sender: UIButton) {
        if (adView != nil) {
            adView!.removeFromSuperview()           // 배너 광고 View 제거
            adView = nil                            // 배너 광고 객체 제거
        }
        
        adView = CaulyAdView(parentViewController: self)        // 배너 광고 객체 생성
        adView!.delegate = self                                 // 배너 광고 delegate 설정
        bannerView.addSubview(adView!)                           // 배너 광고 View 추가
        adView!.startBannerAdRequest()                          // 배너 광고 요청
    }
    
    // 배너 광고 요청 (미디에이션 연동 사용)
    @IBAction func bannerAdRequest4Mediation(_ sender: UIButton) {
        NSLog("##### bannerAdRequest4Mediation")
        
        if (adView != nil) {
            adView!.removeFromSuperview()                                                 // 배너 광고 View 제거
            adView = nil                                                                  // 배너 광고 객체 제거
        }
        
        adView = CaulyAdView()                                               // 배너 광고 객체 생성
        adView!.delegate = self                                                            // 배너 광고 delegate 설정
        adView!.startBannerAdRequest()                                                     // 배너 광고 요청
    }
    
    // 전면 광고 요청
    @IBAction func interstitialAdRequest(_ sender: UIButton) {
        NSLog("##### interstitialAdRequest")
        
        if (interstitialAd != nil) {
            interstitialAd = nil                                                          // 전면 광고 객체 제거
        }

        interstitialAd = CaulyInterstitialAd(parentViewController: self)  // 전면 광고 객체 생성
        interstitialAd!.delegate = self                                                    // 전면 delegate 설정
        interstitialAd!.startRequest()                                      // 전면 광고 요청
    }
    
    // 전면 광고 요청 (미디에이션 연동 사용)
    @IBAction func interstitialAdRequest4Mediation(_ sender: UIButton) {
        NSLog("##### interstitialAdRequest4Mediation")
        
        if (interstitialAd != nil) {
            interstitialAd = nil                                                          // 전면 광고 객체 제거
        }
        
        interstitialAd = CaulyInterstitialAd()                               // 전면 광고 객체 생성
        interstitialAd!.delegate = self                                                    // 전면 광고 delegate 설정
        interstitialAd!.startRequest()                                       // 전면 광고 요청
    }
    
    // 네이티브 광고 요청
    @IBAction func nativeAdRequest(_ sender: UIButton) {
        NSLog("##### nativeAdRequest")
        
        if (nativeAd != nil) {
            nativeAd?.stopRequest()                                                      // 네이티브 광고 요청 중지
            nativeAd = nil                                                                // 네이티브 광고 객체 제거
        }
        
        nativeAd = CaulyNativeAd(parentViewController: self)              // 네이티브 광고 객체 생성
        nativeAd!.delegate = self                                                          // 네이티브 광고 delegate 설정
        
        // imageSize argument를 통해 다양한 사이즈를 사용하여 구성할 수 있습니다.
        // 첫번째 argument는 요청할 nativa 광고의 갯수 eg) 1- 한개, 2- 두개
        nativeAd!.startRequest(2, nativeAdComponentType: CaulyNativeAdComponentType_Image, imageSize: "720x480")
    }
    
    @IBAction func orientationLockChanged(_ sender: UISegmentedControl) {
        orientaionLock = !orientaionLock
    }
    
    @objc func resignOnTap(_ sender: Any) {
        currentResponder?.resignFirstResponder()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    final class ImageLoader {
        static let shared = ImageLoader()

        private let cache = NSCache<NSString, UIImage>()

        func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
            guard let urlString, let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            if let cached = cache.object(forKey: urlString as NSString) {
                completion(cached)
                return
            }

            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self?.cache.setObject(image, forKey: urlString as NSString)
                completion(image)
            }.resume()
        }
    }
}

