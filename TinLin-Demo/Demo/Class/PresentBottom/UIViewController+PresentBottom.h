//
//  UIViewController+PresentBottom.h
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PresentBottom) <UIViewControllerTransitioningDelegate>

- (void)presentViewControllerFromBottom:(UIViewController *)viewController;

@end
