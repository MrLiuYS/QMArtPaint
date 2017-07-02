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
    
    
    if (aArray) {
        
//        [bquery addTheConstraintByOrOperationWithArray:aArray];
        
        [bquery whereKey:@"author" equalTo:aSearchStr];
        
//        [bquery whereKey:@"tag" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];

        
    }else {
        
        
//        [bquery whereKey:@"showSource" equalTo:@0];
        
//        [bquery whereKey:@"tag" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];
//        [bquery whereKey:@"author" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];
//        [bquery whereKey:@"explain" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];
//        [bquery whereKey:@"title" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];
//        [bquery whereKey:@"related" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",aSearchStr]];
        
        
//        NSMutableArray * constraint = [NSMutableArray array];
//        
//        //        bool bool_false = false;
//        //        [constraint addObject:@{@"showSource":@0}];
//        
//        [constraint addObject:@{@"tag":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
//        [constraint addObject:@{@"author":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
//        [constraint addObject:@{@"explain":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
//        [constraint addObject:@{@"title":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
//        
//        [constraint addObject:@{@"related":@{@"$regex":[NSString stringWithFormat:@".*%@.*",aSearchStr]}}];
//        
//        [bquery addTheConstraintByOrOperationWithArray:constraint];
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
