//
//  UFPhotoView.h
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFProgressLayer.h"

/* 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。*/
//NS_ASSUME_NONNULL_BEGIN

extern const CGFloat UFPhotoViewPadding;

@protocol UFImageManager;
@class UFPhotoModel;

@interface UFPhotoView : UIScrollView

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UFProgressLayer *progressLayer;

@property (nonatomic, strong, readonly) UFPhotoModel *item;

- (instancetype)initWithFrame:(CGRect)frame imageManager:(id<UFImageManager>)imageManager;
- (void)setItem:(UFPhotoModel *)item determinate:(BOOL)determinate;
- (void)resizeImageView;
- (void)cancelCurrentImageLoad;

@end

//NS_ASSUME_NONNULL_END
