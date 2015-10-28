//
//  CaulyAdSetting.h
//  Cauly
//
//  Created by FSN on 12. 3. 15..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cauly.h"

@interface CaulyAdSetting : NSObject {
	
}

+ (CaulyAdSetting *)adSettingWithAppCode:(NSString *)appCode;
+ (CaulyAdSetting *)globalSetting;
+ (void)setLogLevel:(CaulyLogLevel)logLevel;

+ (void)setCauly3DAcceleration:(UIAcceleration *)acceleration;
+ (UIAcceleration *)cauly3DAcceleration;
+ (void)setApplicationState:(BOOL)isBackground;

- (id)initWithAppCode:(NSString *)appCode;
- (id)initWitAdSetting:(CaulyAdSetting *)adSetting;
- (BOOL)isTestAppCode;


@property (nonatomic, retain) NSString * appCode;

@property (nonatomic) CaulyGender gender;
@property (nonatomic) CaulyAge age;
@property (nonatomic) CaulyReloadTime reloadTime;
@property (nonatomic) CaulyAdSize adSize;
@property (nonatomic) CaulyAnim animType;
@property (nonatomic) BOOL useGPSInfo;
@property (nonatomic) BOOL useDynamicReloadTime;
@property (nonatomic) BOOL closeOnLanding;

@end
