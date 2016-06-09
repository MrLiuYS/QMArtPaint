//
//  ViewController.h
//  QMArtPaint
//
//  Created by 刘永生 on 16/6/8.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "QMViewController.h"

#import <CHTCollectionViewWaterfallLayout.h>

@interface ViewController : QMViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>


@property (nonatomic, strong) UICollectionView *collectionView;


@end

