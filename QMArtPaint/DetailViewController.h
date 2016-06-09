//
//  DetailViewController.h
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "QMViewController.h"

@interface DetailViewController : QMViewController {
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UIImageView *_artImageView;
    
    __weak IBOutlet UILabel *_artExpalinLabel;
    
    
}

@property (nonatomic, strong) BmobObject *bmobObject;


+ (void)pushInViewController:(UIViewController *)aViewController bmobObject:(BmobObject *)aBmobObject;

@end
