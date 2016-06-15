//
//  QMAdSupper.h
//  QMLogistics
//
//  Created by 潘玉琳 on 16/4/11.
//  Copyright © 2016年 刘永生. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "Service.h"

//admob
@import GoogleMobileAds;

////掌盈
//#import "JoyingSpotAd.h"
//#import "SplashAd.h"

////有米
//#import "ConfigHeader.h"


typedef enum
{
    QMAdType_iAd = 0,
    QMAdType_admob_banner,
    QMAdType_admob_screen,
    QMAdType_youmi,
    QMAdType_zhangying,
    
}
QMAdType;

#define GQMAdSupper [QMAdSupper shareInstance]

@interface QMAdSupper : NSObject

@property (nonatomic, assign) UIViewController *pressViewController;
//@property (strong, nonatomic) SplashAd *splashAd; //掌盈广告

/**
 *  用户购买清除广告
 */
- (void)setiAPClear;
- (BOOL)iAPClear;



+ (QMAdSupper *)shareInstance;


/**
 *  广告条
 *
 *  @param aView           广告条投放位置
 *  @param aViewController 广告条回调方法
 */
- (void)showBannerInView:(UIView *)aView
          viewController:(UIViewController *)aViewController;

/**
 *  插屏
 */
- (void)showTableScreenInViewController:(UIViewController *)aViewController;



@end
