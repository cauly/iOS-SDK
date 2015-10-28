//
//  CaulyAdView.h
//  Cauly
//
//  Created by FSN on 12. 3. 15..
//  Copyright (c) 2012년 FutureStreamNetworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cauly.h"
#import "CaulyAdSetting.h"

// Cauly 광고 View
@interface CaulyAdView : UIView 

+ (id)caulyAdViewWithController:(UIViewController *)controller;
- (id)initWithParentViewController:(UIViewController *)controller;

- (void)startBannerAdRequest;

- (void)stopAdRequest;

@property (nonatomic, assign) id<CaulyAdViewDelegate> delegate;
@property (nonatomic, retain) CaulyAdSetting * localSetting;
@property (nonatomic, retain) UIViewController * parentController;
@property (nonatomic, readonly) NSString * errorMsg;
@property (nonatomic, assign) BOOL showPreExpandableAd;

@property (nonatomic, retain) NSObject * data;

@end
