//
//  TLCollectionViewLayout.h
//  Demo
//
//  Created by TinLin on 2019/5/25.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TLCollectionViewLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout shouldCustomLayoutForItemInSection:(NSInteger)section;

@end

@interface TLCollectionViewLayout : UICollectionViewFlowLayout

//@property (nonatomic, weak) id<TLCollectionViewLayoutDelegate> delegate;

//@property (nonatomic, weak) id<RACollectionViewTripletLayoutDatasource> datasource;

@end

NS_ASSUME_NONNULL_END
