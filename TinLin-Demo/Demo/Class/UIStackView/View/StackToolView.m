//
//  StackToolView.m
//  Demo
//
//  Created by TinLin on 2018/8/7.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "StackToolView.h"

@interface StackToolView ()

/*  */
@property (nonatomic ,strong)UIStackView *stackView;

@end

@implementation StackToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 5.f;
        self.layer.shadowOpacity = .3;
        
        [self p_setupSubViews];
    }
    return self;
}

#pragma mark - 设置子控件

- (void)p_setupSubViews{
    [self addSubview:self.stackView];
    
    UIImage *image = [UIImage imageNamed:@"home_suspension_edit"];
    for (int i =0; i<8; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.stackView addArrangedSubview:imageView];
    }
}

#pragma mark - Action

-(void)show{
    CGFloat height = self.height;
    CGFloat top = self.top;
    [UIView animateWithDuration:.25 animations:^{
        self.top = top - height;
    }];
}

-(void)hide{
    CGFloat height = self.height;
    CGFloat top = self.top;
    [UIView animateWithDuration:.25 animations:^{
        self.top = top + height;
    }];
}

#pragma mark - 懒加载

-(UIStackView *)stackView{
    if (!_stackView) {
        CGFloat margin = 5.f;
        _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(margin, margin, self.width-margin*2, self.height-margin*2)];
        /* Axis是坐标轴，负责水平还是垂直 */
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        /* Distribution决定了StackView中子控件的尺寸和位置 */
        _stackView.distribution = UIStackViewDistributionFillEqually;
        /* alignment是对齐方式 */
        _stackView.alignment = NSTextAlignmentCenter;
        /* Space选项允许你通过修改该选项，调整两个控件之间的距离 */
        _stackView.spacing = 10.f;
    }
    return _stackView;
}

@end
