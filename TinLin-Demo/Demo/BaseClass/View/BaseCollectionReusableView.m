//
//  BaseCollectionReusableView.m
//  Demo
//
//  Created by TinLin on 2019/5/26.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "BaseCollectionReusableView.h"

NSString *const kBaseCollectionHeaderViewID = @"kBaseCollectionHeaderViewID";
NSString *const kBaseCollectionFooterViewID = @"kBaseCollectionFooterViewID";

@interface BaseCollectionReusableView ()

@end

@implementation BaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupSubViews];
        [self makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 设置子控件

- (void)setup{
    
}
- (void)setupSubViews{
    
}
- (void)makeSubViewsConstraints{
    
}

@end
