//
//  TestBannerViewController.h
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 12/28/15.
//  Copyright © 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CaulySDK;

@interface TestBannerViewController : UIViewController<CaulyAdViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (nonatomic) CaulyAdView * adView;
@end
