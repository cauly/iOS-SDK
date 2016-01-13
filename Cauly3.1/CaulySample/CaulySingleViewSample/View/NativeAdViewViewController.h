//
//  NativeAdViewViewController.h
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 10/20/15.
//  Copyright © 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaulyNativeAd.h"

@interface NativeAdViewViewController : UIViewController

@property (assign, nonatomic) IBOutlet UILabel *mainTitle;
@property (assign, nonatomic) IBOutlet UILabel *subTitle;
@property (assign, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (assign, nonatomic) IBOutlet UIImageView *icon;
@property (assign, nonatomic) IBOutlet UIImageView *image;
@property (assign, nonatomic) IBOutlet UITextView *jsonStringTextView;
@property (nonatomic) NSString* link;
@property (assign) CaulyNativeAd* nativeAd;
@property (assign) CaulyNativeAdItem* nativeAdItem;
@end
