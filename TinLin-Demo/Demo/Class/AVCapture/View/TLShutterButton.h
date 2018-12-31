//
//  TLShutterButton.h
//  Demo
//
//  Created by Mac on 2018/12/29.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TLEnableType) {
    TLEnableTypeTap = 0x0001,
    TLEnableTypeLongPress = 0x0002,
    TLEnableTypeAll   = TLEnableTypeTap | TLEnableTypeLongPress
};

@interface TLShutterButton : UIControl

// 是否允许点击
@property (nonatomic, assign, readonly)BOOL enableTap;

// 是否允许长按
@property (nonatomic, assign, readonly)BOOL enableLongPress;

// 长按的最长时间
@property (nonatomic, assign)NSTimeInterval longPressMaxDuration;

//
@property (nonatomic, strong)UIColor *progressColor;

//
@property (nonatomic, assign)CGFloat progressWidth;

//
@property (nonatomic, copy)void (^didTap)(TLShutterButton *sender);

//
@property (nonatomic, copy)void (^didStartLongPress)(TLShutterButton *sender);

//
@property (nonatomic, copy)void (^didEndLongPress)(TLShutterButton *sender);

- (instancetype)initWithFrame:(CGRect)frame EnableType:(TLEnableType)type;

@end
