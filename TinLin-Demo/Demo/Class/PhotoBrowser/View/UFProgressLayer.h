//
//  UFProgressLayer.h
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/**
 显示加载进度的Layer
 */
@interface UFProgressLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;

/**
 开始转动
 */
- (void)startSpin;

/**
 停止转动
 */
- (void)stopSpin;

@end
