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
// 배너 광고 뷰의 가로 폭(pt). 0이면 디바이스 전체 폭을 쓴다(기본값).
@property (nonatomic) CGFloat bannerWidth;
@property (nonatomic) CaulyAnim animType;
@property (nonatomic) BOOL useDynamicReloadTime;
@property (nonatomic) BOOL closeOnLanding;
@property (nonatomic, strong) NSNumber *tagForChildDirectedTreatment; // nil = 미설정
@property (nonatomic, strong) NSNumber *gdprConsentAvailable; // nil = 미설정

@end
