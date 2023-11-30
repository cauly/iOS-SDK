//
//  CaulyEventNative.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

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
