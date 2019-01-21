//
//  TLMenuViewController.m
//  Demo
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLMenuViewController.h"

@interface TLMenuViewController ()

@end

@implementation TLMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

//- (CGSize)preferredContentSize {
//    return CGSizeMake(150.f, 200.f);
//}

- (void)setupSubViews {
    NSArray *icons = @[@"friends",@"QQ",@"qzone",@"sina",@"tencent_weibo",@"wechat"];
    
    CGFloat bgViewHeight = 44.f*icons.count;
    CGFloat arrowHeight = 5.f;
    
    self.preferredContentSize = CGSizeMake(150.f, bgViewHeight+arrowHeight);
    
    CGFloat arrowWH = arrowHeight*2*sqrtf(2);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(120.f, 0, arrowWH, arrowWH)];
    view.backgroundColor = [UIColor whiteColor];
    view.transform = CGAffineTransformMakeRotation(M_PI_4);
    [self.view addSubview:view];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, arrowHeight, 150.f, bgViewHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.f;
    [self.view addSubview:bgView];
    
    for (NSString *icon in icons) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:icon forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bgView addSubview:btn];
        
        [btn addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [bgView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0.f leadSpacing:0.f tailSpacing:0.f];
    [bgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
    }];
}

- (void)handleBtnEvent:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text);
}


@end
