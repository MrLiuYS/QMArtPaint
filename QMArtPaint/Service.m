//
//  Service.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "Service.h"


#define kLimitNumber 50

@implementation Service


+ (void)searchStr:(NSString *)aSearchStr
             skip:(int)aSkip
       constraint:(NSArray *)aArray
          success:(requestSuccessBlock)successHandler
          failure:(requestFailureBlock)failureHandler {
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"art"];
    
    bquery.limit = kLimitNumber;
    bquery.skip = aSkip * bquery.limit;
    
    [bquery orderByDescending:@"readNum"];
    
    [bquery addTheConstraintByOrOperationWithArray:aArray];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            
            failureHandler(error);
            
        } else {
            
            successHandler(array);
            
        }
    }];
    
}


@end
