//
//  CaulyInitConfig.h
//  Cauly
//
//  Copyright (c) 2026 Cauly. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * SDK 초기화 설정.
 *
 * 초기화는 선택이다. 호출하지 않으면 기존처럼 첫 광고 요청 때 늦게 초기화되고
 * 동작도 그대로다. 호출하면 광고 요청 전에 설정을 미리 받아두고,
 * 광고 식별자 동의 주도권이 매체로 넘어온다.
 */
@interface CaulyInitConfig : NSObject

/** 매체 코드. 서버 설정(xconf) 을 미리 받아오는 데 쓴다 */
@property (nonatomic, strong) NSString * appCode;

/**
 * SDK 가 ATT(추적 동의) 다이얼로그를 띄울지. 기본값 NO.
 *
 * 기본값이 NO 인 것은 다이얼로그를 띄우는 시점을 매체가 정하는 쪽이 맞기 때문이다.
 * 매체는 적절한 시점에 Cauly 의 requestTrackingAuthorizationWithCompletion: 을 부르면 된다.
 *
 * YES 로 두면 초기화 시점에 SDK 가 대신 띄운다. 초기화를 호출하지 않는
 * 기존 연동은 이 설정과 무관하게 지금까지처럼 SDK 가 띄운다.
 *
 * Android 는 광고 ID 수집에 동의 다이얼로그가 없어 이 값을 무시한다.
 */
@property (nonatomic, assign) BOOL requestTrackingAuthorization;

+ (instancetype)configWithAppCode:(NSString *)appCode;

@end
