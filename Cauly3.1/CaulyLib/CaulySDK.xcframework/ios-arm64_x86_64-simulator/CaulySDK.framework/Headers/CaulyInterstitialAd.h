//
//  CaulyInterstitialAd.h
//  CaulySDK
//
//  Created by FSN on 10/23/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CaulySDK/Cauly.h>
#import <CaulySDK/CaulyAdSetting.h>

@class CaulyInterstitialAd;

// Cauly Interstitial 광고 이벤트 Delegate
@protocol CaulyInterstitialAdDelegate <NSObject>

@optional
// 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd;

// 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;

// Interstitial 형태의 광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd;

// Interstitial 형태의 광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd;

@end


@interface CaulyInterstitialAd : NSObject
+ (id)caulyAdWithController:(UIViewController *)controller;

- (id)init;
- (id)initWithParentViewController:(UIViewController *)controller;

- (int)earnType;
- (float)price;

- (void)startInterstitialAdRequest;
- (void)stopAdRequest;

- (void)show;
- (void)showWithParentViewController:(UIViewController *)controller;

- (void)close;

@property (nonatomic, weak) id<CaulyInterstitialAdDelegate> delegate;
@property (nonatomic, strong) CaulyAdSetting * localSetting;
@property (nonatomic, weak) UIViewController * parentController;
@property (nonatomic, readonly) NSString * errorMsg;

@property (nonatomic, strong) NSObject * data;

@end
