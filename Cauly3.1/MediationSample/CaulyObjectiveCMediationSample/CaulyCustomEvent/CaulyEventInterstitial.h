//
//  CaulyEventInterstitial.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyInterstitialAd.h"
@import GoogleMobileAds;


@interface CaulyEventInterstitial : NSObject <CaulyInterstitialAdDelegate, GADMediationInterstitialAd> {
    CaulyInterstitialAd *_interstitialAd;
    
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationInterstitialLoadCompletionHandler _loadCompletionHandler;
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id<GADMediationInterstitialAdEventDelegate> _adEventDelegate;
}

- (void)loadInterstitialForAdConfiguration:
            (GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:
                             (GADMediationInterstitialLoadCompletionHandler)completionHandler;
@end
