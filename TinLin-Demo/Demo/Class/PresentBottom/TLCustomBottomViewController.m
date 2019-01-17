//
//  TLCustomBottomViewController.m
//  Demo
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLCustomBottomViewController.h"

@interface TLCustomBottomViewController ()

@property(nonatomic, strong) UISlider *slider;

@end

@implementation TLCustomBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISlider *slider = [[UISlider alloc] init];
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44.f);
        make.left.equalTo(self.view).offset(50.f);
        make.right.equalTo(self.view).offset(-50.f);
        make.bottom.equalTo(self.view).offset(-5.f);
    }];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

// 方向旋转的时候
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    // When the current trait collection changes (e.g. the device rotates),
    // update the preferredContentSize.
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
    self.slider.maximumValue = self.preferredContentSize.height;
    self.slider.minimumValue = 220.f;
    self.slider.value = self.slider.maximumValue;
}

- (void)sliderValueChange:(UISlider*)sender {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

@end
