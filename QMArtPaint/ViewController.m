//
//  ViewController.m
//  QMArtPaint
//
//  Created by 刘永生 on 16/6/8.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "ViewController.h"

#import "WaterCollectionCell.h"
//#import <UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <MJRefresh.h>

#import "DetailViewController.h"
#import "SearchViewController.h"

#define CELL_IDENTIFIER @"WaterCollectionCell"

@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *cellDatas;

@property (nonatomic, assign) int intPage;

@end

@implementation ViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 10;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER
                                                    bundle:nil]
          forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        
        
    }
    return _collectionView;
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SystemVersion floatValue] >= 8.0) {
        self.navigationController.hidesBarsOnSwipe = YES;    
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    
    self.navigationController.hidesBarsOnSwipe = YES;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.intPage = 0;
        
        [Service searchStr:@""
                      skip:self.intPage
                constraint:nil
                   success:^(NSArray * responseObj) {
                       
                       [self.collectionView.mj_header endRefreshing];
                       
                       [self.cellDatas removeAllObjects];
                       
                       [self.cellDatas addObjectsFromArray:responseObj];
                       
                       //                       for (id obj in responseObj) {
                       //                           [self.cellDatas addObject:[Model model:obj]];
                       //                       }
                       
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
                       
                       [self.cellDatas addObjectsFromArray:responseObj];
                       
                       //                       for (id obj in responseObj) {
                       //                           [self.cellDatas addObject:[Model model:obj]];
                       //                       }
                       
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
    
    BmobObject *model = self.cellDatas[indexPath.row];
    
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"thumbnail"]]];
    
    
    if ([[model objectForKey:@"imagesource"] boolValue]) {
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[model objectForKey:@"thumbnail"]]
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }else {
        
        NSString * href = [model objectForKey:@"href"];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:href]
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
    
    cell.imageNameLabel.text = [model objectForKey:@"title"];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BmobObject *model = self.cellDatas[indexPath.row];
    
    [DetailViewController pushInViewController:self bmobObject:model];
    
    
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BmobObject *model = self.cellDatas[indexPath.row];
    
    
    double thumbWidth = [[model objectForKey:@"thumbWidth"] doubleValue];
    double thumbHeight = [[model objectForKey:@"thumbHeight"] doubleValue];
    
    if (thumbHeight > 50) {
        
        return [[NSValue valueWithCGSize:CGSizeMake(thumbWidth, thumbHeight)] CGSizeValue];
    }
    
    return [[NSValue valueWithCGSize:CGSizeMake(thumbWidth, thumbHeight + 50)] CGSizeValue];
    
}


#pragma mark - event

- (IBAction)touchSearch:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"搜索"
                                                    message:@"请输入要搜索的画作信息"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"搜索", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    
}
- (IBAction)touchExpain:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"声明"
                                                    message:@"图片,信息,如没有特殊注明,均来来源于网络.\n如有侵权,请告知.确认属实即删除."
                                                   delegate:nil
                                          cancelButtonTitle:@"明白了"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.view endEditing:YES];
    
    if (buttonIndex == 1) {
        
        UITextField *alertViewTF = [alertView textFieldAtIndex:0];
        
        NSString * searchStr = alertViewTF.text;
        
        [SearchViewController pushInViewController:self searchStr:searchStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
