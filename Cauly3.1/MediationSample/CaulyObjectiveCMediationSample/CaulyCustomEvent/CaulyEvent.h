//
//  CaulyEvent.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyAdView.h"
@import GoogleMobileAds;

@interface CaulyEvent : NSObject <GADMediationAdapter> {
    CaulyAdView *adView;
}

@end

