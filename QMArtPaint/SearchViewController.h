//
//  SearchViewController.h
//  QMArtPaint
//
//  Created by 刘永生 on 16/6/12.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "QMViewController.h"

#import <CHTCollectionViewWaterfallLayout.h>

@interface SearchViewController : QMViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *searchStr;

+ (void)pushInViewController:(UIViewController *)aViewController
                   searchStr:(NSString *)aSearchStr;

@end
