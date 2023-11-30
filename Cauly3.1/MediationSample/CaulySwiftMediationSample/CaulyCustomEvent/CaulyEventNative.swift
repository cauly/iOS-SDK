//
//  CaulyEventNative.swift
//  CaulySwiftMediationSample
//
//  Created by FSN on 2023/07/24.
//

import Foundation
import GoogleMobileAds

class CaulyEventNative: NSObject, GADMediationNativeAd, CaulyNativeAdDelegate {
    /// The Sample Ad Network native ad.
    var nativeAd: CaulyNativeAd?
    
    var nativeAdItem: Dictionary<String, Any>?
    
    var caulyNativeAdItem: CaulyNativeAdItem?
    
    var _mediaView: UIView?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationNativeAdEventDelegate?
    
    /// Completion handler called after ad load
    var completionHandler: GADMediationNativeLoadCompletionHandler?
    
    func loadNativeAd( for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelInfo)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        
        nativeAd = CaulyNativeAd.init(parentViewController: adConfiguration.topViewController)
        nativeAd?.delegate = self;
        self.completionHandler = completionHandler
        
        // 카울리 네이티브 광고 요청
        nativeAd?.startRequest(2, nativeAdComponentType: CaulyNativeAdComponentType_IconImage, imageSize: "720x480")
    }
    
    // MARK: - GADMediationNative
    required override init() {
        super.init()
    }
    
    var headline: String? {
        return nativeAdItem?["title"] as? String
    }
    
    var images: [GADNativeAdImage]?
    
    var body: String? {
        return nativeAdItem?["description"] as? String
    }
    
    var icon: GADNativeAdImage?
    
    var callToAction: String? {
        return ""
    }
    
    var starRating: NSDecimalNumber? {
        return nil
    }
    
    var store: String? {
        return ""
    }
    
    var price: String? {
        return ""
    }
    
    var advertiser: String? {
        return nativeAdItem?["subtitle"] as? String
    }
    
    var extraAssets: [String : Any]? {
        return nil
    }
    
    var adChoicesView: UIView?
    
    var mediaView: UIView? {
        return _mediaView
    }
    
    // MARK: - Cauly Native Delegate
    // 네이티브 광고 정보 수신 성공
    func didReceive(_ nativeAd: CaulyNativeAd!, isChargeableAd: Bool) {
        print("Cauly didReceiveNativeAd")
        caulyNativeAdItem = nativeAd.nativeAdItem(at: 0)
        
        do {
            nativeAdItem = try JSONSerialization.jsonObject(with: Data((caulyNativeAdItem?.nativeAdJSONString.utf8)!), options: []) as? Dictionary<String, Any>
        } catch {
            print(error.localizedDescription)
        }
        print(nativeAdItem as Any)
        self.nativeAd = nativeAd
        
        urlToImage()
    }
    
    func didFail(toReceive nativeAd: CaulyNativeAd!, errorCode: Int32, errorMsg: String!) {
        print("Cauly didFailToReceiveNativeAd errorCode: \(errorCode), errMsg: \(errorMsg ?? "No Message")")
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    func urlToImage() {
        let iconUrl = URL(string: nativeAdItem?["icon"] as! String)
        let mediaUrl = URL(string: nativeAdItem?["image"] as! String)
        
        DispatchQueue.global().async { [weak self] in
            if let iconData = try? Data(contentsOf: iconUrl!), let mediaData = try? Data(contentsOf: mediaUrl!) {
                if let iconImage = UIImage(data: iconData), let mediaImage = UIImage(data: mediaData) {
                    DispatchQueue.main.async {
                        self?.icon = GADNativeAdImage(image: iconImage)
                        self?._mediaView = UIImageView(image: mediaImage)
                        self?.images = [GADNativeAdImage(image: mediaImage)]
                        
                        if let handler = self?.completionHandler {
                            self?.delegate = handler(self, nil)
                        }
                    }
                }
            }
        }
    }
}
