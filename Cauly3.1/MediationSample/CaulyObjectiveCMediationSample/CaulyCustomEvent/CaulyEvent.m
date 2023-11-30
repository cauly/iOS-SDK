//
//  CaulyEvent.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 2023/03/15.
//

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


+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
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
