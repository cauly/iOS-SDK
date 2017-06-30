//
//  NativeAdViewViewController.m
//  CaulySingleViewSample
//
//  Created by Neil Kwon on 10/20/15.
//  Copyright © 2015 Cauly. All rights reserved.
//

#import "NativeAdViewViewController.h"

@interface NativeAdViewViewController ()

@end

@implementation NativeAdViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Inform");
    [_nativeAd sendInform:_nativeAdItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didViewTouchUpInside:(id)sender {
    NSLog(@"Native ad Clicked");
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL b){
        [_nativeAd click:_nativeAdItem];
        
        self.view.alpha = 1;
        [self.presentingViewController dismissModalViewControllerAnimated:NO];
    }];
}
- (IBAction)closeButtonTouchUpInside:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}
- (IBAction)optOutButtonTouchUpInside:(id)sender {
    [_nativeAd sendToOptOutLinkUrl:_nativeAdItem];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
