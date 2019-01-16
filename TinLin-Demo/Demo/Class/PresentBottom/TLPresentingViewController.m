//
//  TLPresentingViewController.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLPresentingViewController.h"
#import "TLPresentationController.h"

@interface TLPresentingViewController ()

@end

@implementation TLPresentingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_croppedFillet:self.view byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    
    [TLNotificationDefaultCenter addObserver:self selector:@selector(dismissViewController) name:kTLPresentationControllerDiss object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"bounds:%@",NSStringFromCGRect(self.view.bounds));
}

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

- (void)dealloc {
    [TLNotificationDefaultCenter removeObserver:self];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//控制弹出视图的高度
- (CGFloat)controllerHeight {
    return 400.f;
}

@end
