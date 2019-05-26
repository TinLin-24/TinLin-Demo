//
//  TestCollectionViewController.m
//  Demo
//
//  Created by TinLin on 2019/5/25.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TestCollectionViewController.h"

#import "TLCollectionViewLayout.h"

#import "LabelCollectionViewCell.h"

@interface TestCollectionViewController () <UICollectionViewDataSource,TLCollectionViewLayoutDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test";
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 1 ? 4 : 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLabelCollectionViewCellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"UICollectionViewSectionHeader"
                                                                                         forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:@"UICollectionViewSectionFooter"
                                                                                         forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor blueColor];
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
        } else if (indexPath.row == 1) {
            return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/4);
        } else {
            return CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        }
    } else {
        if (indexPath.row%2) {
            return CGSizeMake(SCREEN_WIDTH/2-15.f, 50.f);
        } else {
            return CGSizeMake(SCREEN_WIDTH/2-15.f, 100.f);
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return section == 1 ? UIEdgeInsetsZero : UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return section == 1 ? 0.f : 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return section == 1 ? 0.f : 10.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    //    return CGSizeMake(50.f, SCREEN_HEIGHT);
    return CGSizeMake(SCREEN_WIDTH, 50.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    //    return CGSizeMake(10.f, SCREEN_HEIGHT);
    return CGSizeMake(SCREEN_WIDTH, 10.f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout shouldCustomLayoutForItemInSection:(NSInteger)section {
    return section == 1 ? YES : NO;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[TLCollectionViewLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[LabelCollectionViewCell class] forCellWithReuseIdentifier:kLabelCollectionViewCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewSectionHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionViewSectionFooter"];
    }
    return _collectionView;
}

@end
