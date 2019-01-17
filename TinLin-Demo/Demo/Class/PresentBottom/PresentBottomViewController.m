//
//  PresentBottomViewController.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "PresentBottomViewController.h"
#import "TLShareViewController.h"
#import "TLCustomBottomViewController.h"

#import "TLPresentationController.h"

@interface PresentBottomViewController ()

@end

@implementation PresentBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Present" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, TLTopMargin(84.f), 100, 44);
    [self.view addSubview:btn];

    [btn addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(20, TLTopMargin(124.f), 100, 44);
    [self.view addSubview:shareBtn];

    [shareBtn addTarget:self action:@selector(handleShareBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setTitle:@"Custom" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    customBtn.frame = CGRectMake(20, TLTopMargin(164.f), 100, 44);
    [self.view addSubview:customBtn];
    
    [customBtn addTarget:self action:@selector(handleCustomBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleBtnEvent:(id)sender {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 300.f);
    viewController.view.backgroundColor = [UIColor whiteColor];
    TLPresentationController *presentationController = [[TLPresentationController alloc] initWithPresentedViewController:viewController presentingViewController:self];
    viewController.transitioningDelegate = presentationController;
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)handleShareBtnEvent:(id)sender {
    TLShareViewController *viewController = [[TLShareViewController alloc] init];
    TLPresentationController *presentationController = [[TLPresentationController alloc] initWithPresentedViewController:viewController presentingViewController:self];
    viewController.transitioningDelegate = presentationController;
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)handleCustomBtnEvent:(id)sender {
    TLCustomBottomViewController *viewController = [[TLCustomBottomViewController alloc] init];
    TLPresentationController *presentationController = [[TLPresentationController alloc] initWithPresentedViewController:viewController presentingViewController:self];
    viewController.transitioningDelegate = presentationController;
    [self presentViewController:viewController animated:YES completion:NULL];
}

@end
