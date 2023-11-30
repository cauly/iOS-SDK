//
//  ViewController.h
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/02/01.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;
@import GoogleMobileAdsMediationTestSuite;
#import "ExampleNativeAdView.h"


@interface ViewController : UIViewController <GADBannerViewDelegate, GADFullScreenContentDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate>

@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *nativeAdPlaceholder;
@property (strong, nonatomic) GADInterstitialAd *interstitialAd;
@property (strong, nonatomic) GADRewardedAd *rewardedAd;
@property (strong, nonatomic) GADAdLoader *adLoader;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

- (IBAction)bannerAdRequest:(id)sender;
- (IBAction)interstitialAdRequest:(id)sender;
- (IBAction)nativeAdRequest:(id)sender;
- (IBAction)rewardedAdRequest:(id)sender;

@end

