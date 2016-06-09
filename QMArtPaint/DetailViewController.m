//
//  DetailViewController.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

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
