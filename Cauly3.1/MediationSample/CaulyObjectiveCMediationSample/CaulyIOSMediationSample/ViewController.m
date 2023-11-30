//
//  ViewController.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/02/01.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Replace this ad unit ID with your own ad unit ID.
    // admob test unit ID 입니다.
    // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    // GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ GADSimulatorID ];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"ae081a94356e73cdaac17e213d2d613b" ];
}

#pragma mark - Rewarded Ad Request
// 리워드 광고 요청
- (IBAction)rewardedAdRequest:(id)sender {
    NSLog(@"##### rewardedAdRequest");
    GADRequest *request = [GADRequest request];
    // admob test unit ID 입니다.
    // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
    [GADRewardedAd
    loadWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"
            request:request
            completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            // 리워드 광고 요청 실패
            NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
            return;
        }
        self.rewardedAd = ad;

        NSLog(@"Rewarded ad loaded.");
        [self showRewardedAd];
    }];
}

// 리워드 광고 표시 및 리워드 이벤트 처리
- (void)showRewardedAd {
    NSLog(@"##### showRewardedAd");
    if (self.rewardedAd) {
        [self.rewardedAd presentFromRootViewController:self
                userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardedAd.adReward;
            // TODO: Reward the user!
            NSLog(@"reward the user");
        }];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

#pragma mark - Native Ad Request
// 네이티브 광고 요청
- (IBAction)nativeAdRequest:(id)sender {
    NSLog(@"##### nativeAdRequest");
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];

    // 광고 로더 초기화
    // admob test unit ID 입니다.
    // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/3986624511"
                                     rootViewController:self
                                                 adTypes:@[GADAdLoaderAdTypeNative]
                                                 options:@[videoOptions]];

    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)replaceNativeAdView:(UIView *)nativeAdView inPlaceholder:(UIView *)placeholder {
    // Remove anything currently in the placeholder.
    NSArray *currentSubviews = [placeholder.subviews copy];
    for (UIView *subview in currentSubviews) {
        [subview removeFromSuperview];
    }
    
    if (!nativeAdView) {
        return;
    }
    
    // Add new ad view and set constraints to fill its container.
    [placeholder addSubview:nativeAdView];
    [nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(nativeAdView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
}


#pragma mark - Interstitial Ad Request
// 전면 광고 요청
- (IBAction)interstitialAdRequest:(id)sender {
    NSLog(@"##### interstitialAdrequest");
    GADRequest *request = [GADRequest request];
    // admob test unit ID 입니다.
    // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"
                        request:request
                        completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            // 전면 광고 요청 실패
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitialAd = ad;
        self.interstitialAd.fullScreenContentDelegate = self;

        // 전면 광고 표시
        if (self.interstitialAd) {
            [self.interstitialAd presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    }];
}

#pragma mark - Banner Ad requset
// 배너 광고 요청
- (IBAction)bannerAdRequest:(id)sender {
    NSLog(@"##### bannerAdRequest");
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

#pragma mark - Admob Banner delegates
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
}

#pragma mark - Admob Interstitial delegates

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad will present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
}


#pragma mark - Admob Native delegates
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, nativeAd);
    
    // Create and place ad in view hierarchy.
    ExampleNativeAdView *nativeAdView =
        [[NSBundle mainBundle] loadNibNamed:@"ExampleNativeAdView" owner:nil options:nil]
            .firstObject;
    
    nativeAdView.nativeAd = nativeAd;
    UIView *placeholder = self.nativeAdPlaceholder;
    
    [self replaceNativeAdView:nativeAdView inPlaceholder:placeholder];
    
    nativeAdView.mediaView.contentMode = UIViewContentModeScaleAspectFit;
    nativeAdView.mediaView.hidden = NO;
    [nativeAdView.mediaView setMediaContent:nativeAd.mediaContent];
    // Populate the native ad view with the native ad assets.
    // Some assets are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // These assets are not guaranteed to be present, and should be checked first.
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;

    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;

    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;

}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    NSLog(@"adLoaderDidFinishLoading");
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"didFailToReceiveAdWithError");
}
@end
