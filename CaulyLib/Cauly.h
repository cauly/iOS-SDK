//
//  Cauly.h
//  Cauly
//
//  Created by FSN on 12. 3. 15..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEST_APP_CODE			(@"CAULY")

#define CAULY_SDK_VERSION		(@"3.0.6")

#define CAULY_ERR_SUCCESS		(0)
#define CAULY_ERR_FAILED		(1)
#define CAULY_ERR_INAVLID_XML	(2)

// 전방선언
@class CaulyAdView;
@class CaulyInterstitialAd;

// 광고 갱신 시간
typedef enum {
	CaulyReloadTime_30,		// 30초
	CaulyReloadTime_60,		// 60초
	CaulyReloadTime_120		// 120초
} CaulyReloadTime;

// 광고 크기
typedef enum {
	CaulyAdSize_IPhone,		// 320 * 48
	CaulyAdSize_IPadLarge,	// 728 * 90
	CaulyAdSize_IPadSmall	// 468 * 60
} CaulyAdSize;

// 나이 설정
typedef enum {
	CaulyAge_10,			// 10대
	CaulyAge_20,			// 20대
	CaulyAge_30,			// 30대
	CaulyAge_40,			// 40대
	CaulyAge_50,			// 50대
	CaulyAge_All			// 전체
} CaulyAge;

// 성별 설정
typedef enum {
	CaulyGender_Male,		// 남자
	CaulyGender_Female,		// 여자
	CaulyGender_All			// 전체
} CaulyGender;

// 화면 전환 효과
typedef enum {
	CaulyAnimCurlUp,		// Curl Up
	CaulyAnimCurlDown,		// Curl Down
	CaulyAnimFlipFromLeft,	// 뒤집기(Left->Right)
	CaulyAnimFlipFromRight,	// 뒤집기(Right->Left)
	CaulyAnimFadeOut,		// Fade Out
	CaulyAnimNone			// 애니메이션 없음
} CaulyAnim;

// Log 레벨
typedef enum {
	CaulyLogLevelMinimal,
	CaulyLogLevelRelease,
	CaulyLogLevelDebug,
	CaulyLogLevelAll
} CaulyLogLevel;


// Error Code
#define CaulyError_OK					(0)
#define CaulyError_NO_CHARGED			(100)
#define CaulyError_NO_FILL_AD			(200)
#define CaulyError_INVAILD_APP_CODE		(400)
#define CaulyError_SERVER_ERROR			(500)
#define CaulyError_NOT_ALLOW_INTERVAL	(-200)
#define CaulyError_SDK_INNER_ERROR		(-100)


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

@end

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

