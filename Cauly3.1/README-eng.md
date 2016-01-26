![Valid XHTML](http://cauly044.fsnsys.com:10010/images/logo_cauly_main.png) Cauly iOS SDK Installation Guide
=====================================================

Table Of Content

1. Cauly iOS SDK v3.1.0
	- Release note
	- Cautiousness
	- Reference
	- Recommended Environments
	- SDK Components
2. SDK Installation Guide
	- Import Headers
	- Invoke
		- Ad Settings
		- Banner Ad
		- Interstitial Ad
		- Native Ad
		- Native Ad View Create Sample
3. Class Reference
	- Callback API
	- Other API
	- Properties


## Cauly iOS SDK v3.1.0
### Release note
- Support iOS 9.x
- NativeAd Added
- Full Rich video added

### Cautiousness
- iOS9 ATS(App Transport Security) 
	- iOS 9 introduces a new privacy feature called App Transport Security (ATS) to enforce best practices in secure connections between an app and its back end. If ATS enabled, HTTPS is the only protocol granted to connect networks.
	-  The following log message appears when a non-ATS compliant app attempts to serve any resources via HTTP on iOS 9:
		- “App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app’s Info.plist file.”
	- Unfortunately, not every resources which related to advertising materials are served on HTTPS, we recommend put below options into your info.plist file to enable HTTP network connection.
	```xml
	<key>NSAppTransportSecurity</key>
	<dict>
	 	<key>NSAllowsArbitraryLoads</key>
	 	<true/>
	</dict>
	```
	
	- P/E Ad configurations
		- P/E Ad allowance can be controlled by App-wide. If you want to deliver P/E Ad, please contact the Cauly’s Customer Center.
			- cauly.net >> app management >>  Banner CPM >> ON
		- P/E Ad allowance can also be controlled by AdView object with a following API.
			- showPreExpandableAd:(BOOL)
	- Some ads might contains background musics(BGM). If your app also has BGMs, pause then on willShowLandingView API. You can resume your BGM on didCloseLandingView API after the ad has closed.
	- Ad requests might keep going when the ad view is not displayed on screen. If you want to stop ad requests, please call [(CaulyAdView Object)  stopAdRequest] to stop  requests.
	- libCauly-universal.a is universal library for both device and simulator.

### Reference
- Cauly iOS SDK written based on iOS 9 SDK.
- Please get rid of previous Cauly iOS library once you decided to use new SDK. If not SDK might not working properly.
- The followings have to made if referring to the existing library occurs after installing the new SDK. 
	-  Targets
		-  Build Phase : Delete those existing libraries included in the linked libraries in the “General” tab.  
		- Build Settings : Search the “Library Search Paths” and delete any unnecessary paths.  The desired path should be on the top.
- The minimum interval for banner-ad request is 15 sec.

### Recommended Environments
- Xcode 6.0 or higher
- BASE SDK : iOS 7.0 or higher
- iOS Deployment Target iOS : 6.0 or higher

###	SDK Components
- Cauly SDK v3.1.0
	
	| Headers | |
	| ----------- | --- |
	| CaulyAdView.h | Header file for banner-ad and its delegate protocol |
	| CaulyInterstitialAd.h | Header file for Interstitial-ad and its delegate protocol |
	| CaulyNativeAd.h | Header file for Native-ad and its delegate protocol |
	| CaulyNativeAdItem.h | Native-ad item model |
	| Cauly.h | Header file for Cauly defintions |
	| CaulyAdSetting.h | Header file for Cauly ad settings |

- Static Library files
	- libCauly-universal.a – Cauly Ad Static Library (simulator/device universal)
	- libCauly.a – Cauly Ad Static Library (device only)
- Sample XCODE Objective-C Project 
	
## SDK Installation Guide
- Copy ‘CaulyLib’ into a project where Cauly Advertisement will be shown up
- Add Frameworks
	- AVKit.framework
	- UIKit.framework
	- Foundation.framework
	- CoreGraphics.framework
	- QuartzCore.framework
	- SystemConfiguration.framework
	- MediaPlayer.framework
	- Mapkit.framework
	- CoreLocation.framework
	- CFNetwork.framework
	- MessageUI.framework // ‘Optional’ recommended
	- EventKit.framework     //  ‘Optional’ recommended
	- AdSupport.Framwork   // ‘Optional’ recommended
	- Under iOS SDK 4.3 : libz.1.2.3.dylib, iOS SDK 5.0 : libz.1.2.5.dylib

### Import Headers
| File Name | |
| ------------ | ---- |
| Cauly.h | Mandatory over every classes which import below headers |
| CaulyAdView.h | Import when Banner ad required |
| CaulyInterstitialAd.h  | Import when Interstitial ad required |
| CaulyNativeAd.h <br> CaulyNativeAdItem.h  | Import when Native ad required |
| CaulyAdSetting.h | Header file for Cauly ad settings |
    
### Invoke
- Below code should be applied to support proper delegating of screen orientation changes for Banner Ad on iOS 7.1 and lower.
```objectivec
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
      NSLog(@"willRotateToInterfaceOrientation : ");
      [_adView didOrientationChanged:toInterfaceOrientation];
}
```
- Not necessary for iOS 8 or higher
#### Ad Settings
```objectivec
{
	// Description about properties  
	CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
	[CaulyAdSetting setLogLevel:CaulyLogLevelRelease];      //  Cauly Log Level
	adSetting.appCode               = @"CAULY";             //  Accquired App Code
	adSetting.animType              = CaulyAnimNone;        //  Transition Effect	     
	    
	// Dismiss Cauly popup window when Landing Page(or App) bring to front.
	// Default value is NO
	adSetting.closeOnLanding         = YES      
}

// Lading View will show
- (void)willShowLandingView:(CaulyAdView *)adView {
	NSLog(@"willShowLandingView");
}

// Lading View dismissed.
- (void)didCloseLandingView:(CaulyAdView *)adView {
	NSLog(@"didCloseLandingView");
}
```

#### Banner Ad
```objectivec
{
	// Banner AD 
	// Instantiate CaulyAdView
	CaulyAdView *_adView = [[CaulyAdView alloc] initWithParentViewController:self];      
	[self.view addSubview:_adView];
	_adView.delegate = self;                                    //  set delegate
	[_adView startBannerAdRequest];                             //  request Banner Ad
}

// Banner AD API
#pragma mark - CaulyAdViewDelegate

// Successfully receive banner ad
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
	NSLog(@"didReceiveAd");
}

// Failed to receive ad
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
	NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
}

```
#### Interstitial Ad
```objectivec
{
	// Interstitial AD 
	// Instantiate Interstitial Ad
	CaulyInterstitialAd * _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:self]; 
	_interstitialAd.delegate = self;                //  set delegate
	[_interstitialAd startInterstitialAdRequest];   //  request interstitial Ad
}

// Interstitial AD API
#pragma mark - CaulyInterstitialAdDelegate

// Successfully receive interstitial-ad
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
	NSLog(@"didReceiveInterstitialAd");
	[_interstitialAd show];
	// You must call [_interstitialAd show] to display interstitial-ad.

}

// Interstitial-ad view dismissed
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"didCloseInterstitialAd");
	_interstitialAd = nil;
}

// Received interstitial-ad will show
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"willShowInterstitialAd");
}

// Failed to receive interstitial-ad
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
	NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
	_interstitialAd = nil;
}

```

#### Native Ad
```objectivec
{
	// Native Ad
	CaulyNativeAd _nativeAd = [[CaulyNativeAd alloc] initWithParentViewController:self];
    _nativeAd.delegate = self;
    [_nativeAd startNativeAdRequest:2                           // request 2 items
    nativeAdComponentType:CaulyNativeAdComponentType_IconImage  
    imageSize:@"720x480"];
}

// Successfully receive Native Ad
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd{
	NSLog(@"didReceiveNativeAd");
}

// Failed to receive Native Ad
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg{
    NSLog(@"didFailToReceiveNativeAd");
}

```
   
##### Native Ad View Create Sample
- Sample code to generate View
```objectivec
#pragma - Native delegates

// Successfully receive Native Ad
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"didReceiveNativeAd");
    CaulyNativeAdItem* caulyNativeAd = [nativeAd nativeAdItemAt:0];

    NSArray* allList= [nativeAd nativeAdItemList];
    NSLog(@"%@",caulyNativeAd);
    NSLog(@"%@",caulyNativeAd.nativeAdJSONString);

    for(CaulyNativeAdItem* adItem in allList){
        NSLog(@"%@",adItem.nativeAdJSONString);
    }

    NSError *error;
    NSDictionary *nativeAdItem = [NSJSONSerialization JSONObjectWithData:[caulyNativeAd.nativeAdJSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];



    //    NativeAdViewViewController

    NativeAdViewViewController *areaSelectView = [[NativeAdViewViewController alloc] initWithNibName:@"NativeAdViewViewController" bundle:nil];

    areaSelectView.nativeAd = nativeAd;

    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:areaSelectView animated:NO];
    areaSelectView.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        areaSelectView.view.alpha = 1;

        NSURL *url = [NSURL URLWithString:nativeAdItem[@"icon"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *icon = [UIImage imageWithData:data];

        if(nativeAdItem[@"image"]){
            url = [NSURL URLWithString:nativeAdItem[@"image"]];
            data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [areaSelectView.image setImage:image];
        }

        [areaSelectView.icon setImage:icon];

        [areaSelectView.mainTitle setText:nativeAdItem[@"title"]];
        [areaSelectView.subTitle setText:nativeAdItem[@"subtitle"]];
        [areaSelectView.descriptionLabel setText:nativeAdItem[@"description"]];
        areaSelectView.link = nativeAdItem[@"link"];

        [areaSelectView.jsonStringTextView setText:caulyNativeAd.nativeAdJSONString];
    }];

}

// Failed to receive Native Ad
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg{
    NSLog(@"didFailToReceiveNativeAd");
}

```
----
- NativeAdViewViewController
```objectivec

#import <UIKit/UIKit.h>
#import "CaulyNativeAd.h"

@interface NativeAdViewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *jsonStringTextView;
@property (nonatomic) NSString* link;
@property (assign) CaulyNativeAd* nativeAd;
@property (assign) CaulyNativeAdItem* nativeAdItem;
@end

```
----

```objectivec

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

@end

```

[Ad Setting Properties]

| Property | Description |
| --- | --- |
| appCode | Received code after registering the App. (Use ‘CAULY’ for a test)<br/> Other available test app codes: CAULY-RICHADTEST CAULY-PETEST, CAULY-3DTEST |
| animType | CaulyAnimCurlDown : Curl down animation<br/>CaulyAnimCurlup : Curl up animation<br/>CaulyAnimFadeOut : Old banner fades out and new banner fades in<br/>CaulyAnimFlipFromLeft : Flip animation from left<br/>CaulyAnimFlipFromRight : Flip animation from right<br/>CaulyAnimNone(Default) : No amination |
| useGPSInfo | Decides usability of GPS information from Cauly’s SDK.<br/>YES or NO(default) |
| adSize |	CaulyAdSize_IPhone : 320 x 50<br/>CaulyAdSize_IPadLarge : 728 x 90<br/>CaulyAdSize_IPadSmall : 468 x 60
| reloadTime |	CaulyReloadTime_30(default) : 30 sec<br/>CaulyReloadTime_60 : 60 sec<br/>CaulyReloadTime_120 : 120 sec
| useDynamicReloadTime |YES(default) : Reloading time could be set differently by Ads, thus higher profit would be expected.<br>NO : Rolls according to reloadTime set period |

[error code definition]

| Code	| Message |	설명 |
| --- | --- | --- |
| 0 | OK | Paid AD |
| 100 |	Non-chargeable ad is supplied| Free AD (Public service ads, cauly’s basic ads) |
| 200 |	No filled AD	| No proper ad is available. |
| 400 | The app code is invalid. Please check your app code!| Discordance of app code or default app code. |
| 500 | Server error| Cauly server error |
| -100 | SDK error|	SDK error |
| -200 | Request Failed<br>(You are not allowed to send requests under minimum interval)| Minimum request interval has not passed. |


**If you need more informations to install cauly SDK, please give us a call to the customer center +82-1544-8867 or send an e-mail to cauly@fsn.co.kr.** 

## Class Reference
###  Callback API
Banner Ad|
---|
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd;<br>// Successfully received banner-ad |
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// Failed to receive banner-ad |
- (void)willShowLandingView:(CaulyAdView *)adView;<br/>// Landing view will be shown |
- (void)didCloseLandingView:(CaulyAdView *)adView;// Landing view has closed |

Interstitial-ad |
--- |
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd;<br/>// Successfully received interstitial-ad |
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// Failed to receive interstitial-ad |
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd;<br/>// Interstitial-ad will be shown |
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd;<br/>// Interstitial-ad has closed|

Native Ad |
---|
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd;<br/>// Successfully received native-ad |
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// Failed to receive native-ad |


### Other API

Banner Ad |
--- |
+ (id)caulyAdViewWithController:(UIViewController *)controller;<br/>// Class method to create banner-ad object |
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// Instance method to create banner-ad object |
- (void)startBannerAdRequest;<br/>// Request banner-ad |
- (void)stopAdRequest;<br/>// Stop banner-ad request |

Interstitial-ad |
--- |
+ (id)caulyAdWithController:(UIViewController *)controller;<br/>// Class method to create interstitial-ad object |
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// Instance method to create interstitial-ad object |
- (void)startInterstitialAdRequest;<br/>// Request interstitial-ad |
- (void)stopAdRequest;<br/>// Stop interstitial-ad request |

Native Ad |
--- |
+ (id)caulyAdWithController:(UIViewController *)controller;<br/>// Class method to create native-ad object |
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// Instance method to create native-ad object |
- (void)startNativeAdRequest:(int) adListSize nativeAdComponentType:(CaulyNativeAdComponentType) nativeAdComponentType imageSize:(NSString*) imageSize;<br/>// Request native-ad |
- (void)stopAdRequest;<br/>// Stop native-ad request |


### Properties
Banner Ad |
---|
delegate<br/>// Delegation object for CaulyAdViewDelegate protocol |
localSetting<br/>// Object setting by CaulyAdSetting |
parentController<br/>// ParentViewController object |
errorMsg<br/>// Error messages for banner-ad |
showPreExpandableAd<br/>// Set P/E Ad allowance |

Interstitial-ad |
---|
delegate<br/>// Delegation object for CaulyInterstitialAdDelegate protocol |
localSetting<br/>// Object setting by CaulyAdSetting |
parentController<br/>// ParentViewController object |
errorMsg<br/>// Error messages for interstitial-ad |

Native Ad|
---|
delegate<br/>// Delegation object for CaulyNativeAdDelegate protocol |
localSetting<br/>// Object setting by CaulyAdSetting |
parentController<br/>// ParentViewController object |
errorMsg<br/>// Error messages for native-ad |
