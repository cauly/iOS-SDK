//
//  FirstViewController.swift
//  CaulySample
//
//  Created by Macbook pro on 30/11/2019.
//  Copyright © 2019 cauly. All rights reserved.
//  by Sam.Kim

import UIKit
import AppTrackingTransparency

class FirstViewController: UIViewController, CaulyAdViewDelegate {
    var caulyView:CaulyAdView? = nil
    var bannerView:UIView?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:       // 승인
                        print("Authorized")
                        self.initCauly()
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
    }

    func initCauly() {
        // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global();
        CaulyAdSetting.setLogLevel(CaulyLogLevelDebug)  //  Cauly Log 레벨
        caulySetting?.appId = "1234567"                 //  App Store 에 등록된 App ID 정보 (필수)
        caulySetting?.appCode = "Cauly"                 //  Cauly AppCode
        
        caulySetting?.closeOnLanding = true             //  app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 false입니다.
        
        caulyView=CaulyAdView.init()
        caulyView?.delegate = self                      //  delegate 설정

        let frame = CGRect.init(x: 0, y: view.bounds.height - (85 + (tabBarController?.tabBar.frame.size.height ?? 40)), width: view.frame.width, height: 100)
        caulyView?.bounds = frame
        caulyView?.startBannerAdRequest()               //  배너광고요청
    }
    
    //광고 정보 수신 성공
    func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
        print("Loaded didReceiveAd callback")
        adView?.show(withParentViewController: self, target: self.view)
        
    }
    
    //광고 정보 수신 실패
    func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!) {
         print("didFailToReceiveAd: \(errorCode)(\(errorMsg!))");
    }
    
    // 랜딩 화면 표시
    func willShowLanding(_ adView: CaulyAdView!) {
        print("willShowLanding")
    }
    
    // 랜딩 화면이 닫혔을 때
    func didCloseLanding(_ adView: CaulyAdView!) {
        print("didCloseLanding")
    }
}
