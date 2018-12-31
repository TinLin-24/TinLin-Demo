//
//  PropertyAnimatorViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/6.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "PropertyAnimatorViewController.h"

@interface PropertyAnimatorViewController ()

/*  */
@property (nonatomic ,strong)UIImageView *imageView;

/*  */
@property (nonatomic ,strong)UIVisualEffectView *effectView;

/*  */
@property (nonatomic ,strong)UIViewPropertyAnimator *animator;

@end

@implementation PropertyAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupSubViews];
    
    self.tl_navigationBarHidden = YES;
    //[self.navigationController setNavigationBarHidden:YES];
#ifdef RT_INTERACTIVE_PUSH
    self.rt_disableInteractivePop = NO;
#endif
}

- (void)dealloc{
    /* 释放一个暂停或停止状态的属性动画器是错误的,属性动画器必须完成动画制作或明确停止并完成才能释放 */
    /* 明确停止 */
    [self.animator pauseAnimation];
    [self.animator stopAnimation:YES];
    /* 可以调用完成的位置 */
    [self.animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
}

#pragma mark - 设置子控件

- (void)_setupSubViews{
    [self.view addSubview:self.imageView];
    
    [self.imageView addSubview:self.effectView];
    
    /* 核心代码，控制 animator 的 fractionComplete 值即可控制 blur 的级别，另外， duration 在这并不重要，因为我们将手动设置 animator 的完成度 */
    @weakify(self);
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:5.f curve:UIViewAnimationCurveLinear animations:^{
        @strongify(self);
        /* 这里是核心，这样控制 fractionComplete 就可以控制视图的模糊效果在系统默认级别和无模糊效果之间过渡了 */
        self.effectView.effect = nil;
    }];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - 64, SCREEN_WIDTH-60, 44)];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

#pragma mark -

-(void)valueChanged:(UISlider *)slider{
    /* 控制 animator 的完成度以达到控制 Blur 级别的效果 */
    self.animator.fractionComplete = slider.value;
    //self.imageView.alpha = slider.value;
}

#pragma mark - 懒加载

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _imageView.image = [UIImage imageNamed:@"10"];
    }
    return _imageView;
}

-(UIVisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.frame];
        _effectView.autoresizingMask = UIViewAutoresizingNone;
        _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    return _effectView;
}

@end
