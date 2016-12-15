![Valid XHTML](http://cauly044.fsnsys.com:10010/images/logo_cauly_main.png) iOS SDK 설치가이드
=====================================================

목차 

1. Cauly iOS SDK v3.1.0
	- Release note
	- 주의 사항
	- 참고 사항
	- 권장 환경
	- SDK 구성
2. SDK 설치 방법
	- Import Header
	- 구현
		- Ad Settings
		- Banner Ad
		- Interstitial Ad
		- Native Ad
		- Native Ad View 생성예제
3. Class Reference
	- Callback API
	- 기타 API
	- Properties
 
## Cauly iOS SDK v3.1.0
### Release note
- iOS9 대응 
- NativeAd 
- 전면 Rich Video

### 주의 사항
- iOS9 ATS(App Transport Security) 처리
	- 애플은 iOS9에서 ATS(App Transport Security)라는 기능을 제공합니다. 기기에서 ATS 활성화 시 암호화된 HTTPS 방식만 허용됩니다. HTTPS 방식을 적용하지 않을 경우 애플 보안 기준을 충족하지 않는다는 이유로 광고가 차단될 수 있습니다.
	- 모든 광고가 HTTPS 방식으로 호출되지 않으므로, info.plist 파일에 아래소스를 적용하여 사용 부탁 드립니다.
		
	```xml
	 <key>NSAppTransportSecurity</key>
	 <dict>
	 	<key>NSAllowsArbitraryLoads</key>
	 	<true/>
 	</dict>
		
	```
- 2017년 1월 이후 ATS 
	- 2017년 1월 이후 ATS를 활성화한 앱에 대해서만 앱스토어에 등록할 수 있도록한 애플 정책이 수립되었습니다. 따라서 기존 설정과 함께 추가적인 설정을 추가하여야 합니다.
	
	```xml
	<key>NSAppTransportSecurity</key>
    	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
		<key>NSAllowsArbitraryLoadsForMedia</key>
		<true/>
		<key>NSAllowsArbitraryLoadsInWebContent</key>
		<true/>
	</dict>
	```

- P/E광고 설정 관련
	- 앱 마다 P/E광고 허용 여부를 설정 할 수 있으며, P/E광고 노출을 원하는 경우 ‘cauly홈페이지>>APP관리’에서 ‘ON’ 으로 설정하면 됩니다.
		- Cauly 홈페이지 >> app 관리 >> 수익구분 : 배너CPM >> ON
	- P/E광고를 노출을 원하지 않는 ‘화면’ 또는 ‘adview객체’ 에서는 아래 API 설정값을 ‘FALSE’ 로 변경하시면 광고가 호출되지 않습니다.
		- showPreExpandableAd:(BOOL)
- BGM이 포함된 광고가 있을 수 있으니, APP에 BGM이 있는 경우 willShowLandingView API를 이용하여 일시 중지 해주세요, 그리고 광고 종료 후 didCloseLandingView API를 이용하여 BGM을 재 시작 하시면 됩니다.
- 광고뷰가 화면에 보여지지 않는 경우에도 광고 요청을 할 수 있습니다. 광고 요청을 중단하고자 할 때 [CaulyAdView 객체 stopAdRequest]; 명령을 실행하여 광고 요청을 반드시 중지하기 바랍니다.
- libCauly-universal.a 는 simulator와 device 통합된 파일 입니다. 

### 참고 사항
- cauly SDK는 iOS SDK 9.0 기반으로 작성 되었습니다.
- 기존 프로젝트에 있던 과거 SDK를 깨끗하게 지운 후 설치해야 정상 동작 됩니다.
- 새 SDK를 설치해도 기존 Library를 참조하는 경우 다음 작업을 수행 합니다.
	- [Targets 에서 “Get Info”]
		- “Build Phase” 탭 에서 Linked Libraries에 기존 라이브러리가 포함된 게 있다면 삭제 합니다.
		- “Build Settings” 탭에서 “Library Search Paths” 검색하여 불필요한 경로 삭제 합니다.
				원하는 경로가 제일 위로 가야 합니다.
- 배너광고 최소 요청 주기 15 초 입니다.

### 권장 환경
- Xcode 6.0 이상 권장
- BASE SDK : iOS 7.0 이상
- iOS Deployment Target iOS : 6.0 이상
### SDK 구성
- cauly SDK v3.1.0
	- 헤더 파일

		| Headers ||
		| ----------- | --- |
		| CaulyAdView.h | Banner 광고 클래스 헤더와 Delegate protocol |
		| CaulyInterstitialAd.h | Interstitial 광고 클래스 헤더와 Delegate protocol |
		| CaulyNativeAd.h | Native 광고 클래스 헤더와 Delegate protocol |
		| CaulyNativeAdItem.h | Native 광고 아이템 헤더 |
		| Cauly.h | Cauly 헤더 |
		| CaulyAdSetting.h | Cauly 광고 세팅 클래스 헤더 |

	- 라이브러리
		- libCauly-universal.a – Cauly 광고 라이브러리 파일(simulator/device 통합)
		- libCauly.a – Cauly 광고 라이브러리 파일(device 전용)
		
- Sample XCODE Objective-C Project 
	
## SDK 설치 방법
1. cauly를 적용할 project 내에 ‘CaulyLib’ 폴더 복사
2. Framework 추가
	- AVKit.framework
	- UIKit.framework
	- Foundation.framework
	- CoreGraphics.framework
	- QuartzCore.framework
	- SystemConfiguration.framework
	- MediaPlayer.framework
	- CFNetwork.framework
	- MessageUI.framework  //‘Required’ 를 ‘Optional’로 변경해야 합니다.
	- EventKit.framework    // ‘Required’ 를 ‘Optional’로 변경해야 합니다.
	- AdSupport.Framwork  // ‘Required’ 를 ‘Optional’로 변경해야 합니다.
	- SDK 4.3 이하 : libz.1.2.3.dylib, iOS SDK 5.0 : libz.1.2.5.dylib

###  Import Header
| File Name | |
| ------------ | ---- |
| Cauly.h | Cauly 공통 필수 헤더 |
| CaulyAdView.h | 배너 광고를 사용하고자 하는 곳에 Import |
| CaulyInterstitialAd.h  | 전면 광고를 사용하고자 하는 곳에 Import |
| CaulyNativeAd.h <br> CaulyNativeAdItem.h  | 네이티브 광고를 사용하고자 하는 곳에 Import |
| CaulyAdSetting.h | Cauly 설정 |
	
### 구현 
- iOS 7.1 이하 버전의 디바이스에서 Banner 광고의 Orientation Rotate 를 정확히 처리하기 위해선 아래 code를 적용. 
- iOS 8 이상에서는 불필요.
```objectivec    
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"willRotateToInterfaceOrientation : ");
    [_adView didOrientationChanged:toInterfaceOrientation];
}
```
#### Ad Settings
```objectivec
{
	// 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
	CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
	[CaulyAdSetting setLogLevel:CaulyLogLevelRelease];               //  Cauly Log 레벨
	adSetting.appCode               = @"CAULY";             //  발급ID 입력
	adSetting.animType              = CaulyAnimNone;        //  화면 전환 효과	     
	    
	// app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 NO입니다.
	adSetting.closeOnLanding         = YES      
}

// 랜딩 화면 표시
- (void)willShowLandingView:(CaulyAdView *)adView {
	NSLog(@"willShowLandingView");
}

// 랜딩 화면이 닫혔을 때
- (void)didCloseLandingView:(CaulyAdView *)adView {
	NSLog(@"didCloseLandingView");
}
```

#### Banner Ad
```objectivec
{
	// Banner AD 호출 
	//  CaulyAdView 객체 생성
	CaulyAdView *_adView = [[CaulyAdView alloc] initWithParentViewController:self];      
	[self.view addSubview:_adView];
	_adView.delegate = self;                                                //  delegate 설정
	[_adView startBannerAdRequest];                                         //  배너광고 요청
}

// Banner AD API
#pragma mark - CaulyAdViewDelegate

// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
	NSLog(@"didReceiveAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
	NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
}

```
#### Interstitial Ad
```objectivec
{
	// Interstitial AD 호출 
	//  전면광고 객체 생성
	CaulyInterstitialAd * _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:self]; 
	_interstitialAd.delegate = self;    //  전면 delegate 설정
	[_interstitialAd startInterstitialAdRequest];   //  전면광고 요청
}

// Interstitial AD API
#pragma mark - CaulyInterstitialAdDelegate

// 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
	NSLog(@"didReceiveInterstitialAd");
	[_interstitialAd show]; 
	// [_interstitialAd show];를 호출하지 않으면 Interstitial AD가 보여지지 않음
}

// Interstitial 형태의 광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"didCloseInterstitialAd");
	_interstitialAd = nil;
}

// Interstitial 형태의 광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	NSLog(@"willShowInterstitialAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
	NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
	_interstitialAd = nil;
}

```

#### Native Ad
```objectivec
{
	// Native Ad 호출
	CaulyNativeAd _nativeAd = [[CaulyNativeAd alloc] initWithParentViewController:self];
    _nativeAd.delegate = self;
    // 
    [_nativeAd startNativeAdRequest:2
    nativeAdComponentType:CaulyNativeAdComponentType_IconImage 
    imageSize:@"720x480"];
}

// Native Ad 수신 성공
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd{
	NSLog(@"didReceiveNativeAd");
}

// 광고 정보 수신 실패
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg{
    NSLog(@"didFailToReceiveNativeAd");
}

```
   
##### Native Ad View 생성예제
- Sample code to generate View
```objectivec
#pragma - Native delegates

// 광고 정보 수신 성공
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

// 광고 정보 수신 실패
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

[설정 방법]

| 속성 | 설명 |
| --- | --- |
| appCode |	상품 등록 시 부여 받은 발급ID 입력<br/>Sample AppCode : CAULY, CAULY-RICHADTEST, CAULY-PETEST,<br/>CAULY-3DTEST, CAULY-VIDEOTEST |
| animType |	CaulyAnimCurlDown : 아래쪽으로 말려 내려가는 애니메이션<br/>CaulyAnimCurlup : 위쪽으로 말려 올라가는 애니메이션<br/>CaulyAnimFadeOut : 전에 있던 광고가 서서히 사라지는 효과<br/>CaulyAnimFlipFromLeft : 왼쪽에서 회전하는 애니메이션<br/>CaulyAnimFlipFromRight : 오른쪽에서 회전하는 애니메이션<br/>CaulyAnimNone(기본값) : 애니메이션 효과 없이 바로 광고 교체 |
| useGPSInfo |	카울리 SDK에서 GPS정보를 얻어 갈지 설정 값을 리턴합니다.<br/>-	YES : 자동으로 현재 디바이스의 GPS정보를 얻어 감<br/>-	NO(기본값) : GPS정보를 얻어 가지 않도록 설정
| adSize |	CaulyAdSize_IPhone : 320 x 48<br/>CaulyAdSize_IPadLarge : 728 x 90<br/>CaulyAdSize_IPadSmall : 468 x 60
| reloadTime |	CaulyReloadTime_30(기본값) : 30초<br/>CaulyReloadTime_60 : 60초<br/>CaulyReloadTime_120 : 120초
| useDynamicReloadTime |	YES(기본값) : 광고에 따라 노출 주기 조정할 수 있도록 하여 광고 수익 상승 효과 기대<br/>NO : 설정 시 reloadTime 설정 값으로 Rolling |

[error 코드 정의]

| Code	| Message |	설명 |
| --- | --- | --- |
| 0 | OK | 유료 광고 |
| 100 |	Non-chargeable ad is supplied|	무료 광고(속성 : 공익 광고, Cauly 기본 광고) |
| 200 |	No filled AD	|광고 없음 |
| 400 | The app code is invalid. Please check your app code!|	App code 불일치 또는default app code |
| 500 | Server error|	Cauly서버 에러 |
| -100 | SDK error|	SDK 에러 |
| -200 | Request Failed(You are not allowed to send requests under minimum interval)|	최소요청주기 미달 |


**Cauly SDK 설치 관련하여 문의 사항은 고객센터 1544-8867 또는 cauly@fsn.co.kr 로 문의 주시면 빠르게 응대해 드리도록 하겠습니다** 

## Class Reference
###  Callback API
배너광고 |
---|
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd;<br/>// 배너광고 성공|
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// 배너광고 실패|
- (void)willShowLandingView:(CaulyAdView *)adView;<br/>// 랜딩 화면 표시|
- (void)didCloseLandingView:(CaulyAdView *)adView;// 랜딩 화면이 닫혔을 때|

전면광고 |
--- |
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd;<br/>// 전면광고 성공|
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// 전면광고 실패|
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd;// <br/>Interstitial 형태의 광고가 보여지기 직전|
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd;// <br/>Interstitial 형태의 광고가 닫혔을 때|

네이티브광고 |
--- |
- (void)didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd;<br/>// 광고 정보 수신 성공|
- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;<br/>// 광고 정보 수신 실패|


### 기타 API

배너광고 |
--- |
+ (id)caulyAdViewWithController:(UIViewController *)controller;<br/>// 배너광고 객체 생성 클래스 메소드|
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// 배너광고 객체 생성 인스턴스 메소드|
- (void)startBannerAdRequest;<br/>// 배너광고 요청|
- (void)stopAdRequest;<br/>// 배너광고 요청 중지|

전면광고|
--- |
+ (id)caulyAdWithController:(UIViewController *)controller;<br/>// 전면광고 객체 생성 클래스 메소드|
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// 전면광고 객체 생성 인스턴스 메소드|
- (void)startInterstitialAdRequest;<br/>// 전면광고 요청|
- (void)stopAdRequest;<br/>// 전면광고 요청 중지|

네이티브 광고|
--- |
+ (id)caulyAdWithController:(UIViewController *)controller;<br/>// 네이티브광고 객체 생성 클래스 메소드 |
- (id)initWithParentViewController:(UIViewController *)controller;<br/>// 네이티브광고 객체 생성 인스턴스 메소드 |
- (void)startNativeAdRequest:(int) adListSize nativeAdComponentType:(CaulyNativeAdComponentType) nativeAdComponentType imageSize:(NSString*) imageSize;<br/>// 네이티브광고 요청  |
- (void)stopAdRequest;<br/>// 네이티브광고 요청 중지 |

### Properties
배너광고|
---|
delegate<br/>// CaulyAdViewDelegate 프로토콜을 구현한 delegate 객체 |
localSetting<br/>// CaulyAdSetting 세팅된 객체 설정|
parentController<br/>// parentViewController 객체|
errorMsg<br/>// 배너광고 에러 메시지|
showPreExpandableAd<br/>// PE 광고 허용 여부|

전면광고|
---|
delegate<br/>// CaulyInterstitialAdDelegate 프로토콜을 구현한 delegate 객체|
localSetting<br/>// CaulyAdSetting 세팅된 객체 설정|
parentController<br/>// parentViewController 객체|
errorMsg<br/>// 전면광고 에러 메시지|

네이티브광고|
---|
delegate<br/>// CaulyNativeAdDelegate 프로토콜을 구현한 delegate 객체|
localSetting<br/>// CaulyAdSetting 세팅된 객체 설정|
parentController<br/>// parentViewController 객체|
errorMsg<br/>// 네이티브광고 에러 메시지|

