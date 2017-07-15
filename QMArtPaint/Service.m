//
//  Service.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "Service.h"
#import <FMDBHelper.h>

#define kLimitNumber 200

@implementation Service


+ (void)searchStr:(NSString *)aSearchStr
             skip:(int)aSkip
       constraint:(NSArray *)aArray
          success:(requestSuccessBlock)successHandler
          failure:(requestFailureBlock)failureHandler {
    
    
    
    
    
    [Bmob getAllTableSchemasWithCallBack:^(NSArray *tableSchemasArray, NSError *error) {
        
        
        NSMutableArray * keyArray = [NSMutableArray array];
        
        NSMutableArray * tableArray = [NSMutableArray array];
        
        for (BmobTableSchema* bmobTableSchema in tableSchemasArray) {
            //直接用description来查看表结构
            NSLog(@"%@",bmobTableSchema.description);
            
            /*
             分别打印表结构
             */
            //打印表名
            NSLog(@"表名:%@",bmobTableSchema.className);
            
            
            if ([bmobTableSchema.className isEqualToString:@"art"]) {
                
                //打印表结构
                NSDictionary *fields = bmobTableSchema.fields;
                NSArray *allKey = [fields allKeys];
                
                for (NSString *key in allKey) {
                    
                    NSLog(@"列名:%@",key);
                    
                    [keyArray addObject:key];
                    
                    NSString * type = fields[key][@"type"];
                    
                    NSString * valueSql = [NSString stringWithFormat:@"%@ %@",key,type];
                    
                    if ([key isEqualToString:@"href"]) {
                        valueSql = [NSString stringWithFormat:@"%@ PRIMARY KEY",valueSql];
                    }
                    
                    [tableArray addObject:valueSql];
                    
                }
                
                
            }
            
        }
        
        NSString * tableStr = [tableArray componentsJoinedByString:@", "];
        
        tableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS __NSDictionaryM ( %@ )",tableStr];
        
        
        [FMDBHelper createTable:tableStr];
        
        //        @"CREATE TABLE IF NOT EXISTS minghua (href TEXT PRIMARY KEY, title TEXT , related text , tag text , explain text , author text)"
        
        
        
        
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"art"];
        
        bquery.limit = kLimitNumber;
        bquery.skip = aSkip * bquery.limit;
        
        [bquery orderByDescending:@"readNum"];
        
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (error) {
                
                failureHandler(error);
                
            } else {
                
                
                
                for (BmobObject * pObj in array) {
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    
                    for (NSString * pkey in keyArray) {
                        
                        id value = [pObj objectForKey:pkey];
                        
                        [dic setValue:value forKey:pkey];
                        
                    }
                    
                    [FMDBHelper insertObject:dic];
                    
                }
                
                
                successHandler(array);
                
            }
        }];
        
        
        
        
        
        
    }];
    
    
    
    
    
}








@end
