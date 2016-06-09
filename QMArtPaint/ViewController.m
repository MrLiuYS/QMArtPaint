//
//  ViewController.m
//  QMArtPaint
//
//  Created by 刘永生 on 16/6/8.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "ViewController.h"

#import "WaterCollectionCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELL_IDENTIFIER @"WaterCollectionCell"

@interface ViewController ()

@property (nonatomic, strong) NSArray *cellSizes;

@property (nonatomic, strong) NSMutableArray *cellDatas;

@property (nonatomic, assign) int intPage;

@end

@implementation ViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER
                                                    bundle:nil]
          forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        
        
    }
    return _collectionView;
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(400, 550)],
                       [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                       [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                       [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                       ];
    }
    return _cellSizes;
}



- (NSMutableArray *)cellDatas {
    if (!_cellDatas) {
        _cellDatas = [[NSMutableArray alloc]init];
    }
    return _cellDatas;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.intPage = 0;
        
        [Service searchStr:@""
                      skip:self.intPage
                constraint:nil
                   success:^(NSArray * responseObj) {
                       
                       [self.collectionView.mj_header endRefreshing];
                       
                       [self.cellDatas removeAllObjects];
                       
                       for (id obj in responseObj) {
                           [self.cellDatas addObject:[Model model:obj]];
                       }
                       
                       [self.collectionView reloadData];
                       
                   } failure:^(NSError *error) {
                       
                       [self.collectionView.mj_header endRefreshing];
                       
                       NSLog(@"failure:%@",error);
                       
                   }];
        
        
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        self.intPage ++;
        
        [Service searchStr:@""
                      skip:self.intPage
                constraint:nil
                   success:^(NSArray * responseObj) {
                       
                       [self.collectionView.mj_footer endRefreshing];
                       
                       for (id obj in responseObj) {
                           [self.cellDatas addObject:[Model model:obj]];
                       }
                       
                       [self.collectionView reloadData];
                       
                   } failure:^(NSError *error) {
                       
                       [self.collectionView.mj_footer endRefreshing];
                       
                       NSLog(@"failure:%@",error);
                       
                   }];
        
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDatas.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterCollectionCell *cell =
    (WaterCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                     forIndexPath:indexPath];
    
    Model *model = self.cellDatas[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]
                      placeholderImage:nil];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
//    
//    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:HEADER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:FOOTER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    }
//    
//    return reusableView;
//}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
