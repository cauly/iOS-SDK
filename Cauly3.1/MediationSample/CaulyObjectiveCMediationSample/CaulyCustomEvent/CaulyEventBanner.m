//
//  CaulyEventBanner.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

#import "CaulyEventBanner.h"

@implementation CaulyEventBanner

#pragma mark - Banner Ad Request
- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
        _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {

      id<GADMediationBannerAdEventDelegate> delegate = nil;
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
    
    // 광고 View 크기
    adSetting.adSize = CaulyAdSize_IPhone;
    
    // 화면 전환 효과
    adSetting.animType = CaulyAnimNone;
    
    // 광고 자동 갱신 시간 (기본값)
    adSetting.reloadTime = CaulyReloadTime_30;
    
    // 광고 자동 갱신 사용 여부 (기본값)
    adSetting.useDynamicReloadTime = YES;
    
    // 광고 랜딩 시 WebView 제거 여부
    adSetting.closeOnLanding = YES;
    
    UIViewController *controller = [adConfiguration topViewController];
    adView = [[CaulyAdView alloc] initWithParentViewController:controller];
    [controller.view addSubview:adView];
    
    adView.delegate = self;
    
    // 카울리 배너 광고 요청
    [adView startBannerAdRequest];
}

#pragma mark GADMediationBannerAd implementation

- (nonnull UIView *)view {
    return adView;
}

#pragma - CaulyAdViewDelegate
// 배너 광고 정보 수신 성공
-(void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"didReceiveAd");
    // admob에 광고 수신 성공 전달
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

// 배너 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    // admob에 광고 수신 실패 전달
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

@end
