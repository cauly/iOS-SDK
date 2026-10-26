//
//  CaulyAdSetting.h
//  Cauly
//
//  Created by Neil Kwon on 9/2/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CaulySDK/Cauly.h>

@interface CaulyAdSetting : NSObject{
    NSArray* serverSettings;
}

+ (CaulyAdSetting *)adSettingWithAppCode:(NSString *)appCode appId:(NSString *)appId;
+ (CaulyAdSetting *)globalSetting;
+ (void)setLogLevel:(CaulyLogLevel)logLevel;
+ (void)setApplicationState:(BOOL)isBackground;

- (id)initWithAppCode:(NSString *)appCode appId:(NSString *)appId;
- (id)initWitAdSetting:(CaulyAdSetting *)adSetting;
- (BOOL)isTestAppCode;


@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appCode;

@property (nonatomic) CaulyReloadTime reloadTime;
@property (nonatomic) CaulyAdSize adSize;
// 배너 광고 뷰의 가로 폭(pt). 0이면 화면의 Safe Area 안쪽 폭을 쓴다(기본값).
// 광고 영역이 Safe Area보다 좁거나 화면 가운데에 있으면 영역 폭을 지정한다.
@property (nonatomic) CGFloat bannerWidth;
@property (nonatomic) CaulyAnim animType;
@property (nonatomic) BOOL useDynamicReloadTime;
@property (nonatomic) BOOL closeOnLanding;
@property (nonatomic, strong) NSNumber *tagForChildDirectedTreatment; // nil = 미설정
@property (nonatomic, strong) NSNumber *gdprConsentAvailable; // nil = 미설정

/**
 * 아래 세 값은 보상형(CaulyRewardAd) 전용이다.
 *
 * 광고 요청은 BDAdRequestService 가 adSetting 만 받아서 조립하므로,
 * 리워드 정보를 서버까지 보내려면 이 객체에 실어 보내는 것이 가장 짧은 경로다.
 * 다른 애드폼에서는 설정되지 않으며 요청 파라미터도 붙지 않는다.
 */
@property (nonatomic) BOOL isRewardAd;
@property (nonatomic, strong) NSString *rewardUserId;
/** 이미 JSON 문자열로 직렬화된 상태로 보관한다. 퍼센트 인코딩은 요청 조립 시점에 한다. */
@property (nonatomic, strong) NSString *rewardCustomData;

@end
