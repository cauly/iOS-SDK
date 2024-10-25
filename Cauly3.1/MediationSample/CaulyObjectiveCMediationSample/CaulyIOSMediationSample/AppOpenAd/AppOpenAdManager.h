//
//  AppOpenAdManager.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 10/16/24.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppOpenAdManagerDelegate <NSObject>

- (void)appOpenAdDidLoad;
- (void)appOpenAdFailedToLoad:(NSError *)error;
- (void)appOpenAdDidShow;
- (void)appOpenAdFailedToShow:(NSError *)error;

@end

@interface AppOpenAdManager : NSObject <GADFullScreenContentDelegate>

@property (nonatomic, weak) id <AppOpenAdManagerDelegate> _Nullable delegate;

+ (nonnull AppOpenAdManager *)sharedInstance;
- (void)loadAd;
- (void)showAdIfAvailable;

@end

NS_ASSUME_NONNULL_END
