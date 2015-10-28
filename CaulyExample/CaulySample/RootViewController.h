//
//  TestBannerViewController.h
//  CaulySample
//
//  Created by FutureStreamNetworks on 12. 3. 19..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaulyAdView.h"
#import "CaulyInterstitialAd.h"

@interface RootViewController : UIViewController<CaulyAdViewDelegate, CaulyInterstitialAdDelegate> {
	
	CaulyAdView * _adView;
	CaulyInterstitialAd * _interstitialAd;
	
	
}

- (IBAction)interstialAdButtonAction:(id)sender;

@end
