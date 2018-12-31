//
//  HeaderViewController.m
//  Demo
//
//  Created by Mac on 2018/12/17.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "HeaderViewController.h"

@interface HeaderViewController ()

//
@property (nonatomic, strong)UIImageView *headerView;

@end

@implementation HeaderViewController
{
    CGFloat _gradientProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)configure {
    [super configure];
    self.title = @"TinLin";
    
    [self.dataSource addObjectsFromArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12]];
    [self.dataSource addObjectsFromArray:@[@13,@14,@15,@16,@17]];

    [self _setupSubViews];
}

///
- (void)_setupSubViews {
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view insertSubview:self.headerView aboveSubview:self.tableView];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11.0,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self _fetchHeaderImageFrame];
    }
}

- (CGRect)_fetchHeaderImageFrame {
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11.0,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        UIColor *tintColor = _gradientProgress < .1f ? [UIColor whiteColor] : [UIColor blackColor];
        UIColor *titleTextColor = _gradientProgress < .1f ? [UIColor blackColor] : [UIColor whiteColor];
        CGFloat alpha = _gradientProgress < .1f ? 0 : _gradientProgress;
        
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.tintColor = tintColor;
        self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [titleTextColor colorWithAlphaComponent:alpha] };
        
        UIColor *color = [UIColor colorWithWhite:1.f alpha:_gradientProgress];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
    self.headerView.frame = [self _fetchHeaderImageFrame];
}

#pragma mark - Cell

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [BaseTableViewCell cellWithTableView:tableView reuseIdentifier:BaseTableViewCellID];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    NSInteger num = [object integerValue];
    cell.textLabel.text = [NSString stringWithFormat:@"number:%zd",num];
}

#pragma mark - Getter & Setter

- (UIImageView *)headerView {
    if (!_headerView) {
        UIImage *image = TLImageNamed(@"12");
        CGFloat height = image.size.height*SCREEN_WIDTH/image.size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        imageView.image = image;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView = imageView;
    }
    return _headerView;
}

@end
