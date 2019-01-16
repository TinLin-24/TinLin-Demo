//
//  UIViewController+PresentBottom.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "UIViewController+PresentBottom.h"
#import "TLPresentingViewController.h"
#import "TLPresentationController.h"

@implementation UIViewController (PresentBottom)

- (void)presentViewControllerFromBottom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[TLPresentingViewController class]]) {
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    TLPresentationController *presentationController = [[TLPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}

@end
