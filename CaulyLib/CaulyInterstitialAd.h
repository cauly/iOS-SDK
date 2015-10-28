//
//  CaulyInterstitialAd.h
//  Cauly
//
//  Created by FutureStreamNetworks on 12. 3. 19..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cauly.h"
#import "CaulyAdSetting.h"

@interface CaulyInterstitialAd : NSObject

+ (id)caulyAdWithController:(UIViewController *)controller;
- (id)initWithParentViewController:(UIViewController *)controller;

- (void)startInterstitialAdRequest;
- (void)stopAdRequest;
- (void)show;
- (void)close;

@property (nonatomic, assign) id<CaulyInterstitialAdDelegate> delegate;
@property (nonatomic, retain) CaulyAdSetting * localSetting;
@property (nonatomic, retain) UIViewController * parentController;
@property (nonatomic, readonly) NSString * errorMsg;

@property (nonatomic, retain) NSObject * data;


@end
