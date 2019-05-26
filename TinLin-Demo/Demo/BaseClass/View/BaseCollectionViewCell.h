//
//  BaseCollectionViewCell.h
//  Demo
//
//  Created by TinLin on 2019/5/26.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kBaseCollectionViewCellID;

@interface BaseCollectionViewCell : UICollectionViewCell

#pragma mark - 设置子控件

/* 设置 */
- (void)setup;
/* 设置子视图 */
- (void)setupSubViews;
/* 布局子视图 */
- (void)makeSubViewsConstraints;

@end

NS_ASSUME_NONNULL_END
