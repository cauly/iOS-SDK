//
//  FirstViewController.h
//  CaulySample
//
//  Created by 오빠 on 12. 3. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaulyAdView.h"

@interface FirstViewController : UIViewController<CaulyAdViewDelegate> {
	
	IBOutlet CaulyAdView * _adView;
	
}

@end
