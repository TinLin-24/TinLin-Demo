//
//  ImageTableViewCell.m
//  Demo
//
//  Created by TinLin on 2018/7/5.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "ImageTableViewCell.h"
#import <Masonry.h>
#import "TestImageModel.h"
#import <UIImageView+WebCache.h>

@interface ImageTableViewCell ()

/*  */
@property (nonatomic ,strong)UIImageView *photoView;

@end

@implementation ImageTableViewCell

-(void)_setup{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor redColor];
}
-(void)_setupSubViews{
    UIImageView *photoView = [[UIImageView alloc] init];
    [photoView setImage:[UIImage imageNamed:@"default_logo"]];
    photoView.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:photoView];
    self.photoView = photoView;
}
-(void)_makeSubViewsConstraints{
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.right.bottom.equalTo(self).offset(-10);
    }];
}

-(void)configModel:(id)model{
    TestImageModel *imageModel=(TestImageModel *)model;
    if (imageModel.image) {
        self.photoView.image = imageModel.image;
    }
    else{
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:[UIImage imageNamed:@"default_logo"]];
    }
}

@end
