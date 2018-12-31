//
//  TLAVCaptureViewController.m
//  Demo
//
//  Created by Mac on 2018/12/28.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLAVCaptureViewController.h"

#import "TLShutterButton.h"

@interface TLAVCaptureViewController ()

@end

@implementation TLAVCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self _setupSubViews];
}

///
- (void)_setupSubViews {
    TLShutterButton *btn = [[TLShutterButton alloc] initWithFrame:CGRectMake(0, TLTopMargin(64.f), 125, 125) EnableType:TLEnableTypeAll];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

@end
