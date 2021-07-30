//
//  TestBannerViewController.m
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 12/28/15.
//  Copyright © 2015 Cauly. All rights reserved.
//

#import "TestBannerViewController.h"

@interface TestBannerViewController ()

@end

@implementation TestBannerViewController


-(void)dealloc{
    NSLog(@"TestBannerView dealloc");
    
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelDebug];            //  Cauly Log 레벨
    adSetting.appId                 = @"1234567";               //  App Store 에 등록된 App ID 정보 (필수)
    adSetting.appCode               = @"Cauly";                 //  Cauly AppCode
    adSetting.animType              = CaulyAnimNone;            //  화면 전환 효과

    adSetting.adSize                = CaulyAdSize_IPhone;       //  광고 크기
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        adSetting.adSize                = CaulyAdSize_IPadSmall;       //  광고 크기
    }
        
    adSetting.reloadTime            = CaulyReloadTime_120;       //  광고 갱신 시간
    adSetting.useDynamicReloadTime  = YES;                       //  동적 광고 갱신 허용 여부
    adSetting.closeOnLanding        = YES;                       // Landing 이동시 webview control lose 여부
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [_bannerViewHeightConstraint setConstant:50.0f];
    }
    
    _adView = [[CaulyAdView alloc] initWithParentViewController:self];
    _adView.delegate = self;
    [_bannerView addSubview:_adView];
    [_adView startBannerAdRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - CaulyAdViewDelegate
// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"didReceiveAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
}

// 랜딩 화면 표시
- (void)willShowLandingView:(CaulyAdView *)adView {
    NSLog(@"willShowLandingView");
}

// 랜딩 화면이 닫혔을 때
- (void)didCloseLandingView:(CaulyAdView *)adView {
    NSLog(@"didCloseLandingView");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)dismiss:(id)sender {
    [_adView removeFromSuperview];
    _adView = nil;

    [self dismissViewControllerAnimated:NO completion:nil];

}


@end
