//
//  EditImageViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/8.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "EditImageViewController.h"
#import "StickerBaseView.h"
#import "GYStickerView.h"
#import "StickerViewOne.h"

@interface EditImageViewController ()

@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片编辑 -> 贴纸";
    
    self.view.backgroundColor = [UIColor grayColor];
    [self p_setupSubViews];
    [self p_setupNavigationItem];
}

#pragma mark - 设置导航栏

- (void)p_setupNavigationItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,saveBarButtonItem];
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender{
    [self p_setupSubViews];
}

- (void)saveBarButtonItemClick:(UIBarButtonItem *)sender {

}

#pragma mark - 设置子控件

- (void)p_setupSubViews{
    StickerBaseView *tlview = [[StickerViewOne alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    [self.view addSubview:tlview];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode"]];
//    imageView.frame = CGRectMake(100, 100, 150, 150);
//    GYStickerView *view = [[GYStickerView alloc] initWithContentView:imageView];
//    view.ctrlType = GYStickerViewCtrlTypeOne;
//    [view setRemoveCtrlImage:[UIImage imageNamed:@"camera_sticker_off"]];
//    [view setTransformCtrlImage:[UIImage imageNamed:@"camera_sticker_miter"]];
//    [self.view addSubview:view];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
//    label.text = @"";
//    label.numberOfLines = 0;
//    label.textColor = [UIColor redColor];
//    GYStickerView *view = [[GYStickerView alloc] initWithContentView:label];
//    view.ctrlType = GYStickerViewCtrlTypeOne;
//    [view setRemoveCtrlImage:[UIImage imageNamed:@"camera_sticker_off"]];
//    [view setTransformCtrlImage:[UIImage imageNamed:@"camera_sticker_miter"]];
//    [self.view addSubview:view];
}

@end
