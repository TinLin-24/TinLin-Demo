//
//  UIViewController+TLNavigationController.m
//  Demo
//
//  Created by Mac on 2018/12/17.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "UIViewController+TLNavigationController.h"
#import "NSObject+RunTime.h"
#import <objc/runtime.h>

@implementation UIViewController (TLNavigationController)
@dynamic tl_navigationBarHidden;
@dynamic tl_navigationBarBackgroundImage;

+ (void)load {
//    swizzleMethod([UIViewController class], @selector(viewWillAppear:), @selector(tl_viewWillAppear:));
//    swizzleMethod([UIViewController class], @selector(viewWillDisappear:), @selector(tl_viewWillDisappear:));
}

- (void)tl_viewWillAppear:(BOOL)animated {
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.navigationController.navigationBar setBackgroundImage:self.tl_navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled]) {
            [self.navigationController.navigationBar setBackgroundImage:self.tl_navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        }
    }];
    [self tl_viewWillAppear:animated];
}

- (void)tl_viewWillDisappear:(BOOL)animated {
//    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        if ([context isCancelled]) {
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        }
//    }];
    [self tl_viewWillDisappear:animated];
}

- (void)setTl_navigationBarHidden:(BOOL)tl_navigationBarHidden {
    objc_setAssociatedObject(self, @selector(tl_navigationBarHidden), @(tl_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)tl_navigationBarHidden {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTl_navigationBarBackgroundImage:(UIImage *)tl_navigationBarBackgroundImage {
    objc_setAssociatedObject(self, @selector(tl_navigationBarBackgroundImage), tl_navigationBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)tl_navigationBarBackgroundImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (TLNavigationController *)tl_navigationController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[TLNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (TLNavigationController *)vc;
}

@end
