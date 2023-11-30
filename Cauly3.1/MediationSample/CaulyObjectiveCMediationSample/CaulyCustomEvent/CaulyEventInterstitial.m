//
//  CaulyEventInterstitial.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import "CaulyEventInterstitial.h"

@implementation CaulyEventInterstitial

#pragma mark - Interstitial Ad Request
- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(_Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            // Call original handler and hold on to its return value.
            delegate = originalCompletionHandler(ad, error);
        }
        
        // Release reference to handler. Objects retained by the handler will also be released.
        originalCompletionHandler = nil;
        
        return delegate;
    };
    
    // admob 대시보드 등록 parameter : cauly appCode
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    
    // 카울리 로그 레벨
    [CaulyAdSetting setLogLevel:CaulyLogLevelTrace];
    
    // iTunes App ID
    adSetting.appId = @"0";
    
    // 카울리 앱 코드
    adSetting.appCode = adUnit;
    
    // 광고 랜딩 시 WebView 제거 여부
    adSetting.closeOnLanding = YES;
    
    _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:[adConfiguration topViewController]];
    _interstitialAd.delegate = self;
    
    // 카울리 전면 광고 요청
    [_interstitialAd startInterstitialAdRequest];
}

#pragma mark - GADMediationInterstitialAd implementation

- (void)presentFromViewController:(UIViewController *)viewController {
    [_interstitialAd showWithParentViewController:viewController];
}

#pragma mark - CaulyInterstitialAdDelegate

// 전면 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"cauly interstitial ad Show");
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

// 전면 광고 닫음
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"did Close Interstitial ad");
    _interstitialAd = nil;
}

// 전면 광고 표시
- (void) willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"will Show Interstitial ad");
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate reportImpression];
}

// 전면 광고 정보 수신 실패
- (void) didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    _interstitialAd = nil;
    NSLog(@"fail interstitial ad");
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

@end
