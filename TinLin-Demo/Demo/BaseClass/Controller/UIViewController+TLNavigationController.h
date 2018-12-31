//
//  UIViewController+TLNavigationController.h
//  Demo
//
//  Created by Mac on 2018/12/17.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLNavigationController;

@interface UIViewController (TLNavigationController)

//
@property (nonatomic, assign)BOOL tl_navigationBarHidden;

//
@property (nonatomic, strong, readonly)TLNavigationController *tl_navigationController;

@end
