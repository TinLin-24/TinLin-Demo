//
//  LabelCollectionViewCell.h
//  Demo
//
//  Created by TinLin on 2019/5/26.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kLabelCollectionViewCellID;

@interface LabelCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong, readonly) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
