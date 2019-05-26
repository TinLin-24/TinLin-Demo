//
//  TLCollectionViewLayout.m
//  Demo
//
//  Created by TinLin on 2019/5/25.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLCollectionViewLayout.h"

@interface TLCollectionViewLayout ()

@property (nonatomic, weak) id<TLCollectionViewLayoutDelegate> delegate;

@property (nonatomic, weak) id<UICollectionViewDataSource> datasource;

//存放每一个cell的属性
@property(nonatomic, strong) NSMutableArray *attributesArray;

@property(nonatomic, assign) CGFloat contentOffsetY;

@property(nonatomic, assign) CGFloat contentOffsetX;

@end

@implementation TLCollectionViewLayout


/*
 -(CGSize)collectionViewContentSize
 返回collectionView的内容的尺寸
 
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 返回rect中的所有的元素的布局属性
 返回的是包含UICollectionViewLayoutAttributes的NSArray
 UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 layoutAttributesForCellWithIndexPath:
 layoutAttributesForSupplementaryViewOfKind:withIndexPath:
 layoutAttributesForDecorationViewOfKind:withIndexPath:
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的cell的布局属性
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。s
 */


- (void)prepareLayout {
    [super prepareLayout];
    self.attributesArray = [[NSMutableArray alloc] init];
    self.contentOffsetY = 0.f;
    
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int section= 0; section<sectionCount; section++) {
        NSUInteger  itemCount = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGPoint headerAttributesOrigin = CGPointMake(headerAttributes.frame.origin.x, headerAttributes.frame.origin.y+self.contentOffsetY);
        CGSize headerAttributesSize = headerAttributes.frame.size;
        headerAttributes.frame = CGRectMake(headerAttributesOrigin.x, headerAttributesOrigin.y, headerAttributesSize.width, headerAttributesSize.height);
        [self.attributesArray addObject:headerAttributes];
        CGFloat headerY = CGRectGetMaxY(headerAttributes.frame);
        for (int row=0; row<itemCount; row++) {
            UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            BOOL isNeed = [self fetchShouldCustomLayoutForItemInSection:section];
            UIEdgeInsets sectionInset = [self fetchInsetForSectionAtIndex:section];
            CGFloat minimumLineSpacing = [self fetchMinimumLineSpacingForSectionAtIndex:section];
            CGFloat minimumInteritemSpacing = [self fetchMinimumInteritemSpacingForSectionAtIndex:section];
            if (isNeed) {
                self.contentOffsetY = -SCREEN_WIDTH/4;
                if (row == 0) {
                    CGPoint origin = CGPointMake(attributes.frame.origin.x, headerY);
                    CGSize size = attributes.frame.size;
                    attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
                } else if (row == 1) {
                    CGPoint origin = CGPointMake(attributes.frame.origin.x, headerY);
                    CGSize size = attributes.frame.size;
                    attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
                } else if (row == 2) {
                    CGPoint origin = CGPointMake(SCREEN_WIDTH/2, headerY+SCREEN_WIDTH/4);
                    CGSize size = attributes.frame.size;
                    attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
                } else if (row == 3) {
                    CGPoint origin = CGPointMake(SCREEN_WIDTH*3/4, headerY+SCREEN_WIDTH/4);
                    CGSize size = attributes.frame.size;
                    attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
                } else {
                    CGPoint origin = CGPointMake(attributes.frame.origin.x, attributes.frame.origin.y+self.contentOffsetY);
                    CGSize size = attributes.frame.size;
                    attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
                }
            } else {
                CGPoint attributesOrigin = CGPointMake(attributes.frame.origin.x, attributes.frame.origin.y+self.contentOffsetY);
                CGSize attributesSize = attributes.frame.size;
                attributes.frame = CGRectMake(attributesOrigin.x, attributesOrigin.y, attributesSize.width, attributesSize.height);
            }
            [self.attributesArray addObject:attributes];
        }
        UICollectionViewLayoutAttributes *footerAttributes = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGPoint footerAttributesOrigin = CGPointMake(footerAttributes.frame.origin.x, footerAttributes.frame.origin.y+self.contentOffsetY);
        CGSize footerAttributesSize = footerAttributes.frame.size;
        footerAttributes.frame = CGRectMake(footerAttributesOrigin.x, footerAttributesOrigin.y, footerAttributesSize.width, footerAttributesSize.height);
        [self.attributesArray addObject:footerAttributes];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (CGSize)collectionViewContentSize {
    CGSize collectionViewContentSize = [super collectionViewContentSize];
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return collectionViewContentSize;
    } else {
        collectionViewContentSize.height += self.contentOffsetY;
        return collectionViewContentSize;
    }
}

#pragma mark - Other

- (BOOL)fetchShouldCustomLayoutForItemInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:shouldCustomLayoutForItemInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self shouldCustomLayoutForItemInSection:section];
    }
    return NO;
}

- (UIEdgeInsets)fetchInsetForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

- (CGFloat)fetchMinimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

- (CGFloat)fetchMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

#pragma mark - Getter

- (id<TLCollectionViewLayoutDelegate>)delegate {
    return (id<TLCollectionViewLayoutDelegate>) self.collectionView.delegate;
}

- (id<UICollectionViewDataSource>)datasource {
    return self.collectionView.dataSource;
}

@end
