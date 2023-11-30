//
//  CaulyEventBanner.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyAdView.h"
@import GoogleMobileAds;


@interface CaulyEventBanner : NSObject <CaulyAdViewDelegate, GADMediationBannerAd> {
    CaulyAdView *adView;
    
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationBannerLoadCompletionHandler _loadCompletionHandler;

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id<GADMediationBannerAdEventDelegate> _adEventDelegate;
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler;


@end
