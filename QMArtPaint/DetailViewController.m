//
//  DetailViewController.m
//  QMArtPaint
//
//  Created by 潘玉琳 on 16/6/9.
//  Copyright © 2016年 刘永生. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

//#import <UIImageView+WebCache.h>
#import <MWPhotoBrowser.h>

#import "TagCollectionCell.h"
#import "SearchViewController.h"

static NSString * const idenTagCollectionCell = @"TagCollectionCell";


@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
MWPhotoBrowserDelegate> {
    
    __weak IBOutlet UICollectionView *_tagCollectionView;
    
    __weak IBOutlet NSLayoutConstraint *_artImageViewHeight;
    
    
}

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *relateds;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SystemVersion floatValue] >= 8.0) {
        self.navigationController.hidesBarsOnSwipe = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([SystemVersion floatValue] >= 8.0) {
        self.navigationController.hidesBarsOnSwipe = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self readNum];
    
    [self.tags addObjectsFromArray:[[_bmobObject objectForKey:@"tag"] componentsSeparatedByString:@" "]];
    
    
    [self defaultUI];
    
    
    [GQMAdSupper showTableScreenInViewController:self];
    
}

- (void)defaultUI {
    
    self.title = [NSString stringWithFormat:@"%@-%@",[_bmobObject objectForKey:@"title"],
                  [_bmobObject objectForKey:@"author"]];
    
    _artExpalinLabel.text = [_bmobObject objectForKey:@"explain"];
    
    double thumbWidth = [[_bmobObject objectForKey:@"thumbWidth"] doubleValue];
    
    double thumbHeight = [[_bmobObject objectForKey:@"thumbHeight"] doubleValue];
    
    _artImageViewHeight.constant = _artImageView.frame.size.width/thumbWidth * thumbHeight;
    
    //        [_artImageView setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"imageUrl"]]
    //           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    if ([[_bmobObject objectForKey:@"imagesource"] boolValue]) {
        
        [_artImageView setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"thumbnail"]]
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }else {
        
        NSString * href = [_bmobObject objectForKey:@"href"];
        
        [_artImageView setImageWithURL:[NSURL URLWithString:href]
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
    //    [_artImageView sd_setImageWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"imageUrl"]]];
    
    
    [_tagCollectionView registerNib:[UINib nibWithNibName:@"TagCollectionCell" bundle:nil]
         forCellWithReuseIdentifier:idenTagCollectionCell];
    
    
}

/**
 *  阅读次数加1
 */
- (void)readNum {
    
    int readNum = [[_bmobObject objectForKey:@"readNum"] intValue];
    
    [_bmobObject setObject:[NSNumber numberWithInt:++readNum] forKey:@"readNum"];
    
    [_bmobObject updateInBackgroundWithResultBlock:nil];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _tagCollectionView) {
        return 1;
    }
    return 0;
    
    //    return self.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _tagCollectionView) {
        
        return self.tags.count;
    }
    
    return 0;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TagCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenTagCollectionCell forIndexPath:indexPath];
    
    NSString * tag = self.tags[indexPath.row];
    
    cell.tagLabel.text = tag;
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * tag = self.tags[indexPath.row];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGSize textSize = [tag boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * tag = self.tags[indexPath.row];
    
    [SearchViewController pushInViewController:self searchStr:tag];
    
}


- (IBAction)touchImageView:(id)sender {
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    MWPhoto *photo;
    
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:[_bmobObject objectForKey:@"imageUrl"]]];
    photo.caption = [NSString stringWithFormat:@"%@-%@",[_bmobObject objectForKey:@"title"],
                     [_bmobObject objectForKey:@"author"]];;
    [photos addObject:photo];
    
    self.photos = photos;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - proprety

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc]init];
    }
    return _tags;
}
- (NSMutableArray *)relateds {
    if (!_relateds) {
        _relateds = [[NSMutableArray alloc]init];
    }
    return _relateds;
}


#pragma mark - Public

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
