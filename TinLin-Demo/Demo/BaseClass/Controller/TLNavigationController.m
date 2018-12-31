//
//  TLNavigationController.m
//  Demo
//
//  Created by Mac on 2018/12/14.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLNavigationController.h"

@interface TLNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation TLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak TLNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    /// 统一的返回按钮图片
    self.navigationBar.backIndicatorImage = self.navigationBar.backIndicatorTransitionMaskImage = TLImageNamed(@"back");
    self.navigationBar.tintColor = [UIColor blackColor];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = YES;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]
        && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    /// 这里需要设置 backBarButtonItem的title为空来隐藏文本
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(_backItemDidClicked)];
    [super pushViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]
        && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]
        && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - Action

- (void)_backItemDidClicked {
    [self popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.navigationBarHidden != viewController.tl_navigationBarHidden) {
        [self setNavigationBarHidden:viewController.tl_navigationBarHidden animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] &&
        self.viewControllers.count > 1 &&
        [self.visibleViewController isEqual:[self.viewControllers lastObject]]) {
        //判断当导航堆栈中存在页面，并且 可见视图 如果不是导航堆栈中的最后一个视图时，就会屏蔽掉滑动返回的手势。此设置是为了避免页面滑动返回时因动画存在延迟所导致的卡死。
        return YES;
    } else {
        return NO;
    }
}

@end
