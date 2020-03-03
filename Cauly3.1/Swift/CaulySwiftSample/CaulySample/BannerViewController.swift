//
//  FirstViewController.swift
//  CaulySample
//
//  Created by Macbook pro on 30/11/2019.
//  Copyright © 2019 cauly. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CaulyAdViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initCauly()
    }

    func initCauly() {
        // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global();
        CaulyAdSetting.setLogLevel(CaulyLogLevelDebug)  //  Cauly Log 레벨
        caulySetting?.appCode = "CAULY"               //  발급ID 입력
        caulySetting?.animType = CaulyAnimNone          //  화면 전환 효과
        
        caulySetting?.closeOnLanding=true               // app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 false입니다.
        let caulyView:CaulyAdView = CaulyAdView.init(parentViewController: self)
        caulyView.delegate = self                       //  delegate 설정

        let frame = CGRect.init(x: 0, y: view.bounds.height - (85 + (tabBarController?.tabBar.frame.size.height ?? 40)), width: view.frame.width, height: 100)
        caulyView.bounds = frame
        view.addSubview(caulyView)
        caulyView.startBannerAdRequest()                //배너광고요청
    }
    //광고 정보 수신 성공
    func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
        print("Loaded didReceiveAd callback")
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
