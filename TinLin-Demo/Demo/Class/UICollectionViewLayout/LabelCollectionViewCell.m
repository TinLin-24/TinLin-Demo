//
//  LabelCollectionViewCell.m
//  Demo
//
//  Created by TinLin on 2019/5/26.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "LabelCollectionViewCell.h"

NSString *const kLabelCollectionViewCellID = @"LabelCollectionViewCell";

@interface LabelCollectionViewCell ()

@property(nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation LabelCollectionViewCell

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

- (void)setup {
    self.backgroundColor = TLRandomColor;
}

- (void)setupSubViews {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = TLFont(18.f, YES);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
}

- (void)makeSubViewsConstraints {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

@end
