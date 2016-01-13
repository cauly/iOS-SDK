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
-(void) didMoveToParentViewController:(UIViewController *)parent{
    if( parent == nil){
        [_adView removeFromSuperview];
        _adView = nil;
    }
    [super didMoveToParentViewController:parent];
}


@end
