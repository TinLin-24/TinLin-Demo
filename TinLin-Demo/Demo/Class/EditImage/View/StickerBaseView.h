//
//  StickerBaseView.h
//  Demo
//
//  Created by TinLin on 2018/8/8.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerBaseView : UIView

/**
 contentView 是用于子类添加自定义的样式的View
 */
@property(nonatomic, strong, readonly) UIView *contentView;


@end
