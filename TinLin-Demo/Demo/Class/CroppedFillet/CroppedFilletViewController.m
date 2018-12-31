//
//  CroppedFilletViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/7.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "CroppedFilletViewController.h"

@interface CroppedFilletViewController ()

@end

@implementation CroppedFilletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupSubViews];
}

#pragma mark - 设置子控件

- (void)_setupSubViews{

    UIImage *image = [UIImage imageNamed:@"nature-1"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.layer.shadowColor = [UIColor redColor].CGColor;
//    imageView.layer.shadowOffset = CGSizeMake(10, 10);
//    imageView.layer.shadowRadius = 5.f;
//    imageView.layer.shadowOpacity = .3;
//    imageView.layer.masksToBounds = NO;
//    imageView.layer.cornerRadius = 10;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;

    CGFloat x = 30;
    CGFloat y = 100;
    CGFloat width = SCREEN_WIDTH-x*2;
    CGFloat height = imageHeight * width / imageWidth;
    imageView.frame = CGRectMake(x, y, width, height);
    [self.view addSubview:imageView];
    
    [self p_croppedFillet:imageView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10.f, 10.f)];
}

#pragma mark - 辅助方法

/**
 裁剪圆角
 */
-(void)p_croppedFillet:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.masksToBounds = YES;
    view.layer.mask = maskLayer;
}

@end
