//
//  UFPhotoBrowserViewController.h
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFPhotoView.h"

@interface UFPhotoBrowserViewController : UIViewController

/**
 是否弹性动画
 */
@property (nonatomic, assign) BOOL bounces;

+ (instancetype)browserWithPhotoItems:(NSArray<UFPhotoModel *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;

- (instancetype)initWithPhotoItems:(NSArray<UFPhotoModel *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;

- (void)showFromViewController:(UIViewController *)vc;
- (UIImage *)imageForItem:(UFPhotoModel*)item;
- (UIImage *)imageAtIndex:(NSUInteger)index;

@end
