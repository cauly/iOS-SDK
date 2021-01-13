#import "SampleCustomEventBanner.h"

#import <Foundation/Foundation.h>
#import <SampleAdSDK/SampleAdSDK.h>


/// Constant for Sample Ad Network custom event error domain.
static NSString *const customEventErrorDomain = @"com.google.CustomEvent";

@interface SampleCustomEventBanner () <SampleBannerAdDelegate>

/// The Sample Ad Network banner.
@property(nonatomic, strong) SampleBanner *bannerAd;

@end

@implementation SampleCustomEventBanner

@synthesize delegate;

#pragma mark GADCustomEventBanner implementation
                                                                      
- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request {
    NSLog(@"=============cauly admob requestBannerAd===================");
 
   
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelAll];              //  Cauly Log 레벨
    adSetting.appCode               = @"cauly";                 //  Cauly AppCode
    adSetting.animType              = CaulyAnimNone;            //  화면 전환 효과

    
    adSetting.adSize                = CaulyAdSize_IPhone;       //  광고 크기
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        adSetting.adSize                = CaulyAdSize_IPadSmall;       //  광고 크기
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [_bannerViewHeightConstraint setConstant:50.0f];
    }
    
    
    adSetting.gender                = CaulyGender_All;          //  성별 설정
    adSetting.age                   = CaulyAge_All;             //  나이 설정
    adSetting.reloadTime            = CaulyAge_20;     // 광고 갱신 사용하지 않기
    adSetting.useDynamicReloadTime  = NO;                      //  동적 광고 갱신 허용 여부
    adSetting.closeOnLanding        = YES;                      // Landing 이동시 webview control lose 여부

    [self registerForKeyboardNotifications];

    
    _adView = [[CaulyAdView alloc] init];                                               // 배너 광고 객체 생성
    _adView.delegate = self;                                                            // 배너 광고 delegate 설정
    [_adView startBannerAdRequest];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"didReceiveAd");
    [adView showWithParentViewController:self target:self.view];
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

-(void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg{
    NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    [self.delegate customEventBanner:self didFailAd:errorMsg];
}
@end

