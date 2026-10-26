//
//  Cauly.h
//  Cauly
//
//  Created by Neil Kwon on 9/2/15.
//  Copyright (c) 2015 Cauly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CaulySDK/CaulyAdIdInfo.h>
#import <CaulySDK/CaulyInitConfig.h>

@class WKWebView;
@class WKWebViewConfiguration;

/** 광고 식별자 조회 결과를 돌려받는 블록. 항상 메인 스레드에서 호출된다 */
typedef void (^CaulyAdIdHandler)(CaulyAdIdInfo * adIdInfo);

/**
 * 초기화 결과를 돌려받는 블록. 항상 메인 스레드에서 호출된다.
 *
 * adIdInfo 는 그 시점의 스냅샷이다. 캐싱하지 말 것 — state 가
 * CaulyAdIdStateReady 가 아니면 adIdWithCompletion: 으로 다시 조회해야 한다.
 */
typedef void (^CaulyInitHandler)(NSInteger resultCode, NSString * resultMessage, CaulyAdIdInfo * adIdInfo);

/**
 * SDK 전역 진입점.
 *
 * 애드폼 객체를 만들지 않고도 SDK 수준의 정보를 조회할 수 있는 자리다.
 * 웹 SDK 를 붙이고 요청 서버를 직접 호출하는 매체처럼, 네이티브 광고 객체가
 * 없는 경로에서 광고 식별자가 필요한 경우를 위해 둔다.
 *
 * Android 는 같은 역할을 com.fsn.cauly.Cauly 가 맡는다.
 */
@interface Cauly : NSObject

/**
 * 광고 식별자를 조회한다.
 *
 * 이 호출은 ATT 다이얼로그를 띄우지 않는다. 아직 동의를 묻지 않은
 * 상태라면 state 가 CaulyAdIdStatePending 으로 내려오므로, 매체가 ATT 를
 * 띄운 뒤 다시 호출하면 된다.
 *
 * 결과를 캐싱하지 말 것. state 가 CaulyAdIdStateReady 가 아니면 값이 바뀔 수 있다.
 */
+ (void)adIdWithCompletion:(CaulyAdIdHandler)completion;

/**
 * SDK 를 초기화한다. 필수가 아니라 선택이다.
 *
 * 부르지 않으면 지금까지처럼 첫 광고 요청 때 늦게 초기화되고 동작도 그대로다.
 * 부르면 두 가지가 달라진다.
 *
 *   1. 서버 설정(xconf) 을 광고 요청 전에 미리 받아둔다. require_adid 같은 정책이
 *      첫 요청부터 반영된다.
 *   2. ATT 다이얼로그를 띄우는 주도권이 매체로 넘어온다.
 *      config.requestTrackingAuthorization 을 YES 로 두면 지금처럼 SDK 가 띄운다.
 *
 * 프로세스당 한 번만 실행된다. 두 번째부터는 직전 결과를 그대로 돌려주고,
 * 진행 중에 다시 부르면 같은 결과를 같이 받는다.
 *
 * 서버 설정을 받지 못해도 초기화는 성공으로 끝난다. 캐시나 기본값으로 진행하면 되고,
 * 광고 요청 자체를 막을 이유가 없기 때문이다.
 */
+ (void)initializeWithConfig:(CaulyInitConfig *)config
                  completion:(CaulyInitHandler)completion;

/**
 * ATT(추적 동의) 다이얼로그를 띄운다.
 *
 * 이미 답한 사용자에게는 다시 묻지 않는다 — ATT 는 앱 생애 1회다.
 * 답변이 끝나면 갱신된 식별자를 실어 completion 을 부른다.
 *
 * Android 에도 같은 이름의 API 가 있지만, 거기에는 띄울 다이얼로그가 없어
 * 현재 상태를 그대로 돌려줄 뿐이다. 웹 SDK 가 한 모양으로 부를 수 있도록 맞춘 것이다.
 */
+ (void)requestTrackingAuthorizationWithCompletion:(CaulyAdIdHandler)completion;

/**
 * 웹 SDK 가 네이티브 SDK 를 부를 수 있도록 브릿지를 등록한다.
 *
 * <b>loadRequest: 보다 먼저</b> 불러야 한다. 주입 스크립트는 다음 페이지 로드부터
 * 적용되므로, 페이지가 뜨고 나서 부르면 웹 SDK 의 init 이 브릿지를 찾지 못한다.
 *
 * 웹에서는 window.caulyBridge.postMessage(JSON) 으로 부르고, 결과는
 * window.__caulyNative.onResponse(JSON) 으로 돌아간다. Android 와 같은 모양이다.
 *
 * 하위 iframe 에서 온 메시지는 무시한다.
 */
+ (void)registerWebView:(WKWebView *)webView;

/**
 * 웹 SDK 용 WKWebView 설정을 만들어 돌려준다.
 *
 * allowsInlineMediaPlayback 같은 값은 WKWebViewConfiguration 생성 시점에만
 * 적용되므로, WKWebView 를 만들기 전에 이 설정을 받아 써야 한다.
 * Android 에는 없는 API 다 — 그쪽은 WebSettings 를 나중에 바꿀 수 있다.
 */
+ (WKWebViewConfiguration *)makeWebViewConfiguration;

@end

#define TEST_APP_CODE			(@"CAULY")

#define CAULY_SDK_VERSION		(@"3.1.25")

#define CAULY_ERR_SUCCESS		(0)
#define CAULY_ERR_FAILED		(1)
#define CAULY_ERR_INAVLID_XML	(2)
#define CAULY_ERR_INAVLID_JSON	(3)

// 광고 갱신 시간
typedef enum {
    CaulyReloadTime_0,                      // 0초
    CaulyReloadTime_30,		                // 30초
    CaulyReloadTime_60,		                // 60초
    CaulyReloadTime_120		                // 120초
} CaulyReloadTime;

// 광고 크기
typedef enum {
    CaulyAdSize_IPhone,		                // 320 * 50
    CaulyAdSize_IPhoneLarge,                // 320 * 100
    CaulyAdSize_IPhoneMediumRect,           // 300 * 250
    CaulyAdSize_IPadLarge,	                // 728 * 90
    CaulyAdSize_IPadSmall	                // 468 * 60
} CaulyAdSize;

// Native Ad Component type
typedef enum {
    CaulyNativeAdComponentType_None,        // No Image nor Icon
    CaulyNativeAdComponentType_Icon,        // Icon Only
    CaulyNativeAdComponentType_Image,       // Image Only
    CaulyNativeAdComponentType_IconImage	// Icon and Image Both
} CaulyNativeAdComponentType;

// 화면 전환 효과
typedef enum {
    CaulyAnimCurlUp,		                // Curl Up
    CaulyAnimCurlDown,		                // Curl Down
    CaulyAnimFlipFromLeft,	                // 뒤집기(Left->Right)
    CaulyAnimFlipFromRight,	                // 뒤집기(Right->Left)
    CaulyAnimFadeOut,		                // Fade Out
    CaulyAnimNone			                // 애니메이션 없음
} CaulyAnim;

// Log 레벨
typedef enum {
    CaulyLogLevelError,
    CaulyLogLevelInfo,
    CaulyLogLevelDebug,
    CaulyLogLevelTrace
} CaulyLogLevel;


// Error Code
#define CaulyError_OK					(0)
#define CaulyError_NO_CHARGED			(100)
#define CaulyError_NO_FILL_AD			(200)
// xconf 가 require_adid=Y 를 내린 매체에서 광고 ID 를 수집하지 못해 요청 자체를 하지 않은 경우 (CAULY-12509)
#define CaulyError_NO_FILL_ADID			(201)
#define CaulyError_INVAILD_APP_CODE		(400)
#define CaulyError_SERVER_ERROR			(500)
#define CaulyError_NOT_ALLOW_INTERVAL	(-200)
#define CaulyError_SDK_INNER_ERROR		(-100)
