//
//  ViewController.m
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 9/9/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import "ViewController.h"
#import "NativeAdViewViewController.h"
#import "TestBannerViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>


@interface ViewController (Private)
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    keyboardIsShown = NO;
    
    orientaionLock = NO;
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelDebug];            //  Cauly Log 레벨
    adSetting.appId                 = @"1234567";               //  App Store 에 등록된 App ID 정보 (필수)
    adSetting.appCode               = @"Cauly";                 //  Cauly AppCode
    
    adSetting.adSize                = CaulyAdSize_IPhone;       //  광고 크기
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        adSetting.adSize                = CaulyAdSize_IPadSmall;       //  광고 크기
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [_bannerViewHeightConstraint setConstant:50.0f];
    }
    
    adSetting.reloadTime            = CaulyReloadTime_30;       //  광고 갱신 시간
    adSetting.useDynamicReloadTime  = YES;                      //  동적 광고 갱신 허용 여부
    adSetting.closeOnLanding        = YES;                      //  Landing 이동시 webview control lose 여부
    
    
    _adView = [[CaulyAdView alloc] init];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [_scrollView addGestureRecognizer:singleTap];
    
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_8_4){
    }
    
    [self registerForKeyboardNotifications];
    
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                // 승인
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    break;
                // 거부
                case ATTrackingManagerAuthorizationStatusDenied:
                    break;
                // 제한
                case ATTrackingManagerAuthorizationStatusRestricted:
                    break;
                // 미결정
                default:
                    break;
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - CaulyAdViewDelegate
// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"didReceiveAd");
    [_adView showWithParentViewController:self target:_bannerView];
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

#pragma - CaulyInterstitialAd

// 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"didReceiveInterstitialAd");
    [_interstitialAd showWithParentViewController:self];
}

// Interstitial 형태의 광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"didCloseInterstitialAd");
    _interstitialAd = nil;
}

// Interstitial 형태의 광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"willShowInterstitialAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
}


#pragma - Native delegates

// 광고 정보 수신 성공
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"didReceiveNativeAd");
    CaulyNativeAdItem* caulyNativeAd = [nativeAd nativeAdItemAt:0];
    
    NSArray* allList= [nativeAd nativeAdItemList];
    NSLog(@"%@",caulyNativeAd);
    NSLog(@"%@",caulyNativeAd.nativeAdJSONString);
    
    for(CaulyNativeAdItem* adItem in allList){
        NSLog(@"%@",adItem.nativeAdJSONString);
    }
    
    NSError *error;
    NSDictionary *nativeAdItem = [NSJSONSerialization JSONObjectWithData:[caulyNativeAd.nativeAdJSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    
    
    //    NativeAdViewViewController
    
    NativeAdViewViewController *areaSelectView = [[NativeAdViewViewController alloc] initWithNibName:@"NativeAdViewViewController" bundle:nil];
    
    areaSelectView.nativeAd = nativeAd;
    
    //self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (@available(iOS 13.0, *)) {
       self.navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    } else {
       self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    //[self presentModalViewController:areaSelectView animated:NO];
    
    areaSelectView.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        areaSelectView.view.alpha = 1;
        
        NSURL *url = [NSURL URLWithString:nativeAdItem[@"icon"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *icon = [UIImage imageWithData:data];
        
        if(nativeAdItem[@"image"]){
            url = [NSURL URLWithString:nativeAdItem[@"image"]];
            data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [areaSelectView.image setImage:image];
        }
        
        [areaSelectView.icon setImage:icon];
        
        [areaSelectView.mainTitle setText:nativeAdItem[@"title"]];
        [areaSelectView.subTitle setText:nativeAdItem[@"subtitle"]];
        [areaSelectView.descriptionLabel setText:nativeAdItem[@"description"]];
        areaSelectView.link = nativeAdItem[@"link"];
        
        [areaSelectView.optOutButton setHidden:[nativeAdItem[@"opt"] isEqualToString:@"N"]];
        
        [areaSelectView.jsonStringTextView setText:caulyNativeAd.nativeAdJSONString];
    }];
    
}

// 광고 정보 수신 실패
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg{
    NSLog(@"didFailToReceiveNativeAd");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return orientaionLock;
}

- (BOOL)shouldAutorotate{
    return orientaionLock;
}

- (IBAction)orientationLockChanged:(id)sender {
    orientaionLock = !orientaionLock;
}

- (IBAction)bannerAdRequest:(id)sender {
    
    if (_adView) {
        [_adView removeFromSuperview];                                                  // 배너 광고 View 제거
        _adView = nil;                                                                  // 배너 광고 객체 제거
    }
    
    _adView = [[CaulyAdView alloc] init];                                               // 배너 광고 객체 생성
    _adView.delegate = self;                                                            // 배너 광고 delegate 설정
    [_adView startBannerAdRequest];                                                     // 배너 광고 요청
}

- (IBAction)interstitialAdRequest:(id)sender {
    
    if (_interstitialAd) {
        _interstitialAd = nil;                                                          // 전면 광고 객체 제거
    }
    
    _interstitialAd = [[CaulyInterstitialAd alloc] init];                               // 전면 광고 객체 생성
    _interstitialAd.delegate = self;                                                    // 전면 광고 delegate 설정
    [_interstitialAd startInterstitialAdRequest];                                       // 전면광고 요청
    
    
}

- (IBAction)nativeAdRequest:(id)sender {
    if(_nativeAd){
        [_nativeAd stopAdRequest];
        _nativeAd = nil;
    }
    
    _nativeAd = [[CaulyNativeAd alloc] initWithParentViewController:self];
    _nativeAd.delegate = self;
    
    // imageSize argument를 통해 다양한 사이즈를 사용하여 구성할 수 있습니다.
    // 첫번째 argument는 요청할 nativa 광고의 갯수 eg) 1- 한개, 2- 두개

//    [_nativeAd startNativeAdRequest:1 nativeAdComponentType:CaulyNativeAdComponentType_Icon imageSize:@"214x214"];
    [_nativeAd startNativeAdRequest:2 nativeAdComponentType:CaulyNativeAdComponentType_Image imageSize:@"480x720"];
//    [_nativeAd startNativeAdRequest:2 nativeAdComponentType:CaulyNativeAdComponentType_IconImage imageSize:@"480x720"];
    
    
}


- (IBAction)showIsolated:(id)sender {
    
    
    TestBannerViewController *areaSelectView = [[TestBannerViewController alloc] init];

    [self presentViewController:areaSelectView animated:YES completion:nil];
}



- (void)resignOnTap:(id)iSender {
    [currentResponder resignFirstResponder];
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

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, currentResponder.frame.origin) ) {
        
        CGRect scrollTo = currentResponder.frame;
        scrollTo = CGRectMake(scrollTo.origin.x, scrollTo.origin.y - 30, scrollTo.size.width, scrollTo.size.height);
        [self.scrollView scrollRectToVisible:scrollTo animated:NO];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
