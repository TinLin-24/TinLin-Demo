//
//  TLPresentationController.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLPresentationController.h"

@interface TLPresentationController ()

@property(nonatomic, assign) CGFloat controllerHeight;

@property(nonatomic, strong) UIView *maskView;

@end

@implementation TLPresentationController

#pragma mark - Override

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        self.controllerHeight = [[presentedViewController valueForKey:@"controllerHeight"] floatValue];
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, TLMainScreenHeight-self.controllerHeight, TLMainScreenWidth, self.controllerHeight);
}

- (void)presentationTransitionWillBegin {
    self.maskView.alpha = 0;
    !self.containerView ? : [self.containerView addSubview:self.maskView];
    [UIView animateWithDuration:.5 animations:^{
        self.maskView.alpha = 1.f;
    }];
}

- (void)dismissalTransitionWillBegin {
    [UIView animateWithDuration:.5 animations:^{
        self.maskView.alpha = 0.f;
    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (self.maskView.superview && completed) {
        [self.maskView removeFromSuperview];
    }
}

#pragma mark - Action

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    [TLNotificationDefaultCenter postNotificationName:kTLPresentationControllerDiss object:nil];
}

#pragma mark - Getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.containerView.frame];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
