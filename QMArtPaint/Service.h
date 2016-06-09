//
//  Service.h
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BmobSDK/Bmob.h>

#import "Model.h"
/**
 请求成功block
 */
typedef void (^requestSuccessBlock)(id responseObj);

/**
 请求失败block
 */
typedef void (^requestFailureBlock)(NSError *error);


typedef void (^requestProgressBlock)(CGFloat progress);

@interface Service : NSObject

+ (void)searchStr:(NSString *)aSearchStr
             skip:(int)aSkip
       constraint:(NSArray *)aArray
          success:(requestSuccessBlock)successHandler
          failure:(requestFailureBlock)failureHandler;

@end
