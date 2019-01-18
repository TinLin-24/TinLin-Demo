//
//  StickerBaseView.m
//  Demo
//
//  Created by TinLin on 2018/8/8.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "StickerBaseView.h"

#define margin 15.f

@interface StickerBaseView ()<UIGestureRecognizerDelegate>

/*  */
@property (nonatomic ,strong)UIButton *closeBtn;
/*  */
@property (nonatomic ,strong)UIButton *transformBtn;
/*  */
@property (nonatomic ,strong)UIButton *editBtn;

/*  */
@property (nonatomic ,assign)CGPoint translation;

@end

@implementation StickerBaseView {
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self p_setup];
        [self p_setupSubViews];
        [self p_makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化

- (void)p_setup{
    /* 添加拖动手势 */
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerEvent:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    
    _scale = 1;
    _arg = 0;
}

#pragma mark - 设置子控件

- (void)p_setupSubViews{
    /* contentView 是用于子类添加自定义的样式的View */
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    contentView.layer.borderWidth = .5f;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    [self addSubview:self.closeBtn];
    [self addSubview:self.transformBtn];
    [self addSubview:self.editBtn];
}

#pragma mark - 布局子控件

- (void)p_makeSubViewsConstraints{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(margin, margin, margin, margin));
    }];
    
//    self.contentView.frame = CGRectMake(margin, margin, self.size.width-margin*2, self.size.height-margin*2);
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(margin*2);
        make.top.left.equalTo(self);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(margin*2);
        make.top.right.equalTo(self);
    }];
    
    [self.transformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(margin*2);
        make.bottom.right.equalTo(self);
    }];
    
}

#pragma mark - Action

/**
 View的拖动手势的事件
 */
- (void)panGestureRecognizerEvent:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint p = [panGestureRecognizer translationInView:self.superview];
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

/**
 关闭按钮的事件
 */
- (void)closeBtnClick:(UIButton *)sender{
    [self removeFromSuperview];
}

- (void)editBtnClick:(UIButton *)sender{
    self.transform = CGAffineTransformIdentity;
}

/**
 切换大小按钮的拖动手势的事件
 */
- (void)transformBtnPanGestureRecognizerEvent:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGPoint translationPoint = [panGestureRecognizer translationInView:self.superview];
    CGPoint locationPoint = [panGestureRecognizer locationInView:self.superview];
    
    float an = atan2(locationPoint.y-self.center.y, locationPoint.x-self.center.x);

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        return;
    }
    
    NSLog(@"%f",an);
    self.transform = CGAffineTransformMakeRotation(an-M_PI_4);
//    NSLog(@"%@",NSStringFromCGPoint(locationPoint));
}

#pragma mark - UIGestureRecognizerDelegate

/**
 手势代理方法，控制是否接收响应
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    /* 触摸到三个按钮时不响应拖动手势 */
    if ([touch.view isDescendantOfView:self.closeBtn] || [touch.view isDescendantOfView:self.transformBtn] || [touch.view isDescendantOfView:self.editBtn]) {
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"camera_sticker_off"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)transformBtn{
    if (!_transformBtn) {
        _transformBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transformBtn setImage:[UIImage imageNamed:@"camera_sticker_miter"] forState:UIControlStateNormal];
        /* 按钮添加拖动手势 */
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(transformBtnPanGestureRecognizerEvent:)];
        [_transformBtn addGestureRecognizer:panGestureRecognizer];
    }
    return _transformBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"camera_address_edit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

@end
