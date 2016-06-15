//
//  QMAdSupper.m
//  QMLogistics
//
//  Created by 潘玉琳 on 16/4/11.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "QMAdSupper.h"


#define kIAPClear @"CleariAd"


#define kAbmobBanner (DEBUG ? @"ca-app-pub-3940256099942544/2934735716": @"ca-app-pub-5240802043946893/6352768566")

#define kAbmobInterstitial (DEBUG ? @"ca-app-pub-3940256099942544/4411468910": @"ca-app-pub-5240802043946893/7829501767")

@interface QMAdSupper ()<GADInterstitialDelegate> {
    
    BOOL isCheckingAppStore;
    
    
}

@property (strong, nonatomic) GADBannerView *gadBannerView;//admob
@property (nonatomic, strong) GADInterstitial *gadInterstitial;


/**
 *  显示admob广告条
 */
- (void)showGadBannerInView:(UIView *)aView viewController:(UIViewController *)aViewController;
/**
 *  显示admob插页广告
 */
- (void)showGadInterstitial:(UIViewController *)aViewController;

/**
 *  显示有米插屏广告
 */
- (void)showYoumi;

@end


@implementation QMAdSupper

+ (QMAdSupper *)shareInstance {
    static QMAdSupper *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] init];
        
        //        [JoyingSpotAd initAppId:@"bb083a38a7bc42ba" secretId:@"2bdd2590701a905f"];
        //        [JoyingSpotAd initAdDeveLoper:kTypePortrait];
        
        //        [YouMiNewSpot initYouMiDeveloperParams:@"b2960056de1380dc" YM_SecretId:@"23b41c1e1c4240cc"];
        //        [YouMiNewSpot initYouMiDeveLoperSpot:kSPOTSpotTypePortrait];//填上你对应的横竖屏模式
        
        [__singletion gadInterstitial];
        
        
    });
    return __singletion;
}
- (void)setiAPClear{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPClear];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)iAPClear {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIAPClear]) {
        return YES;
    }
    return NO;
}

#pragma mark - 显示广告条
- (void)showBannerInView:(UIView *)aView
          viewController:(UIViewController *)aViewController{
    
    if ([self iAPClear]) {
        
        return;
    }
    [self showGadBannerInView:aView viewController:aViewController];
}

#pragma mark - 显示插屏广告
- (void)showTableScreenInViewController:(UIViewController *)aViewController{
    
    if ([self iAPClear]) {
        
        return;
    }
    
    [self showGadInterstitial:aViewController];
    
    
}

#pragma mark - 广告来源

#pragma mark - Admob

- (GADBannerView *)gadBannerView{
    if (!_gadBannerView) {
        _gadBannerView = [[GADBannerView alloc]
                          initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 320)/2.0,
                                                   0, 320, 50)];
        _gadBannerView.adUnitID = kAbmobBanner;
    }
    return _gadBannerView;
}
- (void)showGadBannerInView:(UIView *)aView viewController:(UIViewController *)aViewController{
    
    
    if ([self iAPClear]) {
        
        return;
    }
    
    if (![aView.subviews containsObject:self.gadBannerView]) {
        [aView addSubview:self.gadBannerView];
    }
    
    self.gadBannerView.rootViewController = aViewController;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            kGADSimulatorID
                            ];
    [self.gadBannerView loadRequest:request];
}
- (GADInterstitial *)gadInterstitial {
    
    if (!_gadInterstitial) {
        _gadInterstitial = [[GADInterstitial alloc] initWithAdUnitID:kAbmobInterstitial];
        _gadInterstitial.delegate = self;
        GADRequest *request = [GADRequest request];
        // Requests test ads on test devices.
        request.testDevices = @[
                                kGADSimulatorID
                                ];
        [_gadInterstitial loadRequest:request];
    }
    
    return _gadInterstitial;
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.gadInterstitial = nil;
    [self gadInterstitial];
}
- (void)showGadInterstitial:(UIViewController *)aViewController {
    
    if (![self iAPClear]) {
        
        if ([self.gadInterstitial isReady]) {
            [self.gadInterstitial presentFromRootViewController:aViewController];
        }else {
            [self showYoumi];
        }
        
    }
    
    
    
}

#pragma mark - 有米
- (void)showYoumi {
    
    if (![self iAPClear]) {
        
        //        [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
        //        }];
        
    }
    
}




/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:fromHour];
    NSDate *date23 = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}



@end
