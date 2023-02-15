iOS SDK mediation 연동 가이드
=====================================================

목차 

1. [문서 개요](#1-문서-개요)
2. [미디에이션 시작하기](#2-미디에이션-시작하기)
	- [사전 안내](#사전-안내)
	- [광고 SDK 가져오기](#광고-sdk-가져오기)
	- [Info.plist 업데이트](#inpoplist-업데이트)
	- [광고 SDK 초기화](#광고-sdk-초기화)
	- [테스트 광고 사용 설정](#테스트-광고-사용-설정)
3. [광고 형식 추가하기](#3-광고-형식-추가하기)
	- [배너 광고 추가하기](#배너-광고-추가하기)
	- [전면 광고 추가하기](#전면-광고-추가하기)
	- [보상형 광고 추가하기](#보상형-광고-추가하기)
4. [커스텀 이벤트 네트워크 추가하기](#4-커스텀-이벤트-네트워크-추가하기)
	- [Cauly 광고 추가하기](#cauly-광고-추가하기)
      - [어댑터 초기화](#어댑터-초기화)
      - [Cauly 배너 광고 추가하기](#cauly-배너-광고-추가하기)
      - [Cauly 전면 광고 추가하기](#cauly-전면-광고-추가하기)

- - - 

## 1. 문서 개요

> 이 문서는 iOS 플랫폼에서 AdMob 기반 미디에이션 연동을 하기 위해 작성된 가이드로  
> 기본적으로는 [AdMob 연동 가이드](https://developers.google.com/admob/ios/quick-start?hl=ko) 와 [AdMob 연동 샘플](https://github.com/googleads/googleads-mobile-ios-mediation) 을 기반으로 작성되어 있으며  
> 혹여 이 문서에서 설명되지 않은 사항들은 해당 참조 링크에서 확인해주십시오.

## 2. 미디에이션 시작하기

### 사전 안내

> [AdMob 연동 가이드](https://developers.google.com/admob/ios/quick-start?hl=ko) 에 안내되었고, 이 샘플이 [AdMob 연동 샘플](https://github.com/googleads/googleads-mobile-ios-mediation) 에 기반하였으므로  
> 이 문서에도 [CocoaPods](https://cocoapods.org/) 를 사용한 라이브러리 Dependency 관리를 합니다.  
> CocoaPods 가 설치되어 있지 않다면 [여기](https://guides.cocoapods.org/using/getting-started) 를 방문하여 설치 및 환경 구성을 진행해주십시오.  

### 광고 SDK 가져오기
> 1. 프로젝트 디렉토리에서 Podfile을 열고 필요로 하는 라이브러리를 추가합니다.  
> 2. `pod install --repo-update` 명령을 통해 다운로드 받도록 합니다.  
> 3. 라이브러리 다운로드가 완료되면 Xcode 로 *.xcworkspace 파일을 열어 다음 과정으로 진행합니다.  

- Admob SDK
``` bash
pod 'Google-Mobile-Ads-SDK'
```

- Inmobi SDK
``` bash
pod 'GoogleMobileAdsMediationInMobi'
```

- AppLovin SDK
``` bash
pod 'GoogleMobileAdsMediationAppLovin'
```

- Vungle SDK
``` bash
pod 'GoogleMobileAdsMediationVungle'
```

- DT Exchange
``` bash
pod 'GoogleMobileAdsMediationFyber'
```


### Inpo.plist 업데이트

#### Admob 연결
``` xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxx</string>
```

#### SKAdNetwork 지원
- Info.plist 파일에 SKAdNetworkItems 키를 추가하고 Cauly (55644vm79v.skadnetwork), Google(cstr6suwn9.skadnetwork) SKAdNetworkIdentifier 값과 함께 Cauly 의 파트너 DSP 와 Google Third-Party SKAdNetworkIdentifier 값을 추가합니다.  
- 즉, Info.plist 파일에 아래 내용을 추가해주시면 Cauly 와 Cauly 를 통한 다른 DSP, Google 의 광고가 정상적으로 처리될 수 있습니다.

``` xml
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
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
      <string>2fnua5tdw4.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ydx93a7ass.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>5a6flpkh64.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>p78axxw29g.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>v72qych5uu.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ludvb6z3bs.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cp8zw746q7.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>c6k4g5qg8m.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>s39g8k73mm.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>3qy4746246.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>3sh42y64q3.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>f38h382jlk.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>hs6bdukanm.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>prcb7njmu6.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>v4nxqhlyqp.skadnetwork</string>
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
      <string>t38b2kh725.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>7ug5zh24hu.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9rd848q2bz.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>y5ghdn5j9k.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>n6fk4nfna4.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>v9wttpbfk9.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>n38lu8286q.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>47vhws6wlr.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>kbd757ywx3.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9t245vhmpl.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>a2p9lx4jpn.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>22mmun2rn5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>4468km3ulz.skadnetwork</string>
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
      <string>av6w8kgt66.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>klf5c3l5u5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ppxm28t8ap.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>424m5254lk.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ecpz2srf59.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>uw77j35x4d.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>mlmmfzh3r3.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>578prtvx9j.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>4dzt52r2t5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>gta9lk7p23.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>e5fvkxwrpn.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>8c4e2ghe7u.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>zq492l623r.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>3rd42ekr43.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>3qcr597p9d.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>55644vm79v.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>6xzpu9s2p8.skadnetwork</string>
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
      <string>54nzkqm89y.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>feyaarzu9v.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>275upjj5gd.skadnetwork</string>
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
      <string>74b6s63p6l.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>gvmwg8q7h5.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>32z4fx6l9h.skadnetwork</string>
    </dict>
  </array>
```

#### iOS9 ATS(App Transport Security) 처리  
- 애플은 iOS9 에서 ATS(App Transport Security)라는 기능을 제공합니다. 기기에서 ATS 활성화 시 암호화된 HTTPS 방식만 허용됩니다. HTTPS 방식을 적용하지 않을 경우 애플 보안 기준을 충족하지 않는다는 이유로 광고가 차단될 수 있습니다.  
- 모든 광고가 HTTPS 방식으로 호출되지 않으므로, info.plist 파일에 아래 설정을 적용하여 사용 부탁 드립니다.  
- 2017년 1월 이후 ATS를 활성화한 앱에 대해서만 앱스토어에 등록할 수 있도록한 애플 정책이 수립되었습니다. 따라서 기존 설정과 함께 추가적인 설정을 추가하여야 합니다.  
	
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```


### 광고 SDK 초기화
- `AppDelegate` 에서 `startWithCompletionHandler:` 메서드를 호출합니다.  
- 미디에이션을 사용하는 경우 광고를 로드하기 전에 완료 핸들러를 호출할 때까지 기다려야 모든 미디에이션 어댑터가 초기화 됩니다.

``` objectivec
@import GoogleMobileAds;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    GADMobileAds *ads = [GADMobileAds sharedInstance];
    [ads startWithCompletionHandler:^(GADInitializationStatus *status) {
        // Optional: Log each adapter's initialization latency.
        NSDictionary *adapterStatuses = [status adapterStatusesByClassName];
        for (NSString *adapter in adapterStatuses) {
          GADAdapterStatus *adapterStatus = adapterStatuses[adapter];
          NSLog(@"Adapter Name: %@, Description: %@, Latency: %f", adapter,
                adapterStatus.description, adapterStatus.latency);
        }

        // Start loading ads here...

      }];
    return YES;
}
```

### 테스트 광고 사용 설정
> `상용화 시 반드시 테스트 광고 설정 관련 코드를 삭제해야 합니다.`

#### 프로그래밍 방식으로 테스트 장치 추가

- 광고를 요청한 후 콘솔에서 테스트 기기 ID를 복사합니다.
``` clojure
<Google> To get test ads on this device, set:
GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
@[ @"2077ef9a63d2b398840261c8221a0c9b" ];
```

- `testDeviceIdentifiers` 를 통해 테스트 기기 ID를 설정하도록 코드를 수정합니다.
``` objectivec
GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
    @[ @"2077ef9a63d2b398840261c8221a0c9b"  ]; // Sample device ID
```

#### 미디에이션 테스트 모음 실행
-  프로젝트 디렉토리에서 Podfile을 열고 다음 라이브러리를 추가한 후 `pod install --repo-update` 명령을 통해 다운로드 받도록 합니다.
``` bash
pod 'GoogleMobileAdsMediationTestSuite'
```

- 도구를 표시하기 위해 프레임워크를 가져옵니다.
``` objectivec
@import GoogleMobileAdsMediationTestSuite;
```

- 뷰가 표시된 후 다음과 같이 테스트 모음을 표시합니다.
``` objectivec
[GoogleMobileAdsMediationTestSuite presentOnViewController:self delegate:nil];
```

## 3. 광고 형식 추가하기
### 배너 광고 추가하기
- rootViewController : 광고 클릭이 발생할 때 오버레이를 표시하는 데 사용되는 보기 컨트롤러입니다. 일반적으로 GADBannerView 를 포함하는 보기 컨트롤러로 설정해야 합니다.
- adUnitID : GADBannerView 가 광고를 로드하는 광고 단위 ID입니다.

``` objectivec
@import GoogleMobileAds;

@interface ViewController () <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.adUnitID = @"ca-app-pub-xxxxxxxxxx";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
}

// 배너 광고 요청
- (IBAction)bannerAdRequest:(id)sender {
    [self.bannerView loadRequest:[GADRequest request]];
    NSLog(@"%@", self.bannerView.responseInfo.description);
}

#pragma - Admob Banner delegates

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
}
```


### 전면 광고 추가하기
- 전면 광고는 loadWithAdUnitID:request:completionHandler: 메서드를 사용하여 로드됩니다.
- 로드 메서드에는 광고 단위 ID, GADRequest 객체, 광고 로드에 성공하거나 실패할 때 호출되는 완료 핸들러가 필요합니다.

``` objectivec
@import GoogleMobileAds;
@import UIKit;

@interface ViewController () <GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitialAd *interstitialAd;

@end

@implementation ViewController

- (IBAction)interstitialAdRequest:(id)sender {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-xxxxxxxxxx"
                                  request:request
                        completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
        self.interstitialAd = ad;
        self.interstitialAd.fullScreenContentDelegate = self;
        
        GADResponseInfo *responseInfo = self.interstitialAd.responseInfo;
        NSLog(@"%@", responseInfo.description);
        
        if (self.interstitialAd) {
            [self.interstitialAd presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
      }];
}

#pragma - Admob Interstitial delegates

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad will present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
}

```

### 보상형 광고 추가하기
- 보상형 광고는 loadWithAdUnitID:request:completionHandler: 메서드를 사용하여 로드됩니다.
- 로드 메서드에는 광고 단위 ID, GADRequest 객체, 광고 로드에 성공하거나 실패할 때 호출되는 완료 핸들러가 필요합니다.

``` objectivec
@import GoogleMobileAds;
@import UIKit;

@interface ViewController () <GADFullScreenContentDelegate>

@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation ViewController

// 보상형 광고 요청
- (void)loadRewardedAd {
    GADRequest *request = [GADRequest request];
    [GADRewardedAd
           loadWithAdUnitID:@"ca-app-pub-8713069554470817/6844780809"
                    request:request
          completionHandler:^(GADRewardedAd *ad, NSError *error) {
            if (error) {
              NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
              return;
            }
            self.rewardedAd = ad;
        
        GADResponseInfo *responseInfo = self.rewardedAd.responseInfo;
        NSLog(@"%@", responseInfo.description);
            NSLog(@"Rewarded ad loaded.");
        [self showRewardedAd];
          }];
}

// 보상형 광고 노출 및 리워드 이벤트 처리
- (void)showRewardedAd {
    if (self.rewardedAd) {
        [self.rewardedAd presentFromRootViewController:self
                                      userDidEarnRewardHandler:^{
                                      GADAdReward *reward =
                                          self.rewardedAd.adReward;
                                      // TODO: Reward the user!
            NSLog(@"rewardedAd");
                                    }];
      } else {
        NSLog(@"Ad wasn't ready");
      }
}

#pragma - Admob rewarded delegates

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad will present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
}
```

## 4. 커스텀 이벤트 네트워크 추가하기
### Cauly 광고 추가하기

#### 권장 환경
- Xcode 13.2.1 이상 사용
- iOS 10.0 이상 타겟팅

#### SDK 구성
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
		
	
#### SDK 설치 방법
1. Cauly SDK 를 적용할 프로젝트 내에 ‘CaulyLib’ 폴더 복사
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


### 어댑터 초기화

- CaulyEvent.h
``` objectivec
#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyAdView.h"
@import GoogleMobileAds;

@interface CaulyEvent : NSObject <GADMediationAdapter> {
    CaulyAdView *adView;
}

@end

```

- CaulyEvent.m
``` objectivec
#import "CaulyEvent.h"
#import "CaulyEventBanner.h"
#import "CaulyEventInterstitial.h"

@implementation CaulyEvent {
    CaulyEventBanner *caulyBanner;
    
    CaulyEventInterstitial *caulyInterstitial;
}


+ (GADVersionNumber)adSDKVersion {
    NSArray *versionComponents = [CAULY_SDK_VERSION componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count >= 3) {
      version.majorVersion = [versionComponents[0] integerValue];
      version.minorVersion = [versionComponents[1] integerValue];
      version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)adapterVersion {
    NSString *adapterVersion = @"1.0.0.0";
    NSArray *versionComponents = [adapterVersion componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 4) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion =
        [versionComponents[2] integerValue] * 100 + [versionComponents[3] integerValue];
    }
    return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}


+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {// This is where you you will initialize the SDK that this custom event is built for.
    // Upon finishing the SDK initialization, call the completion handler with success.
    completionHandler(nil);
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    caulyBanner = [[CaulyEventBanner alloc] init];
    [caulyBanner loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialForAdConfiguration:
            (GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:
                             (GADMediationInterstitialLoadCompletionHandler)completionHandler {
    caulyInterstitial = [[CaulyEventInterstitial alloc] init];
    [caulyInterstitial loadInterstitialForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

@end

```


### Cauly 배너 광고 추가하기
> - SKAdNetwork 를 지원하게 되면서 아래 초기화 부분에서 반드시 adSetting.appId 로 App Store 의 App ID 정보를 입력해주셔야 합니다.
> - 만약, 아직 출시 전 앱인 경우는 0 으로 지정할 수는 있으나 App Store 에 등록된 앱인 경우에는 반드시 입력해야 합니다.
- CaulyEventBanner.h

``` objectivec
#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyAdView.h"
@import GoogleMobileAds;


@interface CaulyEventBanner : NSObject <CaulyAdViewDelegate, GADMediationBannerAd> {
    CaulyAdView *adView;
    
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationBannerLoadCompletionHandler _loadCompletionHandler;

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id<GADMediationBannerAdEventDelegate> _adEventDelegate;
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler;
@end

```

- CaulyEventBanner.m

``` objectivec
#import "CaulyEventBanner.h"

@implementation CaulyEventBanner

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
        _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {

      id<GADMediationBannerAdEventDelegate> delegate = nil;
      if (originalCompletionHandler) {
        // Call original handler and hold on to its return value.
        delegate = originalCompletionHandler(ad, error);
      }

      // Release reference to handler. Objects retained by the handler will also be released.
      originalCompletionHandler = nil;

      return delegate;
    };
    
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    NSLog(@"paramater : %@", adUnit);
    
    // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelInfo];  // Cauly Log 레벨
    adSetting.appId = @"1234567";           //  App Store 에 등록된 App ID 정보 (필수)
    adSetting.appCode = adUnit;
    adSetting.animType = CaulyAnimNone;   //  화면 전환 효과	
    
	// app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 NO입니다.
    adSetting.closeOnLanding = YES;
    
    UIViewController *controller = [adConfiguration topViewController];
    adView = [[CaulyAdView alloc] initWithParentViewController:controller];
    [controller.view addSubview:adView];
    
    adView.delegate = self;
    [adView startBannerAdRequest];
}

#pragma mark GADMediationBannerAd implementation

- (nonnull UIView *)view {
    return adView;
}

#pragma - CaulyAdViewDelegate
-(void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"didReceiveAd");
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    _adEventDelegate = _loadCompletionHandler(nil, error);
}


@end

```


### Cauly 전면 광고 추가하기
- CaulyEventInterstitial.h
``` objectivec
#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyInterstitialAd.h"
@import GoogleMobileAds;


@interface CaulyEventInterstitial : NSObject <CaulyInterstitialAdDelegate, GADMediationInterstitialAd> {
    CaulyInterstitialAd *_interstitialAd;
//    UIViewController *viewController;
    
    GADMediationInterstitialLoadCompletionHandler _loadCompletionHandler;
    id<GADMediationInterstitialAdEventDelegate> _adEventDelegate;
}
- (void)loadInterstitialForAdConfiguration:
            (GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:
                             (GADMediationInterstitialLoadCompletionHandler)completionHandler;
@end

```

- CaulyEventInterstitial.m
``` objectivec
#import "CaulyEventInterstitial.h"

@implementation CaulyEventInterstitial

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(_Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
        }
        
        originalCompletionHandler = nil;
        
        return delegate;
    };
    
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    NSLog(@"paramater : %@", adUnit);

    // 상세 설정 항목들은 하단 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelInfo];  // Cauly Log 레벨
    adSetting.appId = @"1234567";           //  App Store 에 등록된 App ID 정보 (필수)
    adSetting.appCode = adUnit;
    adSetting.animType = CaulyAnimNone;   //  화면 전환 효과	
    
	// app으로 이동할 때 webview popup창을 자동으로 닫아줍니다. 기본값은 NO입니다.
    adSetting.closeOnLanding = YES;
    
//    viewController = [adConfiguration topViewController];
    _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:[adConfiguration topViewController]];
    _interstitialAd.delegate = self;
    [_interstitialAd startInterstitialAdRequest];
}

#pragma mark - GADMediationInterstitialAd implementation

- (void)presentFromViewController:(UIViewController *)viewController {
    [_interstitialAd showWithParentViewController:viewController];
}

#pragma mark - CaulyInterstitialAdDelegate

- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
//    [_interstitialAd show];
//    [_interstitialAd showWithParentViewController:viewController];
    NSLog(@"cauly interstitial ad Show");
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"did Close Interstitial ad");
    _interstitialAd = nil;
}

- (void) willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"will Show Interstitial ad");
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate reportImpression];
}

- (void) didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    _interstitialAd = nil;
    NSLog(@"fail interstitial ad");
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

@end

```

[설정 방법]

| 속성                   | 설명                                                                                                                                                                                                                                                             |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appCode              | Cauly 로부터 부여 받은 매체 식별자                                                                                                                                                                                                                                         |
| animType             | 광고 교체 애니메이션 효과<br/>CaulyAnimNone (기본값) : 효과 없음<br/>CaulyAnumCurlDown : 아래쪽으로 말려 내려가는 효과<br/>CaulyAnumCurlUp : 위쪽으로 말려 올라가는 효과<br/>CaulyAnimFadeOut : 서서히 사라지는 효과<br/>CaulyAnimFlipFromLeft : 왼쪽에서 회전하며 나타나는 효과<br/>CaulyAnimFlipFromRight : 오른쪽에서 회전하며 나타나는 효과 |
| adSize               | CaulyAdSize_IPhone : 320 x 48<br/>CaulyAdSize_IPadLarge : 728 x 90<br/>CaulyAdSize_IPadSmall : 468 x 60                                                                                                                                                        |
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


