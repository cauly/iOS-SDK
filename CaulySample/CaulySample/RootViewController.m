//
//  TestBannerViewController.m
//  CaulySample
//
//  Created by FutureStreamNetworks on 12. 3. 19..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    

	CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelRelease];              //  Cauly Log 레벨
  //  adSetting.appCode               = @"CAULY";                 //  Cauly AppCode
     adSetting.appCode               = @"ArdtT2FB";                 //  Cauly AppCode
    
	adSetting.animType              = CaulyAnimCurlUp;            //  화면 전환 효과
	adSetting.useGPSInfo            = NO;                       //  GPS 수집 허용여부
    adSetting.adSize                = CaulyAdSize_IPadLarge;    //  광고 크기
    adSetting.reloadTime            = CaulyReloadTime_30;       //  광고 갱신 시간
    adSetting.useDynamicReloadTime  = YES;                      //  동적 광고 갱신 허용 여부
    
    
    
    
    

	_adView = [[CaulyAdView alloc] initWithParentViewController:self];      //  CaulyAdView 객체 생성
	[self.view addSubview:_adView];
	_adView.delegate = self;                                                //  delegate 설정
    _adView.showPreExpandableAd = TRUE;
	[_adView startBannerAdRequest];                                         //  배너광고 요청
    
    
    _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:self];  //  전면광고 객체 생성
    _interstitialAd.delegate = self;                                                    //  전면 delegate 설정
    [_interstitialAd startInterstitialAdRequest];                                       //  전면광고 요청
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)dealloc {
	[_adView release];
	[super dealloc];
}

- (IBAction)interstialAdButtonAction:(id)sender {    
	if(_interstitialAd)
		return;
	
	_interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:self];  //  전면광고 객체 생성
	_interstitialAd.delegate = self;                                                    //  전면 delegate 설정
	[_interstitialAd startInterstitialAdRequest];                                       //  전면광고 요청

}


#pragma mark - CaulyAdViewDelegate

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

#pragma mark - CaulyInterstitialAdDelegate

// 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
	NSLog(@"didReceiveInterstitialAd");
	[_interstitialAd show];
	[_interstitialAd release];
	_interstitialAd = nil;
}

// Interstitial 형태의 광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"didCloseInterstitialAd");
	[_interstitialAd release];
	_interstitialAd = nil;
}

// Interstitial 형태의 광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"willShowInterstitialAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
	NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
	[_interstitialAd release];
	_interstitialAd = nil;
}

@end
