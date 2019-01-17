//
//  TLShareViewController.m
//  Demo
//
//  Created by Mac on 2019/1/16.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLShareViewController.h"

@interface TLShareViewController ()

@end

@implementation TLShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 120.f);
}

- (CGSize)preferredContentSize {
    return CGSizeMake(SCREEN_WIDTH, 120.f);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (int i=0; i<self.view.subviews.count; i++) {
        UIView *subView = self.view.subviews[i];
        subView.transform = CGAffineTransformMakeTranslation(0, 120.f);
        [UIView animateWithDuration:.5f delay:(.1f*i) usingSpringWithDamping:.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            subView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Private

- (void)setupSubViews {
    NSArray *icons = @[@"friends",@"QQ",@"qzone",@"sina",@"tencent_weibo",@"wechat"];
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:icons.count];
    for (NSString *icon in icons) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:TLImageNamed(icon) forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btnArray addObject:btn];
    }
    CGFloat width = (self.view.width - 10*(icons.count+1))/icons.count;
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:width leadSpacing:10.f tailSpacing:10.f];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(width);
    }];
    
//    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10.f leadSpacing:15.f tailSpacing:15.f];
//    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(5.f);
//        make.bottom.equalTo(self.view).offset(-5.f);
//    }];
}

@end
