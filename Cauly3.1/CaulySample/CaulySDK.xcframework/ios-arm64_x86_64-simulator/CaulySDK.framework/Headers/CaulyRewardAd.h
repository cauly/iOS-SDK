//
//  CaulyRewardAd.h
//  Cauly
//
//  보상형(Reward) 광고.
//
//  서버 규격상 보상형은 전면과 같은 ad_form=ext_interstitial 로 요청하고
//  is_reward=1 로 구분한다. 그래서 내부적으로는 전면 경로를 그대로 재사용하며,
//  보상 전용 동작만 분기한다.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CaulySDK/Cauly.h>
#import <CaulySDK/CaulyAdSetting.h>

@class CaulyRewardAd;

@protocol CaulyRewardAdDelegate <NSObject>

@optional
// 광고 정보 수신 성공
- (void)didReceiveRewardAd:(CaulyRewardAd *)rewardAd isChargeableAd:(BOOL)isChargeableAd;

// 광고 정보 수신 실패
- (void)didFailToReceiveRewardAd:(CaulyRewardAd *)rewardAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg;

// 광고가 보여지기 직전
- (void)willShowRewardAd:(CaulyRewardAd *)rewardAd;

// 광고가 닫혔을 때
- (void)didCloseRewardAd:(CaulyRewardAd *)rewardAd;

/**
 * 보상 지급 조건이 충족되었을 때. 매체는 이 시점에 사용자에게 보상을 지급하면 된다.
 *
 * - 광고가 닫히기 전에 올 수도, 닫힌 뒤에 올 수도 있다. 닫힘 콜백과 순서를 가정하지 말 것.
 * - 한 번의 노출에 최대 한 번만 호출된다.
 * - 보상의 종류와 수량은 전달하지 않는다. 서버 응답의 reward_type 은 지급 방식(rcpm/rcpc)이고
 *   수량은 서버가 내려주지 않으므로, 매체가 자체 정책으로 정하는 값이다.
 * - 지급 사실은 SSV Postback 으로도 매체 서버에 전달된다. 실제 적립은 서버에서 확정하고
 *   이 콜백은 UI 처리용으로 쓰는 것을 권장한다.
 */
- (void)didUserEarnReward:(CaulyRewardAd *)rewardAd;

@end


@interface CaulyRewardAd : NSObject

+ (id)caulyAdWithController:(UIViewController *)controller;

- (id)init;
- (id)initWithParentViewController:(UIViewController *)controller;

- (int)earnType;
- (float)price;

- (void)startRewardAdRequest;
- (void)stopAdRequest;

- (void)show;
- (void)showWithParentViewController:(UIViewController *)controller;

- (void)close;

/**
 * 서버 보상 검증(SSV)에서 사용자를 식별하는 값.
 * 광고 요청 시점부터 서버가 알고 있어야 하므로 startRewardAdRequest 전에 설정해야 한다.
 */
- (void)setUserId:(NSString *)userId;

/** 매체가 보상 완료 통지와 함께 돌려받고 싶은 임의 문자열. */
- (void)setCustomData:(NSString *)customData;

/** 위와 같되 딕셔너리를 키 정렬된 JSON 오브젝트 문자열로 직렬화해 보낸다. */
- (void)setCustomDataWithDictionary:(NSDictionary<NSString *, NSString *> *)customData;

@property (nonatomic, weak) id<CaulyRewardAdDelegate> delegate;
@property (nonatomic, strong) CaulyAdSetting * localSetting;
@property (nonatomic, weak) UIViewController * parentController;
@property (nonatomic, readonly) NSString * errorMsg;

@property (nonatomic, strong) NSObject * data;

@end
