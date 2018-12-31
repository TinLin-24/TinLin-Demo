//
//  SystemCameraViewController.m
//  Demo
//
//  Created by Mac on 2018/12/26.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "SystemCameraViewController.h"

#import "TLCameraViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface SystemCameraViewController ()

@end

@implementation SystemCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configure {
    [super configure];
    
    self.title = @"系统相机";
    
    [self _setupSubViews];
}

- (void)_setupSubViews {
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOne setBackgroundColor:[UIColor redColor]];
    [btnOne setTitle:@"拍照" forState:UIControlStateNormal];
    [self.view addSubview:btnOne];

    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TLTopMargin(80.f));
        make.width.mas_equalTo(75.f);
        make.height.mas_equalTo(44.f);
        make.left.mas_equalTo(20.f);
    }];
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTwo setBackgroundColor:[UIColor redColor]];
    [btnTwo setTitle:@"视频" forState:UIControlStateNormal];
    [self.view addSubview:btnTwo];

    [btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(btnOne);
        make.left.equalTo(btnOne.mas_right).offset(20.f);
    }];
    
    UIButton *btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnThree setBackgroundColor:[UIColor redColor]];
    [btnThree setTitle:@"拍照视频" forState:UIControlStateNormal];
    [self.view addSubview:btnThree];
    
    [btnThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(btnTwo);
        make.left.equalTo(btnTwo.mas_right).offset(20.f);
    }];
    
    [btnOne addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnTwo addTarget:self action:@selector(btnTwoAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnThree addTarget:self action:@selector(btnThreeAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action

- (void)btnAction:(UIButton *)sender {
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD tl_showTips:@"不支持相机"];
        return;
    }
    UIImagePickerController *vc = [[TLCameraViewController alloc] initWithCaptureType:TLCaptureTypePhoto];
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)btnTwoAction:(UIButton *)sender {
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD tl_showTips:@"不支持相机"];
        return;
    }
    UIImagePickerController *vc = [[TLCameraViewController alloc] initWithCaptureType:TLCaptureTypeVideo];
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)btnThreeAction:(UIButton *)sender {
    if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD tl_showTips:@"不支持相机"];
        return;
    }
    UIImagePickerController *vc = [[TLCameraViewController alloc] initWithCaptureType:TLCaptureTypeAll];
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
