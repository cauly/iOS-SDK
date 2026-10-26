//
//  CaulyAdView.h
//  Cauly
//
//  Created by Neil Kwon on 9/2/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CaulySDK/CaulyAdSetting.h>

@class CaulyAdView;

// Cauly 광고 이벤트 Delegate
@protocol CaulyAdViewDelegate <NSObject>

@optional

// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd;

// 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;

// 랜딩 화면 표시
- (void)willShowLandingView:(CaulyAdView *)adView;

// 랜딩 화면이 닫혔을 때
- (void)didCloseLandingView:(CaulyAdView *)adView;

/**
 * [CAULY-12464] 광고 노출이 서버에 집계되었을 때 호출된다(광고당 1회, 메인 스레드).
 *
 * 광고를 받은 시점(didReceiveAd)이 아니라, 광고가 실제로 화면에 보이는 것이
 * 확인되어 노출 집계(CaulyImpressInform)가 성공한 시점이다.
 * 집계에 실패하면 호출되지 않는다.
 *
 * 배너에만 해당한다. 안드로이드 CaulyAdViewListener.onAdImpression() 과 같은 콜백이다.
 */
- (void)didAdImpression:(CaulyAdView *)adView;

@end

@interface CaulyAdView : UIView

+ (id)caulyAdViewWithController:(UIViewController *)controller;

- (id)init;
- (id)initWithParentViewController:(UIViewController *)controller;

- (void)startBannerAdRequest;
- (void)stopAdRequest;

- (void)showWithParentViewController:(UIViewController *)controller target:(UIView*)target;

@property (nonatomic, weak) UIViewController * parentController;

@property (nonatomic, weak) id<CaulyAdViewDelegate> delegate;
@property (nonatomic, strong) CaulyAdSetting * localSetting;
@property (nonatomic, strong) NSObject * data;

@property (nonatomic, readonly) NSString * errorMsg;





@end
