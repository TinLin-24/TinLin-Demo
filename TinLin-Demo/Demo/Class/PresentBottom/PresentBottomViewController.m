//
//  PresentBottomViewController.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "PresentBottomViewController.h"
#import "TLPresentingViewController.h"

#import "UIViewController+PresentBottom.h"

@interface PresentBottomViewController ()

@end

@implementation PresentBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Present" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 60, 100, 44);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleBtnEvent:(id)sender {
    TLPresentingViewController *vc = [[TLPresentingViewController alloc] init];
    [self presentViewControllerFromBottom:vc];
}


@end
