//
//  AppOpenAdManager.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 10/16/24.
//

#import "AppOpenAdManager.h"

static NSTimeInterval const fourHoursInSeconds = 3600 * 4;

@interface AppOpenAdManager()
/// The app open ad.
@property(nonatomic, strong) GADAppOpenAd *appOpenAd;
/// Keeps track of if an app open ad is loading.
@property(nonatomic, assign) BOOL isLoadingAd;
/// Keeps track of if an app open ad is showing.
@property(nonatomic, assign) BOOL isShowingAd;
/// Keeps track of the time when an app open ad was loaded to discard expired ad.
@property(weak, nonatomic) NSDate *loadTime;

@end

@implementation AppOpenAdManager

+ (nonnull AppOpenAdManager *)sharedInstance {
    static AppOpenAdManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppOpenAdManager alloc] init];
    });
    
    return instance;
}

- (void)loadAd {
    // Do not load ad if there is an unused ad or one is already loading.
    if (self.isLoadingAd || [self isAdAvailable]) {
        return;
    }
    
    self.isLoadingAd = YES;

    // admob test unit ID 입니다.
    // 배포시 애드몹에서 발급한 unit ID 로 반드시 변경해야합니다.
    [GADAppOpenAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/5575463023"
            request:[GADRequest request]
            completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                self.isLoadingAd = NO;
                if (error) {
                    NSLog(@"Failed to load app open ad: %@", error);
                    [self.delegate appOpenAdFailedToLoad:error];
                    return;
                }
                self.appOpenAd = appOpenAd;
                self.appOpenAd.fullScreenContentDelegate = self;
                self.loadTime = [NSDate date];
        
                [self.delegate appOpenAdDidLoad];
            }];
}

- (void)showAdIfAvailable {
    // If the app open ad is already showing, do not show the ad again.
    if (self.isShowingAd) {
        return;
    }

    // If the app open ad is not available yet but is supposed to show, load a
    // new ad.
    if (![self isAdAvailable]) {
        [self loadAd];
        return;
    }

    self.isShowingAd = YES;
    [self.appOpenAd presentFromRootViewController:nil];
}

- (BOOL)isAdAvailable {
    // Check if ad exists and can be shown.
    return self.appOpenAd != nil && [self wasLoadTimeLessThanHoursAgo];
}

- (BOOL)wasLoadTimeLessThanHoursAgo {
    // Check if ad was loaded more than n hours ago.
    return [[NSDate date] timeIntervalSinceDate:self.loadTime] < fourHoursInSeconds;
}


#pragma mark - GADFullScreenContentDelegate methods

- (void)adWillPresentFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"App open ad is will be presented.");
}

- (void)adDidDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    self.appOpenAd = nil;
    self.isShowingAd = NO;
    // Reload an ad.
    [self loadAd];
    [self.delegate appOpenAdDidShow];
}

- (void)ad:(id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    self.appOpenAd = nil;
    self.isShowingAd = NO;
    // Reload an ad.
    [self loadAd];
    [self.delegate appOpenAdFailedToShow:error];
}

@end
