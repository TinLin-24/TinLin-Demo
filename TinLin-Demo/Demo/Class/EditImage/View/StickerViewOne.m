//
//  StickerViewOne.m
//  Demo
//
//  Created by Mac on 2019/1/21.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "StickerViewOne.h"

@implementation StickerViewOne

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = TLImageNamed(@"nature-1");
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];

    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setText:@""];
    [self.contentView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.contentView);
    }];
}

@end
