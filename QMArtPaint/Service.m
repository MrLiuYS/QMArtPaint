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
    
    [bquery whereKey:@"showSource" equalTo:@0];
    
    if (aArray) {
        
        [bquery addTheConstraintByOrOperationWithArray:aArray];
        
    }else {
        
        NSMutableArray * constraint = [NSMutableArray array];
        
        //        bool bool_false = false;
        //        [constraint addObject:@{@"showSource":@0}];
        
        [constraint addObject:@{@"tag":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
        [constraint addObject:@{@"author":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
        [constraint addObject:@{@"explain":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
        [constraint addObject:@{@"title":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
        
        [constraint addObject:@{@"related":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
        
        [bquery addTheConstraintByOrOperationWithArray:constraint];
    }
    
    
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            
            failureHandler(error);
            
        } else {
            
            successHandler(array);
            
        }
    }];
    
}


@end
