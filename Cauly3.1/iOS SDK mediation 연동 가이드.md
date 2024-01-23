iOS SDK mediation 연동 가이드
=====================================================

목차 

1. [문서 개요](#1-문서-개요)
2. [미디에이션 시작하기](#2-미디에이션-시작하기)
	- [사전 안내](#사전-안내)
	- [광고 SDK 가져오기](#광고-sdk-가져오기)
	- [Info.plist 업데이트](#infoplist-업데이트)
    - [UMP 설정](#ump-user-messaging-platform-설정)
	- [광고 SDK 초기화](#광고-sdk-초기화)
    - [타겟팅 설정](#타겟팅-설정)
	- [파트너 통합 네트워크 설정](#파트너-통합-네트워크-설정)
	- [테스트 광고 사용 설정](#테스트-광고-사용-설정)
3. [Admob 광고 추가하기](#3-admob-광고-추가하기)
	- [Admob 앱 오프닝 광고 추가하기](#admob-앱-오프닝-광고-추가하기)
	- [Admob 배너 광고 추가하기](#admob-배너-광고-추가하기)
	- [Admob 전면 광고 추가하기](#admob-전면-광고-추가하기)
	- [Admob 보상형 광고 추가하기](#admob-보상형-광고-추가하기)
	- [Admob 네이티브 광고 추가하기](#admob-네이티브-광고-추가하기)
4. [커스텀 이벤트 네트워크 추가하기](#4-커스텀-이벤트-네트워크-추가하기)
	- [Cauly 광고 추가하기](#cauly-광고-추가하기)
		- [Cauly 어댑터 초기화](#cauly-어댑터-초기화)
		- [Cauly 배너 광고 추가하기](#cauly-배너-광고-추가하기)
		- [Cauly 전면 광고 추가하기](#cauly-전면-광고-추가하기)
		- [Cauly 네이티브 광고 추가하기](#cauly-네이티브-광고-추가하기)
	- [AdFit 광고 추가하기](#adfit-광고-추가하기)
        - [AdFit 어댑터 초기화](#adfit-어댑터-초기화)
        - [AdFit 네이티브 광고 추가하기](#adfit-네이티브-광고-추가하기)
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

``` bash
# Google Admob
pod 'Google-Mobile-Ads-SDK', '~> 10.14.0'

# inmobi
pod 'GoogleMobileAdsMediationInMobi', '~> 10.6.0.0'

# applovin
pod 'GoogleMobileAdsMediationAppLovin', '~> 12.1.0.0'

# vungle
pod 'GoogleMobileAdsMediationVungle', '~> 7.2.0.0'

# DT Exchange
pod 'GoogleMobileAdsMediationFyber', '~> 8.2.5.0'

# Mintegral
pod 'GoogleMobileAdsMediationMintegral', '~> 7.4.8.0'

# Pangle
pod 'GoogleMobileAdsMediationPangle', '~> 5.6.0.8.0'

# Unity Ads
pod 'GoogleMobileAdsMediationUnity', '~> 4.9.2.0'

# meta
pod 'GoogleMobileAdsMediationFacebook', '~> 6.14.0.0'

# IronSource
pod 'GoogleMobileAdsMediationIronSource', '~>7.6.0.0'

# adfit
pod 'AdFitSDK'



post_install do |installer|
    # Xcode15.0 이상 버전에서 TOOL CHAIN 관련 빌드 에러가 발생한 경우 아래 코드를 추가하십시오.
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            xcconfig_path = config.base_configuration_reference.real_path
            xcconfig = File.read(xcconfig_path)
            xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
            File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
    end

    # Xcode15.0 이상 버전에서 minimum deployment target 관련 빌드 에러가 발생한 경우 아래 코드를 추가하십시오.
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
```

- Xcode 15.0 이상 버전에서 빌드 시, 일부 광고 네트워크 SDK에서 다음과 같은 에러가 발생할 수 있습니다.
- 이 경우 Podfile에 위 내용을 참조하여 수정합니다.

``` bash
DT_TOOLCHAIN_DIR cannot be used to evaluate LIBRARY_SEARCH_PATHS, use TOOLCHAIN_DIR instead
```

- Xcode 15.0 이상 버전에서 빌드 시, iOS Minimum Deployments 버전 (최소 지원 버전)을 12.0 이상으로 설정하지 않은 경우 다음과 같은 에러가 발생할 수 있습니다.
- 이 경우 Podfile에 위 내용을 참조하여 수정합니다.

``` bash
SDK does not contain 'libarclite' at the path 
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphoneos.a'; 
try increasing the minimum deployment target
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
	<summary>SKAdNetworkItems</summary>

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
        <string>v4nxqhlyqp.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>t38b2kh725.skadnetwork</string>
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
        <string>pwa73g5rt2.skadnetwork</string>
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
        <string>3qcr597p9d.skadnetwork</string>
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
        <string>f73kdq92p3.skadnetwork</string>
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
        <string>5l3tpt7t6e.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>7rz58n8ntl.skadnetwork</string>
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
        <string>424m5254lk.skadnetwork</string>
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
        <string>g28c52eehv.skadnetwork</string>
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
        <string>b9bk5wbcq9.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>kbmxgpxpgc.skadnetwork</string>
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
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>238da6jt44.skadnetwork</string>
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
        <string>3l6bd9hu43.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>44n7hlldy6.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>488r3q3dtq.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>4mn522wn87.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>4w7y6s5ca2.skadnetwork</string>
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
        <string>6p4ks3rnbw.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>6v7lgmsu45.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>737z793b9f.skadnetwork</string>
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
        <string>84993kbrcf.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>89z7zv988g.skadnetwork</string>
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
        <string>9b89h5y424.skadnetwork</string>
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
        <string>a7xqa6mtl2.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>a8cz6cu7e5.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>bxvub5ada5.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cs644xg564.skadnetwork</string>
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
        <string>ejvt5qm6ak.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>f7s53z58qe.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>g2y4y55b64.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>gta8lk7p23.skadnetwork</string>
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
        <string>krvm3zuq6h.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>lr83yxwka7.skadnetwork</string>
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
        <string>mp6xlyr22a.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>n66cz3y3bx.skadnetwork</string>
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
        <string>s69wq72ugq.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>su67r6k2v3.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>u679fj5vs4.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>v79kvwwj4g.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>vcra2ehyfk.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>x44k69ngh6.skadnetwork</string>
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
        <string>zmvfpc5aq8.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>7953jerfzd.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>qu637u8glc.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9g2aggbj52.skadnetwork</string>
    </dict>
</array>
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
> 애드몹 UMP의 GDPR 동의 화면이 보이는 상태에서,  
> 프로그래밍 방식을 사용하여 수동으로 ATT (App Tracking Transparency) 동의 알림을 요청하는 경우  
> `애플 앱 심사에서 거절될 수 있습니다.`  
> 애드몹 UMP를 사용하여 GDPR 메시지 사용 시 프로그래밍 방식을 사용하여 ATT 동의 요청을 하지 마십시오.

- 애플은 iOS14 에서 ATT(App Tracking Transparency) Framework가 추가되었습니다.
- IDFA 식별자를 얻기 위해서는 `ATT Framework를 반드시 적용`해야 합니다.
- `info.plist`

```xml
<key> NSUserTrackingUsageDescription </key>
<string> 맞춤형 광고 제공을 위해 사용자의 데이터가 사용됩니다. </string>
```

<details>
	<summary>Swift</summary>

```swift
import AppTrackingTransparency
... 
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .authorized:       // 승인
                print("Authorized")
                // 권한 요청이 완료된 다음, 광고를 요청해 주세요.
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

</details>


<details>
	<summary>Objective-C</summary>

```objectivec
#import <AppTrackingTransparency/AppTrackingTransparency.h>
...
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

</details>

#### 사용자 앱 내 광고 경험 개선을 위한 URL Scheme 적용
- Cauly SDK 3.1.22 부터 지원됩니다.
- info.plist 작성
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>naversearchapp</string>
</array>
```


### UMP (User Messaging Platform) 설정

#### GDPR (General Data Protection Regulation)

`GDPR은 유럽 연합(이하 'EU')의 개인정보 보호 법령으로, 서비스 제공자는 EU 사용자의 개인정보 수집 및 활용에 대해 사용자에게 동의 여부를 확인받아야 합니다.`

#### 1. SDK 추가

1. 프로젝트의 Podfil을 열고 아래 내용을 추가합니다.

``` bash
pod 'GoogleUserMessagingPlatform'
```

2. pod 을 설치하고 .xcworkspace 파일을 엽니다.

``` bash
pod install --repo-update
```

#### 2. 구현

> AppDelegate 에서 광고 관련 코드를 요청하기 전에 애드몹 UMP (User Messaging Platform) 를 통하여 GDPR 동의를 처리해야 합니다.  
>  
> 애드몹 UMP의 GDPR 동의 화면이 보이는 상태에서,  
> 프로그래밍 방식을 사용하여 수동으로 ATT (App Tracking Transparency) 동의 알림을 요청하는 경우  
> `애플 앱 심사에서 거절될 수 있습니다.`  
> 애드몹 UMP를 사용하여 GDPR 메시지 사용 시 프로그래밍 방식을 사용하여 ATT 동의 요청을 하지 마십시오.

- 아래 예제코드는 ViewController의 viewDidLoad() 에서 처리하는 방법에 대한 예제코드입니다.

Swift

``` swift
import UIKit
import GoogleMobileAds
import UserMessagingPlatform


class ViewController: UIViewController {

    // Use a boolean to initialize the Google Mobile Ads SDK and load ads once.
    private var isMobileAdsStartCalled = false
    
    @IBOutlet var nativeAdPlaceholder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request an update for the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
            [weak self] requestConsentError in
            guard let self else { return }

            if let consentError = requestConsentError {
            // Consent gathering failed.
                return print("Error: \(consentError.localizedDescription)")
            }

            UMPConsentForm.loadAndPresentIfRequired(from: self) {
                [weak self] loadAndPresentError in
                guard let self else { return }

                if let consentError = loadAndPresentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }

                // Consent has been gathered.
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        
        // Check if you can initialize the Google Mobile Ads SDK in parallel
        // while checking for new consent information. Consent obtained in
        // the previous session can be used to request ads.
        if UMPConsentInformation.sharedInstance.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }

    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
          guard !self.isMobileAdsStartCalled else { return }

          self.isMobileAdsStartCalled = true

          // Initialize the Google Mobile Ads SDK.
          GADMobileAds.sharedInstance().start()

          // TODO: Request an ad.
        }
      }
}
```


Objective-C
``` objectivec
#import <UIKit/UIKit.h>
@import GoogleMobileAds;
#include <UserMessagingPlatform/UserMessagingPlatform.h>


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof__(self) weakSelf = self;
    
    // Request an update for the consent information.
    [UMPConsentInformation.sharedInstance requestConsentInfoUpdateWithParameters:nil completionHandler:^(NSError * _Nullable requestConsentError) {
        if (requestConsentError) {
            // Consent gathering failed.
            NSLog(@"Error: %@", requestConsentError.localizedDescription);
            return;
        }
        
        __strong __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [UMPConsentForm loadAndPresentIfRequiredFromViewController:strongSelf
                                                 completionHandler:^(NSError *loadAndPresentError) {
            if (loadAndPresentError) {
                // Consent gathering failed.
                NSLog(@"Error: %@", loadAndPresentError.localizedDescription);
                return;
            }
            
            // Consent has been gathered.
            __strong __typeof__(self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            
            if (UMPConsentInformation.sharedInstance.canRequestAds) {
                [strongSelf startGoogleMobileAdsSDK];
            }
        }];
        
    }];

    // Check if you can initialize the Google Mobile Ads SDK in parallel
    // while checking for new consent information. Consent obtained in
    // the previous session can be used to request ads.
    if (UMPConsentInformation.sharedInstance.canRequestAds) {
        [self startGoogleMobileAdsSDK];
    }
}

- (void)startGoogleMobileAdsSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Initialize the Google Mobile Ads SDK.
        [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
        
        // TODO: Request an ad.
    });
}
```


#### 3. 테스트
> 해당 설정은 테스트 목적으로만 사용할 수 있습니다.  
> 앱을 출시하기 전에 테스트 설정 코드를 반드시 삭제해야 합니다.

- UMP SDK의 Debug 설정은 테스트 기기에서만 작동합니다.
- UMPDebugSettings에서 UMPDebugGeography 유형의 debugGeography 속성을 사용하여 기기가 EEA 또는 영국에 있는 것처럼 앱 동작을 테스트할 수 있습니다.
- UMPConsentInformation.sharedInstance.reset() 을 사용하여 UMP SDK의 상태를 재설정할 수 있습니다.

``` clojure
애드몹 UMP의 GDPR 동의 화면을 테스트 목적으로 확인하기 위해서는 아래 단계에 따라 테스트 기기 등록이 필요합니다.

1. requestConsentInfoUpdateWithParameters:completionHandler: 를 호출합니다.
2. 로그 출력에서 다음과 같은 메시지를 확인합니다. 메시지에는 기기 ID와 이를 테스트 기기로 추가하는 방법이 나와있습니다.

<UMP SDK>To enable debug mode for this device, set: UMPDebugSettings.testDeviceIdentifiers = @[2077ef9a63d2b398840261c8221a0c9b]

3. UMPDebugSettings().testDeviceIdentifiers 에 테스트 기기 ID 목록을 전달합니다.
```

Swift

``` swift
let parameters = UMPRequestParameters()
let debugSettings = UMPDebugSettings()
// 테스트 기기 설정
debugSettings.testDeviceIdentifiers = ["2077ef9a63d2b398840261c8221a0c9b"]
// EEA 지역 설정
debugSettings.geography = .EEA
parameters.debugSettings = debugSettings

// 동의 상태 재설정
UMPConsentInformation.sharedInstance.reset()

// Request an update for the consent information.
UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
    [weak self] requestConsentError in
    guard let self else { return }
    ...
};
```

Objective-C

``` objectivec
UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
// 테스트 기기 설정
debugSettings.testDeviceIdentifiers = @[@"2077ef9a63d2b398840261c8221a0c9b"];
// EEA 지역 설정
debugSettings.geography = UMPDebugGeographyEEA;
parameters.debugSettings = debugSettings;

// 동의 상태 재설정
[UMPConsentInformation.sharedInstance reset];

// Request an update for the consent information.
[UMPConsentInformation.sharedInstance requestConsentInfoUpdateWithParameters:parameters completionHandler:^(NSError * _Nullable requestConsentError) {
    ...
}];
```


#### 4. IDFA 메시지 작성
> 애드몹 UMP의 GDPR 메시지 사용 설정을 할 경우 IDFA 메시지 작성도 같이 작성해야합니다.  
> 위에서 [ATT Framework 적용](#ios14-attapp-tracking-transparency-framework-적용)을 진행했다면 관련 코드를 모두 제거해야 합니다.


1. 애드몹 IDFA 메시지 작성
- [애드몹 대쉬보드](https://apps.admob.com)로 이동한 다음 [IDFA 메시지 작성 가이드](https://support.google.com/admob/answer/10115331?hl=ko)를 따라 IDFA 메시지를 작성하고 게시를 완료합니다.

<p float="left">
    <img src="/Cauly3.1/images/idfa_message.png" width="800" hight="700" />
</p>

2. ATT 동의 요청을 위한 설정 추가
- ATT (App Tracking Transparency) 동의 요청을 위해 info.plist 에 다음 내용이 반드시 포함되어야 합니다.

```xml
<key> NSUserTrackingUsageDescription </key>
<string> 맞춤형 광고 제공을 위해 사용자의 데이터가 사용됩니다. </string>
```



### 광고 SDK 초기화
- `AppDelegate` 에서 `startWithCompletionHandler:` 메서드를 호출합니다.  
- 미디에이션을 사용하는 경우 광고를 로드하기 전에 완료 핸들러를 호출할 때까지 기다려야 모든 미디에이션 어댑터가 초기화 됩니다.
<details>
	<summary>Swift</summary>

``` swift
import GoogleMobileAds

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize Google Mobile Ads SDK.
    let ads = GADMobileAds.sharedInstance()
    ads.start { status in
        // Optional: Log each adapter's initialization latency.
        let adapterStatuses = status.adapterStatusesByClassName
        for adapter in adapterStatuses {
            let adapterStatus = adapter.value
            NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key, adapterStatus.description, adapterStatus.latency)
        }
        
        // Start loading ads here ...
    }
    return true
}
```

</details>

<details>
	<summary>Objective-C</summary>

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

</details>



### 타겟팅 설정
- 광고 요청에 타겟팅 정보를 제공하는 방법입니다.
- `구글플레이 스토어의 콘텐츠 설정과 SDK 설정이 반드시 동일하게 설정되어야 합니다.`


#### 아동 대상 설정 방법
- [아동 온라인 개인 정보 보호법(COPPA)](https://www.ftc.gov/business-guidance/privacy-security/childrens-privacy)에 따라 `tagForChildDirectedTreatment` 설정이 가능합니다.
- 광고를 요청할 때 콘텐츠를 아동 대상 서비스 취급 여부를 지정할 수 있습니다.
- 콘텐츠를 아동 대상으로 처리하도록 지정하면 해당 광고 요청에 대한 관심 기반 광고 및 리마케팅 광고가 사용 중지됩니다.


Swift
``` swift
GADMobileAds.sharedInstance().requestConfiguration.tagForChildDirectedTreatment = true
```


Objective-C
``` objectivec
[[GADMobileAds.sharedInstance requestConfiguration] tagForChildDirectedTreatment:YES];
```


 | tagForChildDirectedTreatment 설정 | 설명                              |
 |------|--------------------------------------|
 | true  | COPPA에 따라 콘텐츠를 아동 대상으로 처리하도록 지정하는 경우       |
 | false  | COPPA에 따라 콘텐츠를 아동 대상으로 처리하지 않도록 지정하는 경우 |
 | 미설정  | 광고 요청에서 COPPA에 따른 콘텐츠 취급 방법을 지정하지 않는 경우 |



#### 동의 연령 미만 사용자 설정 방법
- 유럽 경제 지역(EEA)에 거주하는 동의 연령 미만의 사용자를 대상으로 하는 서비스로 취급하도록 광고 요청에 표시할 수 있습니다.
- TFUA(동의 연령 미만의 유럽 사용자가 대상임을 나타내는 태그) 매개변수가 광고 요청에 포함되며, 모든 광고 요청에서 리마케팅을 포함한 개인 맞춤 광고가 사용 중지됩니다.
- `true` 로 설정하는 경우 광고 식별자인 IDFA 수집도 차단됩니다.
- [아동 대상 설정](#아동-대상-설정-방법)과 동시에 true 로 설정하면 안 되며, 이 경우 아동 대상 설정이 우선 적용됩니다.



Swift
``` swift
GADMobileAds.sharedInstance().requestConfiguration.tagForUnderAgeOfConsent = true
```


Objective-C
``` objectivec
[[GADMobileAds.sharedInstance requestConfiguration] tagForUnderAgeOfConsent:YES];
```



 | tagForUnderAgeOfConsent 설정 | 설명                              |
 |------|--------------------------------------|
 | true  | 광고 요청이 EEA에 거주하는 동의 연령 미만의 사용자를 대상으로 처리하도록 지정하는 경우       |
 | 미설정  | 광고 요청이 EEA에 거주하는 동의 연령 미만의 사용자 취급 방법을 지정하지 않는 경우 |





#### 광고 콘텐츠 필터링
- 광고 내 관련 혜택이 포함된 Google Play의 [부적절한 광고 정책](https://support.google.com/googleplay/android-developer/answer/9857753?hl=ko#zippy=,examples-of-common-violations)을 준수하려면 콘텐츠 자체가 Google Play 정책을 준수하더라도 앱에 표시되는 모든 광고 및 관련 혜택은 앱의 [콘텐츠 등급](https://support.google.com/googleplay/android-developer/answer/9898843?hl=ko)에 적합해야 합니다.
- 광고 콘텐츠 등급 한도가 설정된 경우 콘텐츠 등급이 설정된 한도 이하인 광고가 게재되며, 다음 중 하나로 설정해야합니다.
- 콘텐츠 등급 한도 설정에 대해 [각 광고 요청에 대한 콘텐츠 등급 한도 설정하기](https://support.google.com/admob/answer/10477886?hl=ko) 또는 [앱 또는 계정의 광고 콘텐츠 등급 한도 설정하기](https://support.google.com/admob/answer/7562142?hl=ko) 를 참고 부탁드립니다.

| 광고 콘텐츠 등급 한도 (Objective-C) | 광고 콘텐츠 등급 한도 (Swift) |
 |------|------|
 | GADMaxAdContentRatingGeneral  | .general |  
 | GADMaxAdContentRatingParentalGuidance  | .parentalGuidance |  
 | GADMaxAdContentRatingTeen  | .teen |  
 | GADMaxAdContentRatingMatureAudience  | .matureAudience |  

Swift
``` swift
GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = .general
```


Objective-C
``` objectivec
GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating = GADMaxAdContentRatingGeneral;
```





### 파트너 통합 네트워크 설정
> [SKAdNetworkItems](#skadnetwork-지원)를 info.plist에 반드시 추가해야 합니다.

#### Inmobi 설정 (옵션)
- Inmobi SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/inmobi#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### AppLovin 설정 (옵션)
- AppLovin SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/applovin#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Vungle 설정
- Vungle SDK 초기화를 위해 앱 내에서 사용될 모든 배치 목록을 SDK 로 전달해야 합니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/liftoff-monetize#optional_steps)를 참고하여 옵션 설정이 가능합니다.


<details>
	<summary>Swift</summary>

```swift
import VungleAdapter
// ...

let request = GADRequest()
let extras = VungleAdNetworkExtras()

let placements = ["PLACEMENT_ID_1", "PLACEMENT_ID_2"]
extras.allPlacements = placements
request.register(extras)
```

</details>

<details>
	<summary>Objective-C</summary>

``` objectivec
#import <VungleAdapter/VungleAdapter.h>
// ...

GADRequest *request = [GADRequest request];
VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];

NSMutableArray *placements = [[NSMutableArray alloc] initWithObjects:@"PLACEMENT_ID_1", @"PLACEMENT_ID_2", nil];
extras.allPlacements = placements;
[request registerAdNetworkExtras:extras];
```

</details>

#### DT Exchange 설정 (옵션)
- DT Exchange SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/dt-exchange#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Mintegral 설정 (옵션)
- Mintegral SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/mintegral#optional_steps)를 참고하여 옵션 설정이 가능합니다.

#### Pangle 설정
- Pangle SDK 설정을 위해 추가 코드가 필요하지 않습니다.


#### Unity Ads 설정 
- Swift 환경: Unity Ads SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- Objective-C 환경: Unity Ads adapter가 4.4.0.0 이상인 경우 [Unity 설명서](https://docs.unity.com/ads/en-us/manual/InstallingTheiOSSDK#Swift) 의 통합 단계를 따라야 합니다.
  - 프로젝트에서 이미 Swift를 사용하는 경우 추가 조치가 필요하지 않습니다.
  - 프로젝트에서 Swift를 사용하지 않는 경우 `File > New > Swift file` 을 선택하여 Xcode에서 빈 Swift 파일을 프로젝트에 추가합니다.
  - 프로젝트가 iOS 12.4 이전 버전을 대상으로 하는 경우 Xcode에서 `TARGETS > Build Settings > Always embed Swift standard libraries`를 `YES` 로 설정해야 합니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/unity#optional_steps)를 참고하여 옵션 설정이 가능합니다.


#### Meta 설정
- Meta 네트워크를 사용하기 위해 Facebook 로그인 및 `read_audience_network_insights` 권한이 필요합니다.
    - Facebook 로그인은 [iOS용 Facebook 로그인](https://developers.facebook.com/docs/facebook-login/ios)을 참고하여 설정이 가능합니다.

- Complie errors
    - Swift 환경: Meta SDK 설정을 위해 추가 코드가 필요하지 않습니다.
    - Objective-C 환경: Meta Audience Network 어댑터 6.9.0.0 이상의 경우 컴파일 오류를 방지하기 위해 [여기](https://developers.google.com/admob/ios/mediation/meta#objective-c) 의 통합 단계를 따라야 합니다.
        - 타겟 수준의 `Build Settings` 아래 `Library Search Paths` 에 다음 경로를 추가하십시오.

        ```bash
        $(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
        $(SDKROOT)/usr/lib/swift
        ```
        - 타겟 수준의 `Build Settings` 아래 `Runpath Search Paths` 에 다음 경로를 추가합니다.

        ```bash
        /usr/lib/swift
        ```
- Advertising tracking enabled
    - iOS 14 이상을 타겟팅하는 경우 Meta Audience Network 에서는 아래 코드를 사용하여 [광고 추적 활성화 플래그](https://developers.facebook.com/docs/audience-network/setting-up/platform-setup/ios/advertising-tracking-enabled)를 명시적으로 설정해야합니다.

    ```swift
    Swift :: 
    // Set the flag as true
    FBAdSettings.setAdvertiserTrackingEnabled(true)
    ```

    ```objectivec
    Objective-C ::
    // Set the flag as true.
    [FBAdSettings setAdvertiserTrackingEnabled:YES];
    ```

- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/meta#optional_steps)를 참고하여 옵션 설정이 가능합니다.


#### IronSource 설정
- IronSource SDK 설정을 위해 추가 코드가 필요하지 않습니다.
- 필요한 경우 [여기](https://developers.google.com/admob/ios/mediation/ironsource?hl=ko#step_4_implement_privacy_settings_on_ironsource_sdk)를 참고하여 추가 설정이 가능합니다.


### 테스트 광고 사용 설정
> `상용화 시 반드시 테스트 광고 설정 관련 코드를 삭제해야 합니다.`

#### 프로그래밍 방식으로 테스트 장치 추가

- 광고를 요청한 후 Console에서 다음과 같은 메시지를 확인합니다.
``` clojure
<Google> To get test ads on this device, set: 
Objective-C
	GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
Swift
	GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
```

- `testDeviceIdentifiers` 를 통해 테스트 기기 ID를 설정하도록 코드를 수정합니다.

```clojure
Swift ::
GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
    [ "2077ef9a63d2b398840261c8221a0c9b" ] // Sample device ID
```

``` objectivec
Objective-C ::
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
```swift
Swift ::
import GoogleMobileAdsMediationTestSuite  // Remove this line.
```

``` objectivec
Objective-C ::
@import GoogleMobileAdsMediationTestSuite;  // Remove this line.
```

- 뷰가 표시된 후 다음과 같이 테스트 모음을 표시합니다.
```swift
Swift ::
GoogleMobileAdsMediationTestSuite.present(on:self, delegate:nil)  // Remove this line.
```

``` objectivec
Objective-C ::
[GoogleMobileAdsMediationTestSuite presentOnViewController:self delegate:nil];  // Remove this line.
```

## 3. Admob 광고 추가하기
### Admob 앱 오프닝 광고 추가하기
- 앱 오프닝 광고를 구현하는 데 필요한 단계는 크게 다음과 같습니다.
    1. `AppDelegate`에 메서드를 추가하여 `GADAppOpenAd`를 로드하고 표시합니다.
    2. 앱 포그라운드 이벤트 감지
    3. 프레젠테이션 콜백을 처리합니다.

<details> <summary>Swift</summary>

- AppDelegate.swift

```swift
import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Google Mobile Ads SDK.
        let ads = GADMobileAds.sharedInstance()
        ads.start { status in
            ...
            
            // Although the Google Mobile Ads SDK might not be fully initialized at this point,
            // we should still load the app open ad so it becomes ready to show when the splash
            // screen dismisses.
            AppOpenAdManager.shared.loadAd()
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let rootViewController = application.windows.first(
            where: { $0.isKeyWindow })?.rootViewController
        if let rootViewController = rootViewController {
            // Do not show app open ad if the current view controller is SplashViewController.
            if (rootViewController is SplashViewController) {
                return
            }
            AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
```

- AppOpenAdManager.swift
```swift

import GoogleMobileAds

protocol AppOpenAdManagerDelegate: AnyObject {
    /// Method to be invoked when an app open ad is complete (i.e. dismissed or fails to show).
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {
    /// Ad references in the app open beta will time out after four hours,
    /// but this time limit may change in future beta versions. For details, see:
    /// https://support.google.com/admob/answer/9341964?hl=en
    let timeoutInterval: TimeInterval = 4 * 3_600
    /// The app open ad.
    var appOpenAd: GADAppOpenAd?
    /// Maintains a reference to the delegate.
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
    /// Keeps track of if an app open ad is loading.
    var isLoadingAd = false
    /// Keeps track of if an app open ad is showing.
    var isShowingAd = false
    /// Keeps track of the time when an app open ad was loaded to discard expired ad.
    var loadTime: Date?
    
    static let shared = AppOpenAdManager()

    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }

    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }

    private func appOpenAdManagerAdDidComplete() {
        // The app open ad is considered to be complete when it dismisses or fails to show,
        // call the delegate's appOpenAdManagerAdDidComplete method if the delegate is not nil.
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
    }

    func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        print("Start loading app open ad.")
        GADAppOpenAd.load(
            withAdUnitID: "ca-app-pub-xxxxxxxxxx",
            request: GADRequest(),
            orientation: UIInterfaceOrientation.portrait
        ) { ad, error in
            self.isLoadingAd = false
            if let error = error {
                self.appOpenAd = nil
                self.loadTime = nil
                print("App open ad failed to load with error: \(error.localizedDescription).")
                return
            }

            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            print("App open ad loaded successfully.")
        }
    }

    func showAdIfAvailable(viewController: UIViewController) {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            print("App open ad is already showing.")
            return
        }
        // If the app open ad is not available yet but it is supposed to show,
        // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
        // method and load a new ad.
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            appOpenAdManagerAdDidComplete()
            loadAd()
            return
        }
        if let ad = appOpenAd {
            print("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: viewController)
        }
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad is will be presented.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }

    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error.localizedDescription).")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
}
```

</details>


### Admob 배너 광고 추가하기
- rootViewController : 광고 클릭이 발생할 때 오버레이를 표시하는 데 사용되는 보기 컨트롤러입니다. 일반적으로 GADBannerView 를 포함하는 보기 컨트롤러로 설정해야 합니다.
- adUnitID : GADBannerView 가 광고를 로드하는 광고 단위 ID입니다.


<details> <summary>Swift</summary>

```swift
import GoogleMobileAds


class ViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ...

        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-xxxxxxxxxx"
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
    // 배너 광고 요청
    @IBAction func bannerAdRequest(_ sender: UIButton) {
        print("bannerAdRequest")
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
    }

    // MARK: - bannerDelegate
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
```

</details>

<details> <summary>Objective-C</summary>

``` objectivec
@import GoogleMobileAds;

@interface ViewController () <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ...

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

</details>


### Admob 전면 광고 추가하기
- 전면 광고는 loadWithAdUnitID:request:completionHandler: 메서드를 사용하여 로드됩니다.
- 로드 메서드에는 광고 단위 ID, GADRequest 객체, 광고 로드에 성공하거나 실패할 때 호출되는 완료 핸들러가 필요합니다.

<details> <summary>Swift</summary>

```swift

import GoogleMobileAds


class ViewController: UIViewController, GADFullScreenContentDelegate {

    private var interstitial: GADInterstitialAd?
    
    ...
    
    // 전면 광고 요청
    @IBAction func interstitialAdRequest(_ sender: UIButton) {
        print("interstitialAdRequest")
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-xxxxxxxxxx",
                            request: request,
                            completionHandler: { [self] ad, error in
                                if let error = error {
                                    // 전면 광고 요청 실패
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
            
                                // 전면 광고 표시
                                if interstitial != nil {
                                    interstitial?.present(fromRootViewController: self)
                                } else {
                                    print("Ad wasn't ready")
                                }
                            }
        )
    }
    
    // MARK: - interstitalDelegate
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>


### Admob 보상형 광고 추가하기
- 보상형 광고는 loadWithAdUnitID:request:completionHandler: 메서드를 사용하여 로드됩니다.
- 로드 메서드에는 광고 단위 ID, GADRequest 객체, 광고 로드에 성공하거나 실패할 때 호출되는 완료 핸들러가 필요합니다.


<details> <summary>swift</summary>

```swift
import GoogleMobileAds


class ViewController: UIViewController, GADFullScreenContentDelegate {

    private var rewardedAd: GADRewardedAd?
    
    ...
    
    // 보상형 광고 요청
    @IBAction func rewardAdRequest(_ sender: UIButton) {
        print("rewardAdRequest")
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-xxxxxxxxxx",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                // 보상형 광고 요청 실패
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad

            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
            showRewardedAd()
        })
    }
    
    // 리워드 광고 표시 및 리워드 이벤트 처리
    func showRewardedAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    // MARK: - interstitalDelegate
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>

### Admob 네이티브 광고 추가하기
- 광고를 요청하기 전에 `GADAdLoader` 를 초기화해야 합니다.
- AdLoader 에는 다음 옵션이 필요합니다.
  - 광고 단위 ID
  - adTypes : 배열을 전달하여 요청할 네이티브 형식을 지정할 상수
  - options : 매개변수에 사용할 수 있는 값은 [네이티브 광고 옵션 설정 페이지](https://developers.google.com/admob/ios/native/options?hl=ko)에서 확인할 수 있습니다.

<details> <summary>Swift</summary>

```swift
import GoogleMobileAds

class ViewController: UIViewController, GADNativeAdLoaderDelegate, GADNativeAdDelegate {

    private var adLoader: GADAdLoader?
    
    @IBOutlet var nativeAdPlaceholder: UIView!
    
    ...

    // 네이티브 광고 요청
    @IBAction func nativeAdRequest(_ sender: UIButton) {
        print("nativeAdRequest")
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-8713069554470817/2066596228",
                               rootViewController: self,
                               adTypes: [ .native],
                               options: nil)
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    // MARK: - GADNativeAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader,didReceive nativeAd: GADNativeAd) {
        // A native ad has loaded, and can be displayed.
        print("Received native ad: \(nativeAd)")
        
        // Create and place ad in view hierarchy.
        let nibView = Bundle.main.loadNibNamed("ExampleNativeAdView", owner: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else {
            return
        }
        setAdView(nativeAdView)
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            let heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint.isActive = true
        }
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
            from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }
    
    func setAdView(_ view: GADNativeAdView) {
        // Remove the previous ad view.
        nativeAdPlaceholder.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": view]
        self.view.addConstraints(
          NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[_nativeAdView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[_nativeAdView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
    
    /// Returns a `UIImage` representing the number of stars from the given star rating; returns `nil`
    /// if the star rating is less than 3.5 stars.
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader didFailToReceiveAdWithError")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        // The native ad shown.
        print("nativeAdDidRecordImpression")
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        // The native ad was clicked on.
        print("nativeAdDidRecordClick")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        // The native ad will present a full screen view.
        print("nativeAdWillPresentScreen")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad will dismiss a full screen view.
        print("nativeAdWillDismissScreen")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        // The native ad did dismiss a full screen view.
        print("nativeAdDidDismissScreen")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        // The native ad will cause the app to become inactive and
        // open a new app.
        print("nativeAdWillLeaveApplication")
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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
</details>



## 4. 커스텀 이벤트 네트워크 추가하기
> 커스텀 이벤트를 구현하기 위해 `GADMediationAdapter` 프로토콜이 구현된 클래스, `GADMediation{지면타입}Ad` 프로토콜이 구현된 클래스가 필요합니다.  
>
> 예를 들어, Cauly 이벤트를 추가하는 경우 이 문서의 `CaulyEvent`와 추가 예정의 지면타입에 맞는 `CaulyEventBanner`, `CaulyEventInterstitial`, `CaulyEventNative` 클래스를 추가해주시면 됩니다.  
> 각 클래스는 `하나씩`만 선언해주시면 됩니다.


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

> Swift 개발 환경에서는 아래 항목을 추가로 진행해야 합니다.
3. Import Header
  - Bridging-Header.h 파일을 생성하고 밑에 사진과 같이 해더파일을 생성해야합니다.
	
<p float="left">
  <img src="/Cauly3.1/Swift/images/hearder.png" width="800" hight="700" />
</p>

  - Build Settings -> 검색바에서 -> Swift Compiler -> Objective-C Bridging Heaer 프로젝트명-Bridging-Header.h 등록
<p float="left">
  <img src="/Cauly3.1/Swift/images/target.png" width="800" hight="1000"/>
</p>

### Cauly 어댑터 초기화


<details> <summary>Swift</summary>

```swift
import Foundation
import GoogleMobileAds

class CaulyEvent: NSObject, GADMediationAdapter {
    
    fileprivate var bannerAd: CaulyEventBanner?
    
    fileprivate var interstitialAd: CaulyEventInterstitial?
    
    fileprivate var nativeAd: CaulyEventNative?
    
    required override init() {
        super.init()
    }
    
    // MARK: - Cauly Banner Ad Request
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        self.bannerAd = CaulyEventBanner()
        self.bannerAd?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }
    
    // MARK: - Cauly Interstitial Ad Request
    func loadInterstitial(for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        self.interstitialAd = CaulyEventInterstitial()
        self.interstitialAd?.loadInterstitial(for: adConfiguration, completionHandler: completionHandler)
    }

    // MARK: - Cauly Native Ad Request
    func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        self.nativeAd = CaulyEventNative()
        self.nativeAd?.loadNativeAd(for: adConfiguration, completionHandler: completionHandler)
    }

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        // This is where you will initialize the SDK that this custom event is built
        // for. Upon finishing the SDK initialization, call the completion handler
        // with success.
        completionHandler(nil)
    }

    static func adapterVersion() -> GADVersionNumber {
        let adapterVersion = "1.0.0.0"
        let versionComponents = adapterVersion.components(separatedBy: ".")
        var version = GADVersionNumber()
        if versionComponents.count == 4 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = (Int(versionComponents[2]) ?? 0) * 100 + (Int(versionComponents[3]) ?? 0)
        }
        return version
    }

    static func adSDKVersion() -> GADVersionNumber {
        let versionComponents = CAULY_SDK_VERSION.components(separatedBy: ".")
        
        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0
            
            return GADVersionNumber(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
        }
        
        return GADVersionNumber()
    }

    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>


### Cauly 배너 광고 추가하기
> - SKAdNetwork 를 지원하게 되면서 아래 초기화 부분에서 반드시 adSetting.appId 로 App Store 의 App ID 정보를 입력해주셔야 합니다.
> - 만약, 아직 출시 전 앱인 경우는 0 으로 지정할 수는 있으나 App Store 에 등록된 앱인 경우에는 반드시 입력해야 합니다.

<details> <summary>Swift</summary>

```swift
import Foundation
import GoogleMobileAds
import UIKit

class CaulyEventBanner: NSObject, GADMediationBannerAd, CaulyAdViewDelegate {
    /// The Cauly Ad Network banner ad.
    var adView: CaulyAdView?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationBannerAdEventDelegate?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var completionHandler: GADMediationBannerLoadCompletionHandler?
    
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        // Create the bannerView with the appropriate size.
        let adSize = adConfiguration.adSize
        
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        print("adUnit: \(adUnit ?? "nil")")
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelTrace)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        caulySetting?.animType = CaulyAnimNone          // 화면 전환 효과
        caulySetting?.adSize = CaulyAdSize_IPhone       // 광고 View 크기
        caulySetting?.closeOnLanding = true             // App 으로 이동할 때 webview popup 창을 자동으로 닫아줍니다. 기본값을 false
        caulySetting?.useDynamicReloadTime = false
        
        adView = CaulyAdView.init()
        adView?.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height)
        adView?.bounds = frame
        
        self.completionHandler = completionHandler
        adView?.startBannerAdRequest()      // 배너 광고 요청
    }
    
    // MARK: - GADMediationBannerAd implementation
    var view: UIView {
        return adView ?? UIView()
    }
    
    required override init() {
        super.init()
    }
    
    // MARK: - CaulyAdViewDelegate
    // 광고 정보 수신 성공
    func didReceiveAd(_ adView: CaulyAdView!, isChargeableAd: Bool) {
        print("Loaded didReceiveAd callback")
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    // 광고 정보 수신 실패
    func didFail(toReceiveAd adView: CaulyAdView!, errorCode: Int32, errorMsg: String!) {
        print("didFailToReceiveAd: \(errorCode)(\(errorMsg!)")
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    // 랜딩 화면 표시
    func willShowLanding(_ adView: CaulyAdView!) {
        print("willShowLandingView")
        delegate?.reportClick()
    }
    
    // 랜딩 화면이 닫혔을 때
    func didCloseLanding(_ adView: CaulyAdView!) {
        print("didCloseLandingView")
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>


### Cauly 전면 광고 추가하기

<details> <summary>Swift</summary>

```swift

import Foundation
import GoogleMobileAds

class CaulyEventInterstitial: NSObject, GADMediationInterstitialAd, CaulyInterstitialAdDelegate {
    /// The Cauly Ad Network interstitial.
    var interstitial: CaulyInterstitialAd?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationInterstitialAdEventDelegate?
    
    var completionHandler: GADMediationInterstitialLoadCompletionHandler?
    
    func loadInterstitial( for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelTrace)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        caulySetting?.closeOnLanding = true             // App 으로 이동할 때 webview popup 창을 자동으로 닫아줍니다. 기본값을 false
        
        self.interstitial = CaulyInterstitialAd.init(parentViewController: adConfiguration.topViewController)
        self.interstitial?.delegate = self;              // 전면 delegate 설정
        self.completionHandler = completionHandler
        self.interstitial?.startRequest()                // 전면광고 요청
    }
    
    // MARK: - GADMediationInterstitialAd implementation
    required override init() {
        super.init()
    }
    
    func present(from viewController: UIViewController) {
        if interstitial != nil {
            interstitial?.show(withParentViewController: viewController)
        }
    }
    
    // MARK: - CaulyInterstitialAdDelegate
    // 광고 정보 수신 성공
    func didReceive(_ interstitialAd: CaulyInterstitialAd!, isChargeableAd: Bool) {
        print("didReceiveInterstitialAd")
        interstitial = interstitialAd
        
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    // Interstitial 형태의 광고가 닫혔을 때
    func didClose(_ interstitialAd: CaulyInterstitialAd!) {
        print("didCloseInterstitialAd")
    }
    
    // Interstitial 형태의 광고가 보여지기 직전
    func willShow(_ interstitialAd: CaulyInterstitialAd!) {
        print("willShowInterstitialAd")
    }
    
    // 광고 정보 수신 실패
    func didFail(toReceive interstitialAd: CaulyInterstitialAd!, errorCode: Int32, errorMsg: String!) {
        print("Receive fail interstitial errorCode:\(errorCode)(\(errorMsg!)")
        
        interstitial = nil
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>

### Cauly 네이티브 광고 추가하기


<details> <summary>Swift</summary>

``` swift
import Foundation
import GoogleMobileAds

class CaulyEventNative: NSObject, GADMediationNativeAd, CaulyNativeAdDelegate {
    /// The Sample Ad Network native ad.
    var nativeAd: CaulyNativeAd?
    
    var nativeAdItem: Dictionary<String, Any>?
    
    var caulyNativeAdItem: CaulyNativeAdItem?
    
    var _mediaView: UIView?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationNativeAdEventDelegate?
    
    /// Completion handler called after ad load
    var completionHandler: GADMediationNativeLoadCompletionHandler?
    
    func loadNativeAd( for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        // 상세 설정 항목들은 표 참조, 설정되지 않은 항목들은 기본값으로 설정됩니다.
        let caulySetting = CaulyAdSetting.global()
        CaulyAdSetting.setLogLevel(CaulyLogLevelInfo)   // CaulyLog 레벨
        caulySetting?.appId = "0"                       // App Store 에 등록된 App ID 정보
        caulySetting?.appCode = adUnit                  // admob 등록 parameter (Cauly 발급 키)
        
        nativeAd = CaulyNativeAd.init(parentViewController: adConfiguration.topViewController)
        nativeAd?.delegate = self;
        self.completionHandler = completionHandler
        
        // 카울리 네이티브 광고 요청
        nativeAd?.startRequest(2, nativeAdComponentType: CaulyNativeAdComponentType_IconImage, imageSize: "720x480")
    }
    
    // MARK: - GADMediationNative
    required override init() {
        super.init()
    }
    
    var headline: String? {
        return nativeAdItem?["title"] as? String
    }
    
    var images: [GADNativeAdImage]?
    
    var body: String? {
        return nativeAdItem?["description"] as? String
    }
    
    var icon: GADNativeAdImage?
    
    var callToAction: String? {
        return ""
    }
    
    var starRating: NSDecimalNumber? {
        return nil
    }
    
    var store: String? {
        return ""
    }
    
    var price: String? {
        return ""
    }
    
    var advertiser: String? {
        return nativeAdItem?["subtitle"] as? String
    }
    
    var extraAssets: [String : Any]? {
        return nil
    }
    
    var adChoicesView: UIView?
    
    var mediaView: UIView? {
        return _mediaView
    }
    
    // MARK: - Cauly Native Delegate
    // 네이티브 광고 정보 수신 성공
    func didReceive(_ nativeAd: CaulyNativeAd!, isChargeableAd: Bool) {
        print("Cauly didReceiveNativeAd")
        caulyNativeAdItem = nativeAd.nativeAdItem(at: 0)
        
        do {
            nativeAdItem = try JSONSerialization.jsonObject(with: Data((caulyNativeAdItem?.nativeAdJSONString.utf8)!), options: []) as? Dictionary<String, Any>
        } catch {
            print(error.localizedDescription)
        }
        print(nativeAdItem as Any)
        self.nativeAd = nativeAd
        
        urlToImage()
    }
    
    func didFail(toReceive nativeAd: CaulyNativeAd!, errorCode: Int32, errorMsg: String!) {
        print("Cauly didFailToReceiveNativeAd errorCode: \(errorCode), errMsg: \(errorMsg ?? "No Message")")
        
        let error = NSError(domain: "kr.co.cauly.sdk.ios.mediation.sample", code: Int(errorCode), userInfo: ["description" : errorMsg as Any])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    func urlToImage() {
        let iconUrl = URL(string: nativeAdItem?["icon"] as! String)
        let mediaUrl = URL(string: nativeAdItem?["image"] as! String)
        
        DispatchQueue.global().async { [weak self] in
            if let iconData = try? Data(contentsOf: iconUrl!), let mediaData = try? Data(contentsOf: mediaUrl!) {
                if let iconImage = UIImage(data: iconData), let mediaImage = UIImage(data: mediaData) {
                    DispatchQueue.main.async {
                        self?.icon = GADNativeAdImage(image: iconImage)
                        self?._mediaView = UIImageView(image: mediaImage)
                        self?.images = [GADNativeAdImage(image: mediaImage)]
                        
                        if let handler = self?.completionHandler {
                            self?.delegate = handler(self, nil)
                        }
                    }
                }
            }
        }
    }
}
```

</details>

<details> <summary>Objective-C</summary>

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

</details>

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



### AdFit 광고 추가하기

#### 권장 환경
- AdFit SDK는 Swift 4 기반으로 개발되었습니다. Objective-C 기반의 프로젝트에서 AdFit SDK를 사용하기 위해서는 Swift Standard 라이브러리들을 Embed 시켜주어야 합니다.
- 앱 프로젝트의 빌드 세팅에서 `Always Embed Swift Standard Libraries` 항목을 `Yes` 로 설정해주세요.


### AdFit 어댑터 초기화

<details> <summary>Swift</summary>

``` swift
import Foundation
import GoogleMobileAds

class AdFitEvent: NSObject, GADMediationAdapter {
    
    fileprivate var nativeAd: AdFitEventNative?
    
    required override init() {
        super.init()
    }
    
    // MARK: - AdFit Native Ad Request
    func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        self.nativeAd = AdFitEventNative()
        self.nativeAd?.loadNativeAd(for: adConfiguration, completionHandler: completionHandler)
    }

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        // This is where you will initialize the SDK that this custom event is built
        // for. Upon finishing the SDK initialization, call the completion handler
        // with success.
        completionHandler(nil)
    }

    static func adapterVersion() -> GADVersionNumber {
        let adapterVersion = "1.0.0.0"
        let versionComponents = adapterVersion.components(separatedBy: ".")
        var version = GADVersionNumber()
        if versionComponents.count == 4 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = (Int(versionComponents[2]) ?? 0) * 100 + (Int(versionComponents[3]) ?? 0)
        }
        return version
    }

    static func adSDKVersion() -> GADVersionNumber {
        let versionComponents = CAULY_SDK_VERSION.components(separatedBy: ".")
        
        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0
            
            return GADVersionNumber(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
        }
        
        return GADVersionNumber()
    }

    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
}
```
</details>

### AdFit 네이티브 광고 추가하기

> AdFit 네이티브 광고 뷰 구성은 [AdFit Native 광고 연동 가이드](https://github.com/adfit/adfit-ios-sdk/blob/master/Guide/Native%20Ad.md)를 기반으로 작성되어있습니다.  
> 혹여 이 문서에서 설명되지 않은 사항들은 해당 참조 링크에서 확인해주십시오.


#### 1. 광고 요청
- 네이티브 광고의 요청은 `AdFitNativeAdLoader` 클래스를 통해 이루어집니다.
- 광고 요청 후 성공적으로 응답을 받으면, 구현된 `AdFitNativeAdLoaderDelegate` 프로토콜을 통해 광고 애셋을 포함한 `AdFitNativeAd` 객체를 제공합니다.
- `AdFitNativeAd` 를 통해서 구현한 뷰와 바인딩하여 네이티브 광고를 표시합니다.


<details> <summary>Swift</summary>

- AdFitEventNative.swift

``` swift
import Foundation
import GoogleMobileAds
import AdFitSDK
import UIKit

class AdFitEventNative: NSObject, GADMediationNativeAd, AdFitNativeAdDelegate, AdFitNativeAdLoaderDelegate {
    /// The Sample Ad Network native ad.
    var nativeAd: AdFitNativeAd?
    
    var nativeAdLoader: AdFitNativeAdLoader?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationNativeAdEventDelegate?
    
    /// Completion handler called after ad load
    var completionHandler: GADMediationNativeLoadCompletionHandler?
    
    var nativeAdView: MyNativeAdView?
    
    func loadNativeAd( for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        
        // admob 등록 parameter(Cauly 발급 키)를 가져옵니다.
        let adUnit = adConfiguration.credentials.settings["parameter"] as? String
        
        self.completionHandler = completionHandler
        
        nativeAdLoader = AdFitNativeAdLoader(clientId: adUnit ?? "")
        nativeAdLoader?.delegate = self
        
        /**
         광고 뷰 내에서 정보 아이콘이 표시될 위치.
         이 아이콘을 표시하기 위해 별다른 처리는 필요하지 않으며, 지정된 위치에 자동으로 표시됩니다.
         기본값은 **topRight** (우측 상단) 입니다.
         
         ***topRight**(우측 상단), **topLeft**(좌측 상단), **bottomRight**(우측 하단), **bottomLeft**(좌측 하단)
         */
        nativeAdLoader?.infoIconPosition = .topRight
        nativeAdLoader?.loadAd()
    }
    
    // MARK: - GADMediationNative Mapping
    required override init() {
        super.init()
    }
    
    var headline: String? {
        return nil
    }
    
    var images: [GADNativeAdImage]?
    
    var body: String? {
        return nil
    }
    
    var icon: GADNativeAdImage?
    
    var callToAction: String? {
        return nil
    }
    
    var starRating: NSDecimalNumber? {
        return nil
    }
    
    var store: String? {
        return nil
    }
    
    var price: String? {
        return nil
    }
    
    var advertiser: String? {
        return nil
    }
    
    var extraAssets: [String : Any]? {
        return [
            "mediaAspectRatio" : nativeAd?.mediaAspectRatio as Any,
            "view" : nativeAdView as Any
        ]
    }
    
    var adChoicesView: UIView?
  
    var mediaView: UIView?
    
    
    // MARK: - AdFit NativeAdLoader Delegate
    func nativeAdLoaderDidReceiveAd(_ nativeAd: AdFitNativeAd) {
        let message = "delegate: nativeAdDidReceiveAd"
        print(message)
        
        if let nativeAdView = Bundle.main.loadNibNamed("MyNativeAdView", owner: nil, options: nil)?.first as? MyNativeAdView {
            self.nativeAd = nativeAd
            nativeAdView.backgroundColor = .white
            nativeAd.bind(nativeAdView)
            
            self.nativeAdView = nativeAdView
            
            mediaView = nativeAdView.adMediaView()
        }
        
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }
    
    func nativeAdLoaderDidFailToReceiveAd(_ nativeAdLoader: AdFitNativeAdLoader, error: Error) {
        let message = "delegate: nativeAdLoaderDidFailToReceiveAd, error: \(error.localizedDescription)"
        print(message)
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    func nativeAdDidClickAd(_ nativeAd: AdFitNativeAd) {
        let message = "delegate: nativeAdDidClickAd"
        print(message)
        
        delegate?.reportClick()
    }
    
}
```


- ViewController.swift
  - AdFit 네이티브 광고 사용을 위해 ViewController.adLoader() 에도 다음 코드 추가가 필요합니다.
  - [여기](#네이티브-광고-추가하기)에서 안내된 adLoader()에 코드를 추가해주세요.

``` swift
func adLoader(_ adLoader: GADAdLoader,didReceive nativeAd: GADNativeAd) {
    .... 기본 안내코드
    
    if let nativeView = nativeAd.extraAssets?["view"] as? UIView, let mediaAspectRatio = nativeAd.extraAssets?["mediaAspectRatio"] as? CGFloat {
        let screenMinWidth = min(nativeAdPlaceholder.bounds.width, nativeAdPlaceholder.bounds.height)
        let mediaHeight = screenMinWidth / mediaAspectRatio
        nativeView.frame = nativeAdPlaceholder.bounds.divided(atDistance: mediaHeight + 130 , from: .minYEdge).slice
        nativeView.contentMode = .scaleToFill
        nativeAdView.mediaView?.isHidden = true
        
        nativeAdPlaceholder.addSubview(nativeView)
    }
    
    nativeAdView.nativeAd = nativeAd.   // 기본 안내코드
}
```

</details>


#### 2. 광고 뷰 구현하기
- 네이티브 광고의 UI는 서비스의 컨텐츠와 잘 어울리도록 구성되어야 하므로, 뷰 클래스를 개별 앱에서 직접 구현하셔야 합니다.
- 네이티브 광고의 뷰 클래스는 `UIView` 클래스를 상속받도록 하고, `AdFitNativeAdRenderable` 프로토콜을 추가로 구현해주세요.

##### 1) 네이티브 광고 뷰 구성
다음은 피드 형태로 네이티브 광고 뷰를 구성한 예입니다.

<img src="https://t1.daumcdn.net/adfit_sdk/document-assets/ios/native-ad-components3.png" width="640" style="border:1px solid #aaa">

| 번호 | 설명                     | UI 클래스                | AdFitNativeAdRenderable |
|-----|-------------------------|------------------------|-------------------------|
| 1   | 제목                     | UILabel                | adTitleLabel()          |
| 2   | 행동유도버튼               | UIButton               | adCallToActionButton()  |
| 3   | 프로필명                  | UILabel                | adProfileNameLabel()    |
| 4   | 프로필이미지               | UIImageView             | adProfileIconView()    |
| 5   | 미디어 (이미지, 동영상 등)    | AdFitMediaView         | adMediaView()           |
| 6   | 광고 아이콘                |                        |                         |
| 7   | 홍보문구                  | UILabel                 | adBodyLabel()           |

- AdFit의 네이티브 광고는 위의 7가지 요소로 구성됩니다.
- 개별 요소들은 위 표에서 대응되는 UI 클래스를 통해 표시되도록 구현해주세요.
- 사용자가 광고임을 명확히 인지할 수 있도록 "광고", "AD", "Sponsored" 등의 텍스트를 별도로 표시해주셔야 합니다.
- `5. 미디어` 요소의 경우 SDK에 포함된 `AdFitMediaView` 클래스를 사용하여 표시합니다.<br>
   인터페이스 빌더를 사용하시는 경우, 빈 View를 배치한 후 클래스를 `AdFitMediaView` 로 지정하시면 됩니다.
  - `AdFitMediaView` 클래스에는 `videoRenderer()` 메서드가 구현되어 있습니다.<br>
 네이티브 광고의 미디어 타입이 비디오인 경우, 해당 메서드를 호출하여 `AdFitVideoRenderer` 객체에 접근할 수 있습니다.<br>
 해당 객체를 사용하면 네이티브 광고에 표시된 비디오의 제어(`play` / `pause` / `mute` / `unmute`)가 가능합니다.

##### 2) AdFitNativeAdRenderable 프로토콜
- 네이티브 광고 뷰의 구현을 마친 후에는, `AdFitNativeAdRenderable` 프로토콜에 정의된 메서드를 추가로 구현해야 합니다.
- 뷰 클래스가 `AdFitNativeAdRenderable` 프로토콜을 따르도록 구현되어야 네이티브 광고 수신 후 정상적으로 바인딩이 이루어질 수 있습니다.

다음은 뷰 클래스에 `AdFitNativeAdRenderable` 프로토콜을 구현한 예입니다.


<details> <summary>Swift</summary>

``` swift
import UIKit
import AdFitSDK

class MyNativeAdView: UIView, AdFitNativeAdRenderable {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel?
    @IBOutlet weak var actionButton: UIButton?
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var mediaView: AdFitMediaView?
    
    // MARK: - AdFitNativeAdRenderable
    func adTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func adBodyLabel() -> UILabel? {
        return bodyLabel
    }
    
    func adCallToActionButton() -> UIButton? {
        return actionButton
    }
    
    func adProfileNameLabel() -> UILabel? {
        return profileLabel
    }
    
    func adProfileIconView() -> UIImageView? {
        return iconImageView
    }
    
    func adMediaView() -> AdFitMediaView? {
        return mediaView
    }
}
```

</details>

[error 코드 정의]

|   코드  |               메시지                   |                    설명                               |
|:------:|--------------------------------------|------------------------------------------------------|
|  1     | clientId property is nil             | AdFitBannerAdView 객체에 clientId가 세팅되지 않은 경우.     |
|  2     | no ad to show                        | 노출 가능한 광고가 없는 경우. 잠시 후 다시 광고 요청을 시도해주세요. |
|  3     | invalid ad received                  | 유효하지 않은 광고를 받은 경우. AdFit에 문의해주세요.            |
|  5     | attempted to load ad too frequently  | 과도하게 짧은 시간 간격으로 광고를 재요청한 경우.                 |
|  6     | HTTP failed                          | HTTP 에러. 계속해서 반복 발생하는 경우 AdFit에 문의해주세요.      |


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

