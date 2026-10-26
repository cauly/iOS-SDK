//
//  CaulyAdIdInfo.h
//  Cauly
//
//  Copyright (c) 2026 Cauly. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 광고 식별자 조회 결과의 상태.
 *
 * value 가 비어 있는 이유를 매체가 구분할 수 있어야 한다.
 * "아직 묻지 않았다"(Pending) 와 "거부당했다"(Denied) 는 매체가 취할 조치가 완전히 다르다.
 * 전자는 ATT 를 띄우고 다시 조회하면 풀리고, 후자는 앱 생애 1 회 제약이라 재요청할 수 없다.
 */
typedef NS_ENUM(NSInteger, CaulyAdIdState) {
    /** 값이 확정되었다. 그대로 쓰면 된다 */
    CaulyAdIdStateReady = 0,
    /** 아직 추적 동의를 묻지 않았다. ATT 요청 후 다시 조회하면 풀린다 */
    CaulyAdIdStatePending,
    /** 사용자가 추적을 거부했다 */
    CaulyAdIdStateDenied,
    /** 기기 정책상 추적이 제한되어 있다 */
    CaulyAdIdStateRestricted,
    /** 수집할 수 없다. 제한된 광고 추적, 시뮬레이터, Info.plist 선언 누락 등 */
    CaulyAdIdStateUnavailable
};

/**
 * 광고 식별자 조회 결과.
 *
 * value 는 SDK 가 서버로 보내는 scode 와 같은 값이다. IDFA 를 수집하지 못하면
 * SDK 자신이 그러듯 IDFV 로 폴백하므로, 매체가 요청 서버를 직접 호출할 때
 * scode / scode_type 을 그대로 실어 보낼 수 있다.
 *
 * 다만 폴백한 값은 광고 타게팅용 식별자가 아니다. 그 구분은 state 와 limited 로 한다.
 */
@interface CaulyAdIdInfo : NSObject

/** 서버로 보낼 scode. 없으면 빈 문자열 */
@property (nonatomic, readonly) NSString * value;

/** value 의 종류. @"idfa" | @"idfv" | @"" */
@property (nonatomic, readonly) NSString * type;

/** value 를 광고 식별자로 믿어도 되는지 판단하는 기준 */
@property (nonatomic, readonly) CaulyAdIdState state;

/** 광고 식별자(IDFA) 가 아닌 대체 식별자로 채워졌는지 */
@property (nonatomic, readonly) BOOL limited;

/** 광고 식별자를 얻지 못한 이유를 짧게 설명한다. 정상이면 빈 문자열 */
@property (nonatomic, readonly) NSString * reason;

/** state 의 브릿지 / 로그용 문자열. @"ready" | @"pending" | @"denied" | @"restricted" | @"unavailable" */
@property (nonatomic, readonly) NSString * stateName;

/** SDK 내부에서 생성한다. 매체가 직접 만들 일은 없다 */
+ (instancetype)infoWithValue:(NSString *)value
                         type:(NSString *)type
                        state:(CaulyAdIdState)state
                      limited:(BOOL)limited
                       reason:(NSString *)reason;

@end
