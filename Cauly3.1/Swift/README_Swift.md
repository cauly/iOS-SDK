iOS SDK 설치가이드(swift)
=====================================================

목차 

1. Cauly iOS SDK v3.1
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
 
## Cauly iOS SDK v3.1
### Release note
- 성능 개선 및 버그 수정
### 주의 사항
- SKAdNetwork 지원
	- Info.plist 파일에 SKAdNetworkItems 키를 추가하고 Cauly (55644vm79v.skadnetwork) 에 대한 SKAdNetworkIdentifier 값과 함께 Cauly 의 파트너 DSP 의 SKAdNetworkIdentifier 값을 추가합니다.
	- 즉, Info.plist 파일에 아래 내용을 추가해주시면 Cauly 와 Cauly 를 통한 다른 DSP 의 광고가 정상적으로 처리될 수 있습니다.
		
	```xml
	<key>SKAdNetworkItems</key>
	<array>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>55644vm79v.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>4fzdc2evr5.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>4pfyvq9l8r.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>v72qych5uu.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>6xzpu9s2p8.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>ludvb6z3bs.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>mlmmfzh3r3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>294l99pt4k.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>24t9a8vw3c.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>hs6bdukanm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>cstr6suwn9.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>54nzkqm89y.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>wzmmz9fp6w.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>yclnxrl5pm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>7ug5zh24hu.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>feyaarzu9v.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>kbd757ywx3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>275upjj5gd.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>9t245vhmpl.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>44jx6755aq.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>tl55sbb4fm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>2u9pt9hc89.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>8s468mfl3y.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>74b6s63p6l.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>uw77j35x4d.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>gvmwg8q7h5.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>gta9lk7p23.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>32z4fx6l9h.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3rd42ekr43.skadnetwork</string>
		</dict>
	</array>
	```	

- iOS9 ATS(App Transport Security) 처리
	- 애플은 iOS9 에서 ATS(App Transport Security)라는 기능을 제공합니다. 기기에서 ATS 활성화 시 암호화된 HTTPS 방식만 허용됩니다. HTTPS 방식을 적용하지 않을 경우 애플 보안 기준을 충족하지 않는다는 이유로 광고가 차단될 수 있습니다.
	- 모든 광고가 HTTPS 방식으로 호출되지 않으므로, info.plist 파일에 아래 설정을 적용하여 사용 부탁 드립니다.
	- (추가) 2017년 1월 이후 ATS를 활성화한 앱에 대해서만 앱스토어에 등록할 수 있도록한 애플 정책이 수립되었습니다. 따라서 기존 설정과 함께 추가적인 설정을 추가하여야 합니다.
		
	```xml
	 <key>NSAppTransportSecurity</key>
	 <dict>
	 	<key>NSAllowsArbitraryLoads</key>
	 	<true/>
 	</dict>
	```

	- BGM이 포함된 광고가 있을 수 있으니, APP에 BGM이 있는 경우 willShowLandingView API를 이용하여 일시 중지 해주세요, 그리고 광고 종료 후 didCloseLandingView API를 이용하여 BGM을 재 시작 하시면 됩니다.
	- 광고뷰가 화면에 보여지지 않는 경우에도 광고 요청을 할 수 있습니다. 광고 요청을 중단하고자 할 때 [CaulyAdView 객체 stopAdRequest]; 명령을 실행하여 광고 요청을 반드시 중지하기 바랍니다.
	- libCauly-universal.a 는 simulator와 device 통합된 파일 입니다. 

- iOS14 ATT(App Tracking Transparency) Framework 적용
	- 애플은 iOS14 에서 ATT(App Tracking Transparency) Framework가 추가되었습니다.
	- IDFA 식별자를 얻기 위해서는 `ATT Framework를 반드시 적용`해야 합니다.
	- `info.plist`
	```xml
	<key> NSUserTrackingUsageDescription </key>
	<string> 맞춤형 광고 제공을 위해 사용자의 데이터가 사용됩니다. </string>
	```

	- `BannerViewController.swift`
	```swift
	import AppTrackingTransparency
	... 
	DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:       // 승인
                        print("Authorized")
                        // self.initCauly()			// 권한 요청이 완료된 다음, 광고를 요청해 주세요.
                    case .denied:           // 거부
                        print("Denied")
                    case .notDetermined:        // 미결정
                        print("Not Determined")
                    case .restricted:           // 제한
                        print("Restricted")
                    @unknown default:           // 알려지지 않음
                        print("Unknow")
                    }
                })
            }
        }
	```

- 사용자 앱 내 광고 경험 개선을 위한 URL Scheme 적용
	- info.plist 작성
	```xml
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>naversearchapp</string>
	</array>
	```

### 참고 사항
- cauly SDK는 iOS SDK 12.0 기반으로 작성 되었습니다.
- 기존 프로젝트에 있던 과거 SDK를 깨끗하게 지운 후 설치해야 정상 동작 됩니다.
- 새 SDK를 설치해도 기존 Library를 참조하는 경우 다음 작업을 수행 합니다.
	- [Targets 에서 “Get Info”]
		- “Build Phase” 탭 에서 Linked Libraries에 기존 라이브러리가 포함된 게 있다면 삭제 합니다.
		- “Build Settings” 탭에서 “Library Search Paths” 검색하여 불필요한 경로 삭제 합니다.
				원하는 경로가 제일 위로 가야 합니다.

### 권장 환경
> 2024년 4월 29일부터 앱 스토어에 앱을 제출하려면 Xcode 15.0 이상 버전 사용이 필요합니다.  
> https://developer.apple.com/news/upcoming-requirements/?id=04292024a  

- Xcode 15.0 이상 사용
- iOS 12.0 이상 타겟팅

### SDK 구성
- Cauly SDK 헤더 파일

| 파일명                   | 설명                       |
|-----------------------|--------------------------|
| Cauly.h               | Cauly SDK 공용 헤더 파일       |
| CaulyAdSetting.h      | Cauly 광고 세팅 클래스 헤더 파일    |
| CaulyAdView.h         | 광고 광고 클래스 및 프로토콜 헤더 파일   |
| CaulyInterstitialAd.h | 전면 광고 클래스 및 프로토콜 헤더 파일   |
| CaulyNativeAd.h       | 네이티브 광고 클래스 및 프로토콜 헤더 파일 |
| CaulyNativeAdItem.h   | 네이티브 광고 아이템 헤더 파일        |

- Cauly SDK 라이브러리 파일

| 파일명                  | 설명                                   |
|----------------------|--------------------------------------|
| libCauly.a           | Cauly SDK 라이브러리 파일 (디바이스 전용)         |
| libCauly-universal.a | Cauly SDK 라이브러리 파일 (시뮬레이터 및 디바이스 통합) |
| CaulySDK.xcframework    | Cauly SDK Framework 파일	(ARM64 계열 macOS 지원)	|
		
- Cauly SDK 샘플 프로젝트

  - Objective-C Project
  - Swift Project
	
## SDK 설치 방법
### 준비

#### 1. Cocoapods 사용하여 설치
> 1. 프로젝트 디렉토리에서 Podfile을 열고 Cauly SDK를 추가합니다.  
> 2. `pod install --repo-update` 명령을 통해 다운로드 받도록 합니다.  
> 3. 라이브러리 다운로드가 완료되면 Xcode 로 *.xcworkspace 파일을 열어 다음 과정으로 진행합니다.  


``` bash
source 'https://github.com/cauly/CaulySDK_iOS.git'
pod 'CaulySDK', '3.1.22'
```


#### 2. 수동 설치
1. Cauly SDK 추가
	- 아래 항목 중 하나의 방법으로 SDK 추가
		1. Cauly SDK 를 적용할 프로젝트 내에 ‘CaulyLib’ 폴더 복사 (CaulySDK.xcframework 파일 제외)
		2. CaulySDK.xcframework 추가 (ARM64 계열`M1, M2` macOS 지원)
			- Embed & Sign 설정
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
3. Import Header (CaulySDK.xcframework 파일 제외한 ‘CaulyLib’ 폴더 복사 방법으로 진행하는 경우에만 진행)
- Bridging-Header.h 파일을 생성하고 아래 사진과 같이 해더파일을 생성해야합니다.
	
<p float="left">
<img src="/Cauly3.1/Swift/images/hearder.png" width="800" hight="700" />
</p>

- Build Settings -> 검색바에서 -> Swift Compiler -> Objective-C Bridging Heaer 프로젝트명-Bridging-Header.h 등록
<p float="left">
<img src="/Cauly3.1/Swift/images/target.png" width="800" hight="1000"/>
</p>


#### Cocoapods 설치 또는 CaulySDK.xcframework 수동 설치 방법으로 진행하는 경우  
- 해당 SDK에 Privacy Manifest, Code Signature 가 포함되어있습니다.
- CaulySDK 호출
``` swift
import CaulySDK
```


### 구현 

#### Ad Settings
- SKAdNetwork 를 지원하게 되면서 아래 초기화 부분에서 반드시 caulySetting?.appId 로 App Store 의 App ID 정보를 입력해주셔야 합니다.
- 만약, 아직 출시 전 앱인 경우는 0 으로 지정할 수는 있으나 App Store 에 등록된 앱인 경우에는 반드시 입력해야 합니다.
- 추가적으로, 기존에는 로그 레벨이 CaulyLogLevelRelease 였으나 CaulyLogLevelInfo 로 변경되었습니다.
```swift
{
   // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
   let caulySetting = CaulyAdSetting.global();
   CaulyAdSetting.setLogLevel(CaulyLogLevelInfo)//  Cauly Log 레벨
   caulySetting?.appId = "1234567"                 //  App Store 에 등록된 App ID 정보 (필수)
   caulySetting?.appCode = "CAULY"                 //  Cauly 로부터 발급 받은 ID 입력
   caulySetting?.animType = CaulyAnimNone          //  화면 전환 효과     
   caulySetting?.closeOnLanding = true             //  App 으로 이동할 때 webview popup 창을 자동으로 닫아줍니다. 기본값은 false입니다.     
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

| 속성                   | 설명                                                                                                                                                                                                                                                             |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appCode              | Cauly 로부터 부여 받은 매체 식별자                                                                                                                                                                                                                                         |
| animType             | 광고 교체 애니메이션 효과<br/>CaulyAnimNone (기본값) : 효과 없음<br/>CaulyAnumCurlDown : 아래쪽으로 말려 내려가는 효과<br/>CaulyAnumCurlUp : 위쪽으로 말려 올라가는 효과<br/>CaulyAnimFadeOut : 서서히 사라지는 효과<br/>CaulyAnimFlipFromLeft : 왼쪽에서 회전하며 나타나는 효과<br/>CaulyAnimFlipFromRight : 오른쪽에서 회전하며 나타나는 효과 |
| adSize               | CaulyAdSize_IPhone : 320 x 50<br/>CaulyAdSize_IPhoneLarge : 320 x 100<br/>CaulyAdSize_IPhoneMediumRect : 300 x 250<br/>CaulyAdSize_IPadLarge : 728 x 90<br/>CaulyAdSize_IPadSmall : 468 x 60                                                                                                                                                        |
| reloadTime           | CaulyReloadTime_30 (기본값) : 30초<br/>CaulyReloadTime_60 : 60초<br/>CaulyReloadTime_120 : 120초                                                                                                                                                                     |
| useDynamicReloadTime | YES (기본값) : 광고에 따라 노출 주기 조정할 수 있도록 하여 광고 수익 상승 효과 기대<br/>NO : 설정 시 reloadTime 설정 값으로 Rolling                                                                                                                                                                   |

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
###### 배너 광고
```swift
// 배너광고 성공
- func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool)

// 배너광고 실패
- func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!)

// 랜딩 화면 표시
- func willShowLanding(_ adView: CaulyAdView!)

// 랜딩 화면이 닫혔을 때
- func didCloseLanding(_ adView: CaulyAdView!)
```

###### 전면 광고
```swift
// 전면광고 성공
- func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool)

// 전면광고 실패
- func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!)

// Interstitial 형태의 광고가 보여지기 직전
- func willShow(_ interstitialAd: CaulyInterstitialAd!)

// Interstitial 형태의 광고가 닫혔을 때
- func didClose(_ interstitialAd: CaulyInterstitialAd!)
```

### 기타 API

###### 배너 광고
```swift
// 배너광고 객체 생성 클래스 메소드
+ (id)caulyAdViewWithController:(UIViewController *)controller;

// 배너광고 객체 생성 인스턴스 메소드
- (id)initWithParentViewController:(UIViewController *)controller;

// 배너광고 요청
- (void)startBannerAdRequest;

// 배너광고 요청 중지
- (void)stopAdRequest;
```

###### 전면 광고
```swift
// 전면광고 객체 생성 클래스 메소드
+ (id)caulyAdWithController:(UIViewController *)controller;

// 전면광고 객체 생성 인스턴스 메소드
- (id)initWithParentViewController:(UIViewController *)controller;

// 전면광고 요청
- (void)startInterstitialAdRequest;

// 전면광고 요청 중지
- (void)stopAdRequest;
```

### Properties
###### 배너 광고
```swift
// CaulyAdViewDelegate 프로토콜을 구현한 delegate 객체
delegate

// CaulyAdSetting 세팅된 객체 설정
localSetting

// parentViewController 객체
parentController

// 배너광고 에러 메시지
errorMsg

// PE 광고 허용 여부
showPreExpandableAd
```

###### 전면 광고
```swift
// CaulyInterstitialAdDelegate 프로토콜을 구현한 delegate 객체
delegate

// CaulyAdSetting 세팅된 객체 설정
localSetting

// parentViewController 객체
parentController

// 전면광고 에러 메시지
errorMsg
```
