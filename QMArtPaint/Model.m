//
//  Model.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "Model.h"

#import <BmobSDK/Bmob.h>


@implementation Model

+ (Model *)model:(BmobObject *)aBmob {
    
    Model *model = [[Model alloc]init];
    
    model.author = [aBmob objectForKey:@"author"];
    model.explain = [aBmob objectForKey:@"explain"];
    model.href = [aBmob objectForKey:@"href"];
    model.title = [aBmob objectForKey:@"title"];
    model.imageUrl = [aBmob objectForKey:@"imageUrl"];
    model.thumbnail = [aBmob objectForKey:@"thumbnail"];
    
    model.objectID = aBmob.objectId;
    
    model.thumbWidth = [[aBmob objectForKey:@"thumbWidth"] doubleValue];
    model.thumbHeight = [[aBmob objectForKey:@"thumbHeight"] doubleValue];
    model.readNum = [[aBmob objectForKey:@"readNum"] intValue];
    
    return model;
}

@end
