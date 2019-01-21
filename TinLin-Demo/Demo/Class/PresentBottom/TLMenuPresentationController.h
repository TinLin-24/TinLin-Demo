//
//  TLMenuPresentationController.h
//  Demo
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMenuPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property(nonatomic, assign) CGPoint anchorPoint;

@property(nonatomic, assign) CGPoint arrowPoint;

@end
