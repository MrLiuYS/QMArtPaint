//
//  Service.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "Service.h"
#import <FMDBHelper.h>

#define kLimitNumber 20

@implementation Service


+ (void)searchStr:(NSString *)aSearchStr
             skip:(int)aSkip
       constraint:(NSArray *)aArray
          success:(requestSuccessBlock)successHandler
          failure:(requestFailureBlock)failureHandler {
    
    
    if (aSearchStr.length > 0) {
    

        NSString * sql = [NSString stringWithFormat:@"tag LIKE '%%%@%%' OR author LIKE '%%%@%%' OR explain LIKE '%%%@%%' OR title LIKE '%%%@%%'  ORDER BY updatedAt desc LIMIT %d,%d ",aSearchStr,aSearchStr,aSearchStr,aSearchStr,aSkip *kLimitNumber,aSkip *kLimitNumber+kLimitNumber];
        
        NSMutableArray * searchArray = [FMDBHelper query:@"__NSDictionaryM"
                                                     where:sql, nil];
        
        successHandler(searchArray);
        
        
    }else {
     
        
        NSString * sql = [NSString stringWithFormat:@"ORDER BY updatedAt desc LIMIT %d,%d ",aSkip *kLimitNumber,aSkip *kLimitNumber+kLimitNumber];
        
        NSMutableArray * searchArray = [FMDBHelper query:@"__NSDictionaryM"
                                                     sql:sql, nil];
        
        successHandler(searchArray);
        
    }
    
    
}

+ (BOOL)updateKeyValues:(NSDictionary *)keyValues href:(NSString *)href {
    
    
   return [FMDBHelper update:@"__NSDictionaryM" keyValues:keyValues where:[NSString stringWithFormat:@"href=%@",href]];
    
    
    
}






@end
