iOS SDK mediation 연동 가이드
=====================================================

목차 

1. [문서 개요](#1-문서-개요)
2. [미디에이션 시작하기](#2-미디에이션-시작하기)
	- [사전 안내](#사전-안내)
	- [광고 SDK 가져오기](#광고-sdk-가져오기)
	- [Info.plist 업데이트](#infoplist-업데이트)
	- [광고 SDK 초기화](#광고-sdk-초기화)
	- [파트너 통합 네트워크 설정](#파트너-통합-네트워크-설정)
	- [테스트 광고 사용 설정](#테스트-광고-사용-설정)
3. [광고 형식 추가하기](#3-광고-형식-추가하기)
	- [배너 광고 추가하기](#배너-광고-추가하기)
	- [전면 광고 추가하기](#전면-광고-추가하기)
	- [보상형 광고 추가하기](#보상형-광고-추가하기)
	- [네이티브 광고 추가하기](#네이티브-광고-추가하기)
4. [커스텀 이벤트 네트워크 추가하기](#4-커스텀-이벤트-네트워크-추가하기)
	- [Cauly 광고 추가하기](#cauly-광고-추가하기)
		- [어댑터 초기화](#어댑터-초기화)
		- [Cauly 배너 광고 추가하기](#cauly-배너-광고-추가하기)
		- [Cauly 전면 광고 추가하기](#cauly-전면-광고-추가하기)
		- [Cauly 네이티브 광고 추가하기](#cauly-네이티브-광고-추가하기)
5. [TestFlight에 배포하기](#5-testflight에-배포하기)
	- [앱 빌드 정보 및 환경 설정](#앱-빌드-정보-및-환경-설정)
	- [iOS 앱 TestFlight에 업로드](#ios-앱-testflight-에-업로드)
	- [TestFlight 외부 테스터 추가하기](#testflight-외부-테스터-추가하기)

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

#### Admob SDK
``` bash
pod 'Google-Mobile-Ads-SDK'
```

#### Inmobi SDK
``` bash
pod 'GoogleMobileAdsMediationInMobi'
```

#### AppLovin SDK
``` bash
pod 'GoogleMobileAdsMediationAppLovin'
```

#### Vungle SDK
``` bash
pod 'GoogleMobileAdsMediationVungle'
```

#### DT Exchange
``` bash
pod 'GoogleMobileAdsMediationFyber'
```

#### Mintegral
``` bash
pod 'GoogleMobileAdsMediationMintegral'
```

#### Pangle
``` bash
pod 'GoogleMobileAdsMediationPangle'
```

#### Unity Ads
``` bash
pod 'GoogleMobileAdsMediationUnity'
```


### Info.plist 업데이트

#### Admob 연결
``` xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxx</string>
```

#### SKAdNetwork 지원
- Info.plist 파일에 SKAdNetworkItems 키를 추가하고 Cauly (55644vm79v.skadnetwork), Google(cstr6suwn9.skadnetwork) SKAdNetworkIdentifier 값과 함께 Cauly 의 파트너 DSP 와 Google Third-Party SKAdNetworkIdentifier, Admob 파트너 네트워크 SKAdNetworkIdentifier 값을 추가합니다.  
- 즉, Info.plist 파일에 아래 내용을 추가해주시면 Cauly 와 Cauly 를 통한 다른 DSP, Google Admob Mediation 의 광고가 정상적으로 처리될 수 있습니다.

<details>
	<summary>Cauly SKAdNetworkItems</summary>

``` xml
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
</details>

<details>
	<summary>Google Admob SKAdNetworkItems</summary>

``` xml
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
  <string>3sh42y64q3.skadnetwork</string>
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
  <string>f38h382jlk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hs6bdukanm.skadnetwork</string>
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
  <string>gta9lk7p23.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>vutu7akeur.skadnetwork</string>
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
  <string>eh6m2bh4zr.skadnetwork</string>
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
  <string>klf5c3l5u5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ppxm28t8ap.skadnetwork</string>
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
  <string>pwa73g5rt2.skadnetwork</string>
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
```
</details>

<details>
	<summary>Inmobi SKAdNetworkItems</summary>

``` xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4fzdc2evr5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ggvn48r87g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wzmmz9fp6w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3sh42y64q3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>yclnxrl5pm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f73kdq92p3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>w9q455wk68.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>tl55sbb4fm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4pfyvq9l8r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5l3tpt7t6e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7rz58n8ntl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>klf5c3l5u5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cg4yq2srnc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>av6w8kgt66.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>v72qych5uu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>2u9pt9hc89.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>p78axxw29g.skadnetwork</string>
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
  <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9nlqeag3gk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cj5566h2ga.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mtkv5xtk9e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>g28c52eehv.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>2fnua5tdw4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>97r2b46745.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>glqzh8vgby.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3qcr597p9d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>b9bk5wbcq9.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbmxgpxpgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>523jb4fst2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mls7yz5dvl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>74b6s63p6l.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>52fl2v3hgk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>6g9af3uyq4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>x5l83yy675.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c3frkrj4fj.skadnetwork</string>
</dict>
```
</details>

<details>
	<summary>AppLovin SKAdNetworkItems</summary>

``` xml
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>22mmun2rn5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>238da6jt44.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>24t9a8vw3c.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>24zw6aqk47.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>252b5q8x7y.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>275upjj5gd.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>2fnua5tdw4.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>2u9pt9hc89.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>32z4fx6l9h.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>3l6bd9hu43.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>3qcr597p9d.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>3qy4746246.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>3sh42y64q3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>424m5254lk.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>44n7hlldy6.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>47vhws6wlr.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>488r3q3dtq.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4dzt52r2t5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4fzdc2evr5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4mn522wn87.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4pfyvq9l8r.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4w7y6s5ca2.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>523jb4fst2.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>52fl2v3hgk.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>54nzkqm89y.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>5l3tpt7t6e.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>5tjdwbrq8w.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>6964rsfnh4.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>6g9af3uyq4.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>6p4ks3rnbw.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>6v7lgmsu45.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>6xzpu9s2p8.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>737z793b9f.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>74b6s63p6l.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>79pbpufp6p.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>7fmhfwg9en.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>7rz58n8ntl.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>84993kbrcf.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>89z7zv988g.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>8c4e2ghe7u.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>8m87ys6875.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>8r8llnkz5a.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>97r2b46745.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9b89h5y424.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9nlqeag3gk.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9vvzujtq5s.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9yg77x724h.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>a2p9lx4jpn.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>a7xqa6mtl2.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>a8cz6cu7e5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>av6w8kgt66.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>b9bk5wbcq9.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>bxvub5ada5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>c3frkrj4fj.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cg4yq2srnc.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cj5566h2ga.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cp8zw746q7.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cs644xg564.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>dbu4b84rxf.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>dkc879ngq3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>dzg6xy7pwj.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ecpz2srf59.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>eh6m2bh4zr.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ejvt5qm6ak.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>f38h382jlk.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>f73kdq92p3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>f7s53z58qe.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>feyaarzu9v.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>g28c52eehv.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>g2y4y55b64.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ggvn48r87g.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>glqzh8vgby.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>gta8lk7p23.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>gta9lk7p23.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>hb56zgv37p.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>hdw39hrw9y.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>kbmxgpxpgc.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>klf5c3l5u5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>krvm3zuq6h.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>lr83yxwka7.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ludvb6z3bs.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>m297p6643m.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>m5mvw97r93.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>m8dbw4sv7c.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>mls7yz5dvl.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>mp6xlyr22a.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>mtkv5xtk9e.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>n38lu8286q.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>n66cz3y3bx.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>n9x2a789qt.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>nzq8sh4pbs.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>p78axxw29g.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ppxm28t8ap.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>pwdxu55a5a.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>qqp299437r.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>r45fhb6rf7.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>rvh3l7un93.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>rx5hdcabgc.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>s39g8k73mm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>s69wq72ugq.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>su67r6k2v3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>tl55sbb4fm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>u679fj5vs4.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>v4nxqhlyqp.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>v72qych5uu.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>v79kvwwj4g.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>v9wttpbfk9.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>vcra2ehyfk.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>vutu7akeur.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>w9q455wk68.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>wzmmz9fp6w.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>x44k69ngh6.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>x5l83yy675.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>x8jxxk4ff5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>x8uqf25wch.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>xy9t38ct57.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>y45688jllp.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>y5ghdn5j9k.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>yclnxrl5pm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>zmvfpc5aq8.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>zq492l623r.skadnetwork</string>
</dict>
```
</details>

<details>
	<summary>Vungle SKAdNetworkItems</summary>

``` xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>gta9lk7p23.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c3frkrj4fj.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>p78axxw29g.skadnetwork</string>
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
  <string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cg4yq2srnc.skadnetwork</string>
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
  <string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>g28c52eehv.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>523jb4fst2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ggvn48r87g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mls7yz5dvl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
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
  <string>24t9a8vw3c.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>x44k69ngh6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mp6xlyr22a.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>m8dbw4sv7c.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9nlqeag3gk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cj5566h2ga.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9b89h5y424.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ejvt5qm6ak.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>w9q455wk68.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wzmmz9fp6w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7fmhfwg9en.skadnetwork</string>
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
  <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zmvfpc5aq8.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mtkv5xtk9e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7rz58n8ntl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>feyaarzu9v.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7953jerfzd.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n9x2a789qt.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
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
  <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>glqzh8vgby.skadnetwork</string>
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
  <string>xy9t38ct57.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>424m5254lk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>qu637u8glc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbmxgpxpgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5l3tpt7t6e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f7s53z58qe.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>54nzkqm89y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9yg77x724h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n66cz3y3bx.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>tl55sbb4fm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5tjdwbrq8w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>r45fhb6rf7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>32z4fx6l9h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3rd42ekr43.skadnetwork</string>
</dict>
```
</details>

<details>
	<summary>DT Exchange SKAdNetworkItems</summary>

``` xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>krvm3zuq6h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbmxgpxpgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9nlqeag3gk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c3frkrj4fj.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mtkv5xtk9e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>a2p9lx4jpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>bmxgpxpgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>p78axxw29g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n9x2a789qt.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>424m5254lk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ggvn48r87g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>s39g8k73mm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>32z4fx6l9h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>rx5hdcabgc.skadnetwork</string>
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
  <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>v72qych5uu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>x8uqf25wch.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3qy4746246.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>252b5q8x7y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f38h382jlk.skadnetwork</string>
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
  <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>m8dbw4sv7c.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9g2aggbj52.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wzmmZ9fp6w.skadnetwork</string>
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
  <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ejvt5qm6ak.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7rz58n8ntl.skadnetwork</string>
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
  <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>tl55sbb4fm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>8s468mfl3y.skadnetwork</string>
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
  <string>av6w8kgt66.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>klf5c3l5u5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hdw39hrw9y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>y45688jllp.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>dzg6xy7pwj.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3sh42y64q3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ppxm28t8ap.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f73kdq92p3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5l3tpt7t6e.skadnetwork</string>
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
  <string>6g9af3uyq4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cg4yq2srnc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>g28c52eehv.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zq492l623r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
</dict>
```
</details>

<details>
	<summary>Mintegral SKAdNetworkItems</summary>

``` xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mls7yz5dvl.skadnetwork</string>
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
  <string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cg4yq2srnc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>p78axxw29g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>737z793b9f.skadnetwork</string>
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
  <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>523jb4fst2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ggvn48r87g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
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
  <string>24t9a8vw3c.skadnetwork</string>
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
  <string>m8dbw4sv7c.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9nlqeag3gk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cj5566h2ga.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>w9q455wk68.skadnetwork</string>
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
  <string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7rz58n8ntl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4w7y6s5ca2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>feyaarzu9v.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ejvt5qm6ak.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n9x2a789qt.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zmvfpc5aq8.skadnetwork</string>
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
  <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>glqzh8vgby.skadnetwork</string>
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
  <string>dzg6xy7pwj.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>y45688jllp.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hdw39hrw9y.skadnetwork</string>
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
  <string>5l3tpt7t6e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4dzt52r2t5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mtkv5xtk9e.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>gta9lk7p23.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5tjdwbrq8w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>g28c52eehv.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>su67r6k2v3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>rx5hdcabgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>2fnua5tdw4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>32z4fx6l9h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>xy9t38ct57.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>54nzkqm89y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9b89h5y424.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>pwa73g5rt2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>79pbpufp6p.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbmxgpxpgc.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>275upjj5gd.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>rvh3l7un93.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>qqp299437r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>74b6s63p6l.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>44n7hlldy6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>6p4ks3rnbw.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f73kdq92p3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>e5fvkxwrpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>97r2b46745.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3qcr597p9d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>n6fk4nfna4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>b9bk5wbcq9.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>84993kbrcf.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>24zw6aqk47.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>pwdxu55a5a.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cs644xg564.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>6964rsfnh4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9vvzujtq5s.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>a7xqa6mtl2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>r45fhb6rf7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c3frkrj4fj.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>6g9af3uyq4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>u679fj5vs4.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>V72QYCH5UU.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>g2y4y55b64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zq492l623r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>a8cz6cu7e5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>s39g8k73mm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>dbu4b84rxf.skadnetwork</string>
</dict>
```
</details>


<details><summary>Pangle SKAdNetworkItems</summary>
	
```xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>uw77j35x4d.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>a8cz6cu7e5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5tjdwbrq8w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>dbu4b84rxf.skadnetwork</string>
</dict>
```
</details>

<details>
	<summary>Unity Ads SKAdNetworkItems</summary>

``` xml
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>m8dbw4sv7c.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4w7y6s5ca2.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>424m5254lk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3rd42ekr43.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ppxm28t8ap.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>mp6xlyr22a.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>lr83yxwka7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>32z4fx6l9h.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>488r3q3dtq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9t245vhmpl.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4fzdc2evr5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>glqzh8vgby.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>9rd848q2bz.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5tjdwbrq8w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>v72qych5uu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>w9q455wk68.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>a2p9lx4jpn.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wzmmz9fp6w.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>x44k69ngh6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>tl55sbb4fm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>c6k4g5qg8m.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f38h382jlk.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>7ug5zh24hu.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zq492l623r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f73kdq92p3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>578prtvx9j.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>yclnxrl5pm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>ydx93a7ass.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>22mmun2rn5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5lm9lj6jb7.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>wg4vff78zm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4pfyvq9l8r.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>k674qkevps.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>s39g8k73mm.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>2u9pt9hc89.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>v79kvwwj4g.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>294l99pt4k.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>av6w8kgt66.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>f7s53z58qe.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>238da6jt44.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>44jx6755aq.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>5a6flpkh64.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3qy4746246.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>4dzt52r2t5.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>kbd757ywx3.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>zmvfpc5aq8.skadnetwork</string>
</dict>
<dict>
  <key>SKAdNetworkIdentifier</key>
  <string>3sh42y64q3.skadnetwork</string>
</dict>
```
</details>

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

#### iOS14 ATT(App Tracking Transparency) Framework 적용
- 애플은 iOS14 에서 ATT(App Tracking Transparency) Framework가 추가되었습니다.
- IDFA 식별자를 얻기 위해서는 `ATT Framework를 반드시 적용`해야 합니다.
- `info.plist`
```xml
<key> NSUserTrackingUsageDescription </key>
<string> 맞춤형 광고 제공을 위해 사용자의 데이터가 사용됩니다. </string>
```

- `ViewController.m`
```objectivec
if (@available(iOS 14, *)) {
  [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
      switch (status) {
          // 승인
          case ATTrackingManagerAuthorizationStatusAuthorized:
              break;
          // 거부
          case ATTrackingManagerAuthorizationStatusDenied:
              break;
          // 제한
          case ATTrackingManagerAuthorizationStatusRestricted:
              break;
          // 미결정
          default:
              break;
        }
      }];
}
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

### 파트너 통합 네트워크 설정
> 각 네트워크별 [SKAdNetworkItems](#skadnetwork-지원)를 info.plist에 반드시 추가해야 합니다.

#### Inmobi 설정 (옵션)
- Inmobi SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/inmobi#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### AppLovin 설정 (옵션)
- AppLovin SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/applovin#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Vungle 설정
- Vungle SDK 초기화를 위해 앱 내에서 사용될 모든 배치 목록을 SDK 로 전달해야 합니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/liftoff-monetize#optional_steps)를 참고하여 옵션 설정이 가능합니다.

``` objectivec
#import <VungleAdapter/VungleAdapter.h>
// ...

GADRequest *request = [GADRequest request];
VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];

NSMutableArray *placements = [[NSMutableArray alloc] initWithObjects:@"PLACEMENT_ID_1", @"PLACEMENT_ID_2", nil];
extras.allPlacements = placements;
[request registerAdNetworkExtras:extras];
```

#### DT Exchange 설정 (옵션)
- DT Exchange SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/dt-exchange#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Mintegral 설정 (옵션)
- Mintegral SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/mintegral#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Pangle 설정
- info.plist 파일의 SKAdNetworkItems 키에 [SKAdNetworkIdentifier 값](#skadnetwork-지원)을 추가해야합니다.


#### Unity Ads 설정 
- Swift 환경: Unity Ads SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- Objective-C 환경: Unity Ads adapter가 4.4.0.0 이상인 경우 [Unity 설명서](https://docs.unity.com/ads/en-us/manual/InstallingTheiOSSDK#Swift) 의 통합 단계를 따라야 합니다.
  - 프로젝트에서 이미 Swift를 사용하는 경우 추가 조치가 필요하지 않습니다.
  - 프로젝트에서 Swift를 사용하지 않는 경우 `File > New > Swift file` 을 선택하여 Xcode에서 빈 Swift 파일을 프로젝트에 추가합니다.
  - 프로젝트가 iOS 12.4 이전 버전을 대상으로 하는 경우 Xcode에서 `TARGETS > Build Settings > Always embed Swift standard libraries`를 `YES` 로 설정해야 합니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/unity#optional_steps)를 참고하여 옵션 설정이 가능합니다.


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
Podfile ::
pod 'GoogleMobileAdsMediationTestSuite'
```

- 도구를 표시하기 위해 프레임워크를 가져옵니다.
``` objectivec
ViewController.m ::
@import GoogleMobileAdsMediationTestSuite;
```

- 뷰가 표시된 후 다음과 같이 테스트 모음을 표시합니다.
``` objectivec
ViewController.m ::
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

#pragma mark - Banner Ad requset
// 배너 광고 요청
- (IBAction)bannerAdRequest:(id)sender {
    NSLog(@"##### bannerAdRequest");
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
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

#pragma mark - Interstitial Ad Request
// 전면 광고 요청
- (IBAction)interstitialAdRequest:(id)sender {
    NSLog(@"##### interstitialAdrequest");
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-xxxxxxxxxx"
                        request:request
                        completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            // 전면 광고 요청 실패
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitialAd = ad;
        self.interstitialAd.fullScreenContentDelegate = self;

        // 전면 광고 표시
        if (self.interstitialAd) {
            [self.interstitialAd presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    }];
}

#pragma mark - Admob Interstitial delegates

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

#pragma mark - Rewarded Ad Request
// 보상형 광고 요청
- (IBAction)rewardedAdRequest:(id)sender {
    NSLog(@"##### rewardedAdRequest");
    GADRequest *request = [GADRequest request];
    [GADRewardedAd
    loadWithAdUnitID:@"ca-app-pub-xxxxxxxxxx"
            request:request
            completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            // 리워드 광고 요청 실패
            NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
            return;
        }
        self.rewardedAd = ad;

        NSLog(@"Rewarded ad loaded.");
        [self showRewardedAd];
    }];
}

// 리워드 광고 표시 및 리워드 이벤트 처리
- (void)showRewardedAd {
    NSLog(@"##### showRewardedAd");
    if (self.rewardedAd) {
        [self.rewardedAd presentFromRootViewController:self
                userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardedAd.adReward;
            // TODO: Reward the user!
            NSLog(@"reward the user");
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

### 네이티브 광고 추가하기
- 광고를 요청하기 전에 `GADAdLoader` 를 초기화해야 합니다.
- AdLoader 에는 다음 옵션이 필요합니다.
  - 광고 단위 ID
  - adTypes : 배열을 전달하여 요청할 네이티브 형식을 지정할 상수
  - options : 매개변수에 사용할 수 있는 값은 [네이티브 광고 옵션 설정 페이지](https://developers.google.com/admob/ios/native/options?hl=ko)에서 확인할 수 있습니다.


``` objectivec
@import GoogleMobileAds;
@import UIKit;
#import "ExampleNativeAdView.h"

@interface ViewController () <GADNativeAdLoaderDelegate, GADNativeAdDelegate>

@property (strong, nonatomic) IBOutlet UIView *nativeAdPlaceholder;
@property (strong, nonatomic) GADAdLoader *adLoader;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation ViewController

#pragma mark - Native Ad Request
// 네이티브 광고 요청
- (IBAction)nativeAdRequest:(id)sender {
    NSLog(@"##### nativeAdRequest");
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];

    // 광고 로더 초기화
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-xxxxxxxxxx"
                                     rootViewController:self
                                                 adTypes:@[GADAdLoaderAdTypeNative]
                                                 options:@[videoOptions]];

    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)replaceNativeAdView:(UIView *)nativeAdView inPlaceholder:(UIView *)placeholder {
    // Remove anything currently in the placeholder.
    NSArray *currentSubviews = [placeholder.subviews copy];
    for (UIView *subview in currentSubviews) {
        [subview removeFromSuperview];
    }
    
    if (!nativeAdView) {
        return;
    }
    
    // Add new ad view and set constraints to fill its container.
    [placeholder addSubview:nativeAdView];
    [nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(nativeAdView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
}

#pragma mark - Admob Native delegates
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, nativeAd);
    
    // Create and place ad in view hierarchy.
    ExampleNativeAdView *nativeAdView =
        [[NSBundle mainBundle] loadNibNamed:@"ExampleNativeAdView" owner:nil options:nil]
            .firstObject;
    
    nativeAdView.nativeAd = nativeAd;
    UIView *placeholder = self.nativeAdPlaceholder;
    
    [self replaceNativeAdView:nativeAdView inPlaceholder:placeholder];
    
    nativeAdView.mediaView.contentMode = UIViewContentModeScaleAspectFit;
    nativeAdView.mediaView.hidden = NO;
    [nativeAdView.mediaView setMediaContent:nativeAd.mediaContent];
    // Populate the native ad view with the native ad assets.
    // Some assets are guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    [((UIButton *)nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // These assets are not guaranteed to be present, and should be checked first.
    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;

    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;

    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;

}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    NSLog(@"adLoaderDidFinishLoading");
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"didFailToReceiveAdWithError");
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
#import "CaulyEventNative.h"

@implementation CaulyEvent {
    CaulyEventBanner *caulyBanner;
    
    CaulyEventInterstitial *caulyInterstitial;

    CaulyEventNative *caulyNative;
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

#pragma mark - Cauly Banner Ad Request
- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    caulyBanner = [[CaulyEventBanner alloc] init];
    [caulyBanner loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

#pragma mark - Cauly Interstitial Ad Request
- (void)loadInterstitialForAdConfiguration:
            (GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:
                             (GADMediationInterstitialLoadCompletionHandler)completionHandler {
    caulyInterstitial = [[CaulyEventInterstitial alloc] init];
    [caulyInterstitial loadInterstitialForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

#pragma mark - Cauly Native Ad request
- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
  caulyNative = [[CaulyEventNative alloc] init];
  [caulyNative loadNativeAdForAdConfiguration:adConfiguration completionHandler:completionHandler];
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

#pragma mark - Banner Ad Request
- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
    
    // admob 대시보드 등록 parameter : cauly appCode
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    
    // 카울리 로그 레벨
    [CaulyAdSetting setLogLevel:CaulyLogLevelTrace];
    
    // iTunes App ID
    adSetting.appId = @"0";
    
    // 카울리 앱 코드
    adSetting.appCode = adUnit;
    
    // 광고 View 크기
    adSetting.adSize = CaulyAdSize_IPhone;
    
    // 화면 전환 효과
    adSetting.animType = CaulyAnimNone;
    
    // 광고 자동 갱신 시간 (기본값)
    adSetting.reloadTime = CaulyReloadTime_30;
    
    // 광고 자동 갱신 사용 여부 (기본값)
    adSetting.useDynamicReloadTime = YES;
    
    // 광고 랜딩 시 WebView 제거 여부
    adSetting.closeOnLanding = YES;
    
    UIViewController *controller = [adConfiguration topViewController];
    adView = [[CaulyAdView alloc] initWithParentViewController:controller];
    [controller.view addSubview:adView];
    
    adView.delegate = self;
    
    // 카울리 배너 광고 요청
    [adView startBannerAdRequest];
}

#pragma mark GADMediationBannerAd implementation

- (nonnull UIView *)view {
    return adView;
}

#pragma - CaulyAdViewDelegate
// 배너 광고 정보 수신 성공
-(void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"didReceiveAd");
    // admob에 광고 수신 성공 전달
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

// 배너 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    // admob에 광고 수신 실패 전달
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
    
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationInterstitialLoadCompletionHandler _loadCompletionHandler;
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
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

#pragma mark - Interstitial Ad Request
- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(_Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            // Call original handler and hold on to its return value.
            delegate = originalCompletionHandler(ad, error);
        }
        
        // Release reference to handler. Objects retained by the handler will also be released.
        originalCompletionHandler = nil;
        
        return delegate;
    };
    
    // admob 대시보드 등록 parameter : cauly appCode
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    
    // 카울리 로그 레벨
    [CaulyAdSetting setLogLevel:CaulyLogLevelTrace];
    
    // iTunes App ID
    adSetting.appId = @"0";
    
    // 카울리 앱 코드
    adSetting.appCode = adUnit;
    
    // 광고 랜딩 시 WebView 제거 여부
    adSetting.closeOnLanding = YES;
    
    _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:[adConfiguration topViewController]];
    _interstitialAd.delegate = self;
    
    // 카울리 전면 광고 요청
    [_interstitialAd startInterstitialAdRequest];
}

#pragma mark - GADMediationInterstitialAd implementation

- (void)presentFromViewController:(UIViewController *)viewController {
    [_interstitialAd showWithParentViewController:viewController];
}

#pragma mark - CaulyInterstitialAdDelegate

// 전면 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"cauly interstitial ad Show");
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

// 전면 광고 닫음
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"did Close Interstitial ad");
    _interstitialAd = nil;
}

// 전면 광고 표시
- (void) willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    NSLog(@"will Show Interstitial ad");
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate reportImpression];
}

// 전면 광고 정보 수신 실패
- (void) didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    _interstitialAd = nil;
    NSLog(@"fail interstitial ad");
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

@end
```

### Cauly 네이티브 광고 추가하기
- CaulyEventNative.h

``` objectivec
#import <Foundation/Foundation.h>
#import "Cauly.h"
#import "CaulyNativeAd.h"
@import GoogleMobileAds;


@interface CaulyEventNative : NSObject <CaulyNativeAdDelegate, GADMediationNativeAd> {
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationNativeLoadCompletionHandler _loadCompletionHandler;

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id<GADMediationNativeAdEventDelegate> _adEventDelegate;
    
    CaulyNativeAd *_nativeAd;
    
    NSDictionary *nativeAdItem;
    
    CaulyNativeAdItem *caulyNativeAdItem;
}

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler;

@end
```

- CaulyEventNative.m

``` objectivec
#import "CaulyEventNative.h"


@implementation CaulyEventNative

/// Used to store the ad's images. In order to implement the GADMediationNativeAd protocol, we use
/// this class to return the images property.
NSArray<GADNativeAdImage *> *_images;

/// Used to store the ad's icon. In order to implement the GADMediationNativeAd protocol, we use
/// this class to return the icon property.
GADNativeAdImage *_icon;

/// Used to store the ad's ad choices view. In order to implement the GADMediationNativeAd protocol,
/// we use this class to return the adChoicesView property.
UIView *_adChoicesView;

UIImageView *_mediaView;

UIImage *imageImg;

#pragma mark - Native Ad Mapping
- (nullable NSString *)headline {
    return [nativeAdItem objectForKey:@"title"];
}

- (nullable NSArray<GADNativeAdImage *> *)images {
    return _images;
}

- (nullable NSString *)body {
    return [nativeAdItem objectForKey:@"description"];
}

- (nullable GADNativeAdImage *)icon {
    NSLog(@"%@", _icon.image);
    return _icon;
}

- (nullable NSString *)callToAction {
    return nil;
}

- (nullable NSDecimalNumber *)starRating {
  return nil;
}

- (nullable NSString *)store {
  return nil;
}

- (nullable NSString *)price {
  return nil;
}

- (nullable NSString *)advertiser {
    return [nativeAdItem objectForKey:@"subtitle"];
}

- (nullable NSDictionary<NSString *, id> *)extraAssets {
    return nil;
}

- (nullable UIView *)adChoicesView {
  return _adChoicesView;
}

- (nullable UIView *)mediaView {
    return _mediaView;
}

- (BOOL)hasVideoContent {
  return self.mediaView != nil;
}

#pragma mark - Native Ad Request
- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    __block GADMediationNativeLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];

    _loadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(
        _Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {

      id<GADMediationNativeAdEventDelegate> delegate = nil;
      if (originalCompletionHandler) {
        // Call original handler and hold on to its return value.
        delegate = originalCompletionHandler(ad, error);
      }

      // Release reference to handler. Objects retained by the handler will also be released.
      originalCompletionHandler = nil;

      return delegate;
    };
    
    // admob 대시보드 등록 parameter : cauly appCode
    NSString *adUnit = adConfiguration.credentials.settings[@"parameter"];
    
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    
    // 카울리 로그 레벨
    [CaulyAdSetting setLogLevel:CaulyLogLevelInfo];
    
    // iTunes App ID
    adSetting.appId = @"0";
    
    // 카울리 앱 코드
    adSetting.appCode = adUnit;
    
    _nativeAd = [[CaulyNativeAd alloc] initWithParentViewController:[adConfiguration topViewController]];
    _nativeAd.delegate = self;
    
    // 카울리 네이티브 광고 요청
    [_nativeAd startNativeAdRequest:2 nativeAdComponentType:CaulyNativeAdComponentType_IconImage imageSize:@"720x480"];
}

#pragma mark - Cauly Native Delegates

// 네이티브 광고 정보 수신 성공
-(void) didReceiveNativeAd:(CaulyNativeAd *)nativeAd isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"Cauly didReceiveNativeAd");
    CaulyNativeAdItem *caulyNativeAd = [nativeAd nativeAdItemAt:0];
    caulyNativeAdItem = [nativeAd nativeAdItemAt:0];
    
    NSArray* allList = [nativeAd nativeAdItemList];
    
    for (CaulyNativeAdItem *adItem in allList) {
        // 수신된 모든 네이티브 광고(JSON) 로그 출력
        NSLog(@"for nativeAdJSONString : %@", adItem.nativeAdJSONString);
    }
    
    NSError *error;
    nativeAdItem = [NSJSONSerialization JSONObjectWithData:[caulyNativeAd.nativeAdJSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    _nativeAd = nativeAd;
    
    [self performSelectorInBackground:@selector(urlToImage) withObject:nil];
    
}

- (void)didFailToReceiveNativeAd:(CaulyNativeAd *)nativeAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"Cauly didFailToReceiveNativeAd errorCode: %d errorMsg: %@", errorCode, errorMsg);
    NSError *error = [[NSError alloc] initWithDomain:@"kr.co.cauly.sdk.ios.mediation.sample" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

// 이미지 url 변환
- (void)urlToImage {
    NSURL *iconURL = [NSURL URLWithString:[nativeAdItem objectForKey:@"icon"]];
    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
    UIImage *iconImg = [[UIImage alloc] initWithData:iconData];
    _icon = [[GADNativeAdImage alloc] initWithImage:iconImg];
    
    NSURL *imageURL = [NSURL URLWithString:[nativeAdItem objectForKey:@"image"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    imageImg = [[UIImage alloc] initWithData:imageData];

    [self performSelectorOnMainThread:@selector(setMediaViewImage) withObject:nil waitUntilDone:0];
}

// 변환된 이미지를 MediaView 에 표시
- (void)setMediaViewImage {
    _mediaView = [[UIImageView alloc] initWithImage:imageImg];
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

#pragma mark - GADMediatedUnifiedNativeAd

- (void)didRecordClickOnAssetWithName:(GADNativeAssetIdentifier)assetName view:(UIView *)view viewController:(UIViewController *)viewController {
    NSLog(@"didRecordClickOnAssetWithName");
    [_nativeAd click:caulyNativeAdItem];
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

## 5. TestFlight에 배포하기
> iOS 샘플앱 테스트를 위한 TestFlight 사용을 위해 작성된 가이드입니다.  
> TestFlight에 대한 내용은 [여기](https://testflight.apple.com/) 에서 확인해주십시오.


### 앱 빌드 정보 및 환경 설정
#### 1. 앱 버전 명 변경
- Targets 선택 > General 탭 선택 > Identity > Version, Build 값을 입력합니다.
  - Version : 앱 버전명 입력
  - Build : 빌드 버전명 입력

#### 2. Debug/Release 모드 선택
- Edit Scheme 메뉴를 클릭합니다.
- Archive 에서 `Debug 모드` 와 `Release 모드` 중에서 선택합니다.


### iOS 앱 TestFlight 에 업로드
#### 1. Archive 진행
- 빌드 디바이스로 `Any iOS Device` 를 선택합니다.
- 상단 메뉴에서 Product > Archive 를 선택합니다.

#### 2. 업로드할 앱 버전 선택
- 업로드할 앱 버전 선택 > `Distribute App` 버튼을 클릭합니다.

#### 3. 배포 방식 선택
- App Store Connect 선택 > `Next` 버튼을 클릭합니다.

#### 4. 앱 생성할 목적지 선택
- Upload 선택 > `Next` 버튼을 클릭합니다.
  - Upload : TestFlight 에 바로 업로드
  - Export : ipa 파일로 앱을 내보내기 (Transporter 앱을 이용하여 ipa 파일을 TestFlight 에 업로드할 수 있습니다.)

#### 5. 배포 옵션 선택
- 기본 상태 그대로 옵션 선택 > `Next` 버튼을 클릭합니다.

#### 6. TestFlight 에 업로드
- 배포 인증서, 프로비저닝 파일 선택 > `Next` 버튼을 클릭합니다.
- 앱 정보를 확인한 후 `Upload` 버튼을 클릭합니다.

### TestFlight 에 앱 업로드 확인
> App Store Connect 사이트 > Testflight > 빌드 > iOS 메뉴를 선택합니다.  
> TestFlight 에 업로드한 앱 버전들을 확인할 수 있습니다.  
> 업로드 직후에는 처리중 상태이며, 10 ~ 20분 후에 제출 준비 완료 상태로 변경됩니다.  
> 제출 준비 완료 상태로 변경되면 TestFlight 앱을 통해 테스트앱을 다운로드 받을 수 있습니다.

### TestFlight 외부 테스터 추가하기
#### TestFlight 외부 테스트
- TestFlight 앱을 통해 iOS 앱을 테스트할 수 있도록 외부 사용자에게 공유할 수 있는 기능입니다.
  - 외부 사용자에게 앱을 공유할 수 있습니다.
  - 공유하려는 앱은 TestFlight 베타 앱 심사에서 승인을 받아야합니다

#### TestFlight 외부 테스터를 추가하는 방법
- 외부 테스팅 그룹 생성
  - 외부 테스팅 `+` 버튼 클릭 > 그룹명 입력 > `생성` 버튼을 클릭합니다.

- 테스트 공개 링크 생성
  - 외부 테스팅 그룹 선택 > 빌드 `+` 버튼 클릭 > 테스트할 바이너리 파일 선택 > `추가` 버튼을 클릭합니다.
  - 심사가 통과되면 `공개 링크 활성화` 버튼을 클릭하여 공개 링크를 생성합니다.
  - 공개 링크를 공유하여 팀 외부의 사용자를 초대하여 앱의 테스트가 가능합니다.
