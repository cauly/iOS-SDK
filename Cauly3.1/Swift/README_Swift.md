iOS SDK 설치가이드(swift)
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
3. Class Reference
	- Callback API
	- 기타 API
	- Properties
 
## Cauly iOS SDK v3.1.0
### Release note
- 성능 개선 및 버그 수정
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
- 2017년 1월 이후 ATS (현재 무기한 보류중)
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
	- 현재 보류 중이지만 언제든 Apple Store 정책에 따라 적용될 수 있습니다. ( 카울리 서버는 ATS 요구 사항을 충족하고 있습니다.)

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
- Xcode 8.0 이상 권장
- BASE SDK : iOS 8.0 이상
- iOS Deployment Target iOS : 8.0 이상
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
		
- Sample XCODE Swift Project 
	
## SDK 설치 방법
### 방법
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
  
3. Import Header

| File Name | |
| ------------ | ---- |
| Cauly.h | Cauly 공통 필수 헤더 |
| CaulyAdView.h | 배너 광고를 사용하고자 하는 곳에 Import |
| CaulyInterstitialAd.h  | 전면 광고를 사용하고자 하는 곳에 Import |
| CaulyNativeAd.h <br> CaulyNativeAdItem.h  | 네이티브 광고를 사용하고자 하는 곳에 Import |
| CaulyAdSetting.h | Cauly 설정 |
	
  - Bridging-Header.h 파일을 생성하고 밑에 사진과 같이 해더파일을 생성해야합니다.
	
<p float="left">
  <img src="/Cauly3.1/Swift/images/hearder.png" width="800" hight="700" />
</p>

  - Build Settings -> 검색바에서 -> Swift Compiler -> Objective-C Bridging Heaer 프로젝트명-Bridging-Header.h 등록
<p float="left">
  <img src="/Cauly3.1/Swift/images/target.png" width="800" hight="1000"/>
</p>

### 구현 

#### Ad Settings
```swift
{
   // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
   let caulySetting = CaulyAdSetting.global();
   CaulyAdSetting.setLogLevel(CaulyLogLevelRelease)//  Cauly Log 레벨
   caulySetting?.appCode = "CAULY"                 //  발급ID 입력
   caulySetting?.animType = CaulyAnimNone          //  화면 전환 효과     
   caulySetting?.closeOnLanding=true               // app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 false입니다.     
}

 // 랜딩 화면 표시
func willShowLanding(_ adView: CaulyAdView!) {
     print("willShowLandingView")
}

// 랜딩 화면이 닫혔을 때
func didCloseLanding(_ adView: CaulyAdView!) {
     print("didCloseLandingView")
}
```

#### Banner Ad
```swift
{
	// Banner AD 호출 
	//  CaulyAdView 객체 생성
	let caulyView:CaulyAdView = CaulyAdView.init(parentViewController: self)     
	view.addSubview(caulyView)
	caulyView.delegate = self                                                //  delegate 설정
	caulyView.startBannerAdRequest()                                         //  배너광고 요청
}

// Banner AD API
#pragma mark - CaulyAdViewDelegate

// 광고 정보 수신 성공
func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
     print("Loaded didReceiveAd callback")
}

// 광고 정보 수신 실패
func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!) {
     print("didFailToReceiveAd:\(errorCode)(\(errorMsg!))");
}
```
#### Interstitial Ad
```swift
{
	// Interstitial AD 호출 
	//  전면광고 객체 생성
	let _interstitialAd:CaulyInterstitialAd? = CaulyInterstitialAd.init(parentViewController: self)
	_interstitialAd?.delegate = self                //  전면 delegate 설정
	_interstitialAd?.startRequest()                 //  전면광고 요청
}

// Interstitial AD API
#pragma mark - CaulyInterstitialAdDelegate

// 광고 정보 수신 성공
func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
     print("didReceiveInterstitialAd");
     _interstitialAd?.show()
     // _interstitialAd?.show()를 호출하지 않으면 Interstitial AD가 보여지지 않음
}

// Interstitial 형태의 광고가 닫혔을 때
func didClose(_ interstitialAd: CaulyInterstitialAd!) {
     print("didCloseInterstitialAd")
     _interstitialAd=nil
}

// Interstitial 형태의 광고가 보여지기 직전
func willShow(_ interstitialAd: CaulyInterstitialAd!) {
     print("willShowInterstitialAd")
}

// 광고 정보 수신 실패
func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
     print("Recevie fail intersitial errorCode:\(errorCode)(\(errorMsg!))");
     _interstitialAd = nil
}
```

[설정 방법]

| 속성 | 설명 |
| --- | --- |
| appCode |	상품 등록 시 부여 받은 발급ID 입력 |
| animType |	CaulyAnimCurlDown : 아래쪽으로 말려 내려가는 애니메이션<br/>CaulyAnimCurlup : 위쪽으로 말려 올라가는 애니메이션<br/>CaulyAnimFadeOut : 전에 있던 광고가 서서히 사라지는 효과<br/>CaulyAnimFlipFromLeft : 왼쪽에서 회전하는 애니메이션<br/>CaulyAnimFlipFromRight : 오른쪽에서 회전하는 애니메이션<br/>CaulyAnimNone(기본값) : 애니메이션 효과 없이 바로 광고 교체 |
| adSize |	CaulyAdSize_IPhone : 320 x 50<br/>
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
- func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool)<br/>// 배너광고 성공|
- func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!)<br/>// 배너광고 실패|
- func willShowLanding(_ adView: CaulyAdView!)<br/>// 랜딩 화면 표시|
- func didCloseLanding(_ adView: CaulyAdView!)// 랜딩 화면이 닫혔을 때|

전면광고 |
--- |
- func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool)<br/>// 전면광고 성공|
- func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!)<br/>// 전면광고 실패|
- func willShow(_ interstitialAd: CaulyInterstitialAd!)// <br/>Interstitial 형태의 광고가 보여지기 직전|
- func didClose(_ interstitialAd: CaulyInterstitialAd!)// <br/>Interstitial 형태의 광고가 닫혔을 때|


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

