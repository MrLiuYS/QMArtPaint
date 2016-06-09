//
//  DetailViewController.h
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "QMViewController.h"

@interface DetailViewController : QMViewController

@property (nonatomic, strong) BmobObject *bmobObject;


+ (void)pushInViewController:(UIViewController *)aViewController bmobObject:(BmobObject *)aBmobObject;

@end
