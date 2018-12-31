//
//  UIViewController+TLNavigationController.m
//  Demo
//
//  Created by Mac on 2018/12/17.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "UIViewController+TLNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (TLNavigationController)
@dynamic tl_navigationBarHidden;

- (void)setTl_navigationBarHidden:(BOOL)tl_navigationBarHidden {
    objc_setAssociatedObject(self, @selector(tl_navigationBarHidden), @(tl_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)tl_navigationBarHidden {
    return objc_getAssociatedObject(self, @selector(tl_navigationBarHidden));
}

- (TLNavigationController *)tl_navigationController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[TLNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (TLNavigationController *)vc;
}

@end
