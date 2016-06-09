//
//  Model.h
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BmobObject;
@interface Model : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *explain;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, retain) NSArray *relateds;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *thumbnail;

+ (Model *)model:(BmobObject *)aBmob;


@end
