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

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

//- (CGSize)preferredContentSize {
//    return CGSizeMake(150.f, 200.f);
//}

- (void)setupSubViews {
    
    NSArray *icons = @[@"friends",@"QQ",@"qzone",@"sina",@"tencent_weibo",@"wechat"];
    
    self.preferredContentSize = CGSizeMake(150.f, 44.f*icons.count);

    for (NSString *icon in icons) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:icon forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(handleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0.f leadSpacing:0.f tailSpacing:0.f];
    [self.view.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
    }];
}

- (void)handleBtnEvent:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text);
}


@end
