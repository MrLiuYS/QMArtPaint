//
//  DetailViewController.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+WebCache.h>
#import <MWPhotoBrowser.h>

@interface DetailViewController () {
    
    
    __weak IBOutlet NSLayoutConstraint *_artImageViewHeight;
    
    
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    int readNum = [[_bmobObject objectForKey:@"readNum"] intValue];
    
    NSLog(@"更新前:readnum:%d",readNum);
    
    [_bmobObject setObject:[NSNumber numberWithInt:++readNum] forKey:@"readNum"];
    
    [_bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"更新后:readnum:%d",[[_bmobObject objectForKey:@"readNum"] intValue]);
            
        } else {
            NSLog(@"%@",error);
        }
    }];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@-%@",[_bmobObject objectForKey:@"title"],
                        [_bmobObject objectForKey:@"author"]];
    
    _artExpalinLabel.text = [_bmobObject objectForKey:@"explain"];
    
    
    double thumbWidth = [[_bmobObject objectForKey:@"thumbWidth"] doubleValue];
    double thumbHeight = [[_bmobObject objectForKey:@"thumbHeight"] doubleValue];
    
    _artImageViewHeight.constant = _artImageView.frame.size.width/thumbWidth * thumbHeight;
    
    [_artImageView sd_setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"imageUrl"]]
                     placeholderImage:nil];
    
    
    //    [_artImageView sd_setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"thumbnail"]]
    //                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //                                
    //                                [_artImageView sd_setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"imageUrl"]]
    //                                                 placeholderImage:image];
    //                            }];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)pushInViewController:(UIViewController *)aViewController bmobObject:(BmobObject *)aBmobObject{
    
    DetailViewController * ctrl = [DetailViewController detailViewController];
    
    ctrl.bmobObject = aBmobObject;
    
    [aViewController.navigationController pushViewController:ctrl animated:YES];
    
}

+ (DetailViewController *)detailViewController {
    
    DetailViewController *ctrl = [[DetailViewController alloc]initWithNibName:@"DetailViewController"
                                                                       bundle:nil];
    
    return ctrl;
}

@end
