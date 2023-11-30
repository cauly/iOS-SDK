//
//  CaulyEventNative.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyNativeAd.h"
@import GoogleMobileAds;


@interface CaulyEventNative : NSObject <CaulyNativeAdDelegate, GADMediationNativeAd> {
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationNativeLoadCompletionHandler _loadCompletionHandler;

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id<GADMediationNativeAdEventDelegate> _adEventDelegate;
    
    CaulyNativeAd *_nativeAd;
    
    NSDictionary *nativeAdItem;
    
    CaulyNativeAdItem *caulyNativeAdItem;
}

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler;

@end

