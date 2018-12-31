//
//  StackViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/6.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "StackViewController.h"

#import "StackToolView.h"

/**
 IStackView 类提供了一个高效的接口用于平铺一行或一列的视图组合，stackView提供了高效的单行单列自动布局的手段，一般情况下，我们不需要对stackView.subviews做任何约束，只需要通过对stackView的axis, distribution, alignment, spacing属性进行修改
 UIStackView 可以多个嵌套
 https://www.jianshu.com/p/213702004d0d
 */

@interface StackViewController ()

/*  */
@property (nonatomic ,strong)UIStackView *stackView;

/*  */
@property (nonatomic ,strong)StackToolView *toolView;

@end

@implementation StackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupNavigationItem];
    
    [self _setupSubViews];
    
}

#pragma mark - 设置导航栏

- (void)_setupNavigationItem{
    UIBarButtonItem *rightBarButtonItem_add = [[UIBarButtonItem alloc] initWithTitle:@"加图片" style:UIBarButtonItemStyleDone target:self action:@selector(addImageView:)];
    
    UIBarButtonItem *rightBarButtonItem_remove = [[UIBarButtonItem alloc] initWithTitle:@"减图片" style:UIBarButtonItemStyleDone target:self action:@selector(removeImageView:)];
    
    UIBarButtonItem *rightBarButtonItem_toolBar = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarClick:)];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem_add,rightBarButtonItem_remove,rightBarButtonItem_toolBar];
}

#pragma mark - 设置子控件

- (void)_setupSubViews{
    [self.view addSubview:self.stackView];
    
    for (int i=0;i<3;i++) {
        NSString *imageName = [self _fetchImageName];
        /* 这里要使用addArrangedSubview方法 */
        [self.stackView addArrangedSubview:[self _fetchImageViewWithImageName:imageName]];
    }
    
    [self.view addSubview:self.toolView];
    
    /* 小菊花Loading */
//    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [indicatorView setFrame:CGRectMake(100, 100, 44, 44)];
//    [self.view addSubview:indicatorView];
//    [indicatorView startAnimating];
}

#pragma mark - Action

-(void)addImageView:(UIBarButtonItem *)sender{
    NSString *imageName = [self _fetchImageName];
    NSInteger index = 0;//random()%(self.stackView.arrangedSubviews.count-1);
    [self.stackView insertArrangedSubview:[self _fetchImageViewWithImageName:imageName] atIndex:index];
    [self _stackViewlayoutIfNeeded];
}

-(void)removeImageView:(UIBarButtonItem *)sender{
    NSArray *subviews = self.stackView.arrangedSubviews;
    if (subviews.count>0) {
        UIView *subview = subviews.firstObject;
        [self.stackView removeArrangedSubview:subview];
        [subview removeFromSuperview];
        [self _stackViewlayoutIfNeeded];
    }
}

-(void)toolBarClick:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"hide"]) {
        [self.toolView hide];
        sender.title = @"show";
    }
    else if ([sender.title isEqualToString:@"show"]) {
        [self.toolView show];
        sender.title = @"hide";
    }
}

#pragma mark - 辅助方法

-(UIImageView *)_fetchImageViewWithImageName:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectZero;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4.f;
    return imageView;
}

-(NSString *)_fetchImageName{
    NSString *imageName = [NSString stringWithFormat:@"nature-%zd",random()%3+1];
    return imageName;
}

-(void)_stackViewlayoutIfNeeded{
    [UIView animateWithDuration:1.0 animations:^{
        [self.stackView layoutIfNeeded];
    }];
}

#pragma mark - 懒加载

-(UIStackView *)stackView{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-20)];
        /* Axis是坐标轴，负责水平还是垂直 */
        _stackView.axis = UILayoutConstraintAxisVertical;
        /* Distribution决定了StackView中子控件的尺寸和位置 */
        _stackView.distribution = UIStackViewDistributionFillEqually;
        /* alignment是对齐方式 */
        _stackView.alignment = NSTextAlignmentCenter;
        /* Space选项允许你通过修改该选项，调整两个控件之间的距离 */
        _stackView.spacing = 10.f;
    }
    return _stackView;
}

-(StackToolView *)toolView{
    if (!_toolView) {
        _toolView = [[StackToolView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 55)];
    }
    return _toolView;
}

@end
