//
//  FirstViewController.m
//  CaulySample
//
//  Created by 오빠 on 12. 3. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)dealloc {
	[_adView release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"First", @"First");
		self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_adView.delegate = self;
	[_adView startAdRequestWithPayType:CaulyPayType_CPM];
}

- (void)viewDidUnload
{
	[_adView release];
	_adView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	
}

#pragma mark - CaulyAdViewDelegate

- (void)didReceivedAdInfoWithAdView:(CaulyAdView *)adView {
}

- (void)didFailedToReceiveAdInfoWithAdView:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
}

- (void)didClosePopupAdView:(CaulyAdView *)adView {
}

- (void)willShowPopupAdView:(CaulyAdView *)adView {
}


@end
