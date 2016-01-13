//
//  ViewController.h
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 9/9/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Cauly.h"
#import "CaulyAdView.h"
#import "CaulyInterstitialAd.h"
#import "CaulyNativeAd.h"



@interface ViewController : UIViewController<CaulyAdViewDelegate, CaulyNativeAdDelegate, CaulyInterstitialAdDelegate, UITextFieldDelegate>{
    
    BOOL orientaionLock;
    BOOL keyboardIsShown;
}

- (IBAction)orientationLockChanged:(id)sender;
- (IBAction)bannerAdRequest:(id)sender;
- (IBAction)interstitialAdRequest:(id)sender;
- (IBAction)nativeAdRequest:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) CaulyAdView * adView;
@property (strong, nonatomic) CaulyNativeAd * nativeAd;
@property (strong) CaulyInterstitialAd * interstitialAd;

@end


