//
//  SplashViewController.m
//  CaulyIOSMediationSample
//
//  Created by FSN on 10/16/24.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppOpenAdManager.sharedInstance.delegate = self;
    
    [self initializeUMP];
}

- (void)initializeUMP {
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
    
    /*** UMP 테스트 모드 설정  **/
    // 앱을 출시하기 전에 테스트 설정 코드를 반드시 삭제해야 합니다.
    UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
    
    // 테스트 기기 설정
    debugSettings.testDeviceIdentifiers = @[@"TEST-DEVICE-HASHED-ID"];
    // EEA 지역 설정
    debugSettings.geography = UMPDebugGeographyEEA;
    parameters.debugSettings = debugSettings;
    /*** UMP 테스트 모드 설정  **/
    
    __weak __typeof__(self) weakSelf = self;
    
    // Request an update for the consent information.
    [UMPConsentInformation.sharedInstance requestConsentInfoUpdateWithParameters:parameters completionHandler:^(NSError * _Nullable requestConsentError) {
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
        GADMobileAds *ads = [GADMobileAds sharedInstance];
        [ads startWithCompletionHandler:^(GADInitializationStatus *status) {
            // Optional: Log each adapter's initialization latency.
            // 미디에이션 어댑터 연결 정보 확인
            NSDictionary *adapterStatuses = [status adapterStatusesByClassName];
            for (NSString *adapter in adapterStatuses) {
              GADAdapterStatus *adapterStatus = adapterStatuses[adapter];
              NSLog(@"Adapter Name: %@, Description: %@, Latency: %f", adapter,
                    adapterStatus.description, adapterStatus.latency);
            }

            // Start loading ads here...
            [AppOpenAdManager.sharedInstance loadAd];
          }];
    });
}

// 메인 화면으로 이동
- (void)startMainScreen {
    AppOpenAdManager.sharedInstance.delegate = nil;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];

    UIApplication.sharedApplication.keyWindow.rootViewController = mainViewController;
}

#pragma mark - AppOpenAdManagerDelegate

// 앱 오프닝 광고 수신 성공
- (void)appOpenAdDidLoad {
    NSLog(@"appOpenAdDidLoad");
    [AppOpenAdManager.sharedInstance showAdIfAvailable];
}

// 앱 오프닝 광고 수신 실패
- (void)appOpenAdFailedToLoad:(NSError *)error {
    NSLog(@"appOpenAdFailedToLoad: %@", error);
    [self startMainScreen];
}

// 앱 오프닝 광고 노출 성공
- (void)appOpenAdDidShow {
    NSLog(@"appOpenAdDidShow");
    [self startMainScreen];
}

// 앱 오프닝 광고 노출 실패
- (void)appOpenAdFailedToShow:(NSError *)error {
    NSLog(@"appOpenAdFailedToShow: %@", error);
    [self startMainScreen];
}

@end
