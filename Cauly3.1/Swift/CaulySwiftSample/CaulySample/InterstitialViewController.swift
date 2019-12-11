//
//  SecondViewController.swift
//  CaulySample
//
//  Created by Macbook pro on 30/11/2019.
//  Copyright © 2019 cauly. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, CaulyInterstitialAdDelegate {

      override func viewDidLoad() {
            super.viewDidLoad()
        }

        var _interstitialAd:CaulyInterstitialAd? = nil
        
        func loadInterstitial() {
            self._interstitialAd = CaulyInterstitialAd.init(parentViewController: self);
            _interstitialAd?.delegate = self;    //  전면 delegate 설정
            _interstitialAd?.startRequest();     //  전면광고 요청
        }
        
        @IBAction func loadInterstitial(_ sender: Any) {
            loadInterstitial()
        }
        

        @IBAction func showInterstitial(_ sender: UIButton) {
            _interstitialAd?.show()
        }
        // 광고 정보 수신 성공
        func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
            NSLog("Recevie intersitial");
             _interstitialAd?.show()
        }

        func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
            print("Recevie fail intersitial errorCode:\(errorCode) errorMsg:\(errorMsg!)");
            _interstitialAd = nil
        }
        //Interstitial 형태의 광고가 보여지기 직전
        func willShow(_ interstitialAd: CaulyInterstitialAd!) {
            NSLog("willShow")
        }
        // Interstitial 형태의 광고가 닫혔을 때
        func didClose(_ interstitialAd: CaulyInterstitialAd!) {
            NSLog("didClose")
            _interstitialAd=nil
        }
    }
