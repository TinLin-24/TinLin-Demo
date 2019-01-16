//
//  UFPhotoBrowserViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "UFPhotoBrowserViewController.h"
#import "UFPhotoView.h"
#import "UFSDImageManager.h"
#import "UFPhotoModel.h"

static const NSTimeInterval kAnimationDuration = 0.33;
static const NSTimeInterval kSpringAnimationDuration = 0.5;
static const CGFloat kPageIndicatorHeight = 20;
static const CGFloat kPageIndicatorTopSpacing = 40;

@interface UFPhotoBrowserViewController ()<UIScrollViewDelegate,UIViewControllerTransitioningDelegate,CAAnimationDelegate>
{
    CGPoint _startLocation;
}

/* 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/* 保存模型 */
@property (nonatomic, strong) NSMutableArray *photoItems;
/* 保存重用的View的集合 */
@property (nonatomic, strong) NSMutableSet *reusableItemViews;
/* 保存当前显示的View的数组 */
@property (nonatomic, strong) NSMutableArray *visibleItemViews;
/* 记录当前的page */
@property (nonatomic, assign) NSUInteger currentPage;
/* 背景View */
@property (nonatomic, strong) UIImageView *backgroundView;
/* pageIndex指示器 */
@property (nonatomic, strong) UILabel *pageLabel;
/* 底部显示文字 */
@property (nonatomic, strong) UIView *textLabelView;
/*  */
@property (nonatomic, assign) BOOL presented;
/*  */
@property (nonatomic, strong) id<UFImageManager> imageManager;

/* 记录目标Index */
@property (nonatomic, assign) NSInteger targetIndex;

@end

@implementation UFPhotoBrowserViewController

// MAKR: - Initializer

+ (instancetype)browserWithPhotoItems:(NSArray<UFPhotoModel *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    UFPhotoBrowserViewController *browser = [[UFPhotoBrowserViewController alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}

- (instancetype)init {
    /* 这里不让外面使用init初始化 */
    NSAssert(NO, @"Use initWithMediaItems: instead.");
    return nil;
}

- (instancetype)initWithPhotoItems:(NSArray<UFPhotoModel *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    self = [super init];
    if (self) {
        /* 设置转场风格 */
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        /* 保存模型 */
        self.photoItems = [NSMutableArray arrayWithArray:photoItems];
        /* 记录当前的Index */
        self.currentPage = selectedIndex;
        
        /* 这里就不要用懒加载了 _visibleItemViews是肯定不能的，另外的可以懒加载 */
        _reusableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
        _imageManager = [[UFSDImageManager alloc] init];
    }
    return self;
}

// MARK: - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // TODO: 如果背景就是黑的，这里可以不用这个背景UIImageView
    /* 设置背景 */
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    /* 设置滚动视图 */
    CGRect rect = self.view.bounds;
    rect.origin.x -= UFPhotoViewPadding;
    rect.size.width += 2 * UFPhotoViewPadding;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    /* 设置PageIndex指示器 */
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kPageIndicatorTopSpacing, self.view.bounds.size.width, kPageIndicatorHeight)];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:16];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self configPageLabelWithPage:_currentPage];
    [self.view addSubview:_pageLabel];
    
    // TODO: 这里需要加入文字的显示
    
    /* 配置滚动视图的 contentSize */
    CGSize contentSize = CGSizeMake(rect.size.width * _photoItems.count, rect.size.height);
    _scrollView.contentSize = contentSize;
    
    /* 添加手势 */
    [self addGestureRecognizer];
    
    /* 根据要显示的初始页设置滚动视图的contentOffset */
    CGPoint contentOffset = CGPointMake(_scrollView.frame.size.width * _currentPage, 0);
    [_scrollView setContentOffset:contentOffset animated:NO];
    if (contentOffset.x == 0) {
        /* 这里应该是为了方便，不用去单独处理在首页的情况 */
        [self scrollViewDidScroll:_scrollView];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
//    if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didSelectItem:atIndex:)]) {
//        [_delegate ks_photoBrowser:self didSelectItem:item atIndex:_currentPage];
//    }
    
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    
    if ([_imageManager imageFromMemoryForURL:item.imageUrl]) {
        /* 一开始显示的UFPhotoView先判断内存里面是否有需要的图片，有则不要缩略图 */
        [self configPhotoView:photoView withItem:item];
    }
    else {
        /* 内存里面没图，先显示缩略图 */
        photoView.imageView.image = item.thumbImage;
        [photoView resizeImageView];
    }
    
    if (item.sourceView == nil) {
        /* 如果没有传入原视图，就用简单显示效果 */
        photoView.alpha = 0;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.view.backgroundColor = [UIColor blackColor];
            self.backgroundView.alpha = 1;
            photoView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            self.presented = YES;
            [self setStatusBarHidden:YES];
        }];
        return;
    }
    
    CGRect endRect = photoView.imageView.frame;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    photoView.imageView.frame = sourceRect;
    
    if (_bounces) {
        /* 弹性动画 */
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            self.backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            self.presented = YES;
            [self setStatusBarHidden:YES];
        }];
    }
    else {
        /* 无弹性动画 */
        CGRect startBounds = CGRectMake(0, 0, sourceRect.size.width, sourceRect.size.height);
        CGRect endBounds = CGRectMake(0, 0, endRect.size.width, endRect.size.height);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startBounds cornerRadius:MAX(item.sourceView.layer.cornerRadius, 0.1)];
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endBounds cornerRadius:0.1];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = endBounds;
        photoView.imageView.layer.mask = maskLayer;
        
        CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskAnimation.duration = kAnimationDuration;
        maskAnimation.fromValue = (__bridge id _Nullable)startPath.CGPath;
        maskAnimation.toValue = (__bridge id _Nullable)endPath.CGPath;
        maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskAnimation forKey:nil];
        maskLayer.path = endPath.CGPath;
        
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            self.backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            self.presented = YES;
            [self setStatusBarHidden:YES];
            photoView.imageView.layer.mask = nil;
        }];
    }
}

// MARK: - Public

- (void)showFromViewController:(UIViewController *)vc {
    [vc presentViewController:self animated:NO completion:nil];
}

- (UIImage *)imageForItem:(UFPhotoModel *)item {
    return [_imageManager imageForURL:item.imageUrl];
}

- (UIImage *)imageAtIndex:(NSUInteger)index {
    UFPhotoModel *item = [_photoItems objectAtIndex:index];
    return [_imageManager imageForURL:item.imageUrl];
}

// MARK: - Setter & Getter

- (void)setStatusBarHidden:(BOOL)hidden {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (hidden) {
        window.windowLevel = UIWindowLevelStatusBar + 1;
    } else {
        window.windowLevel = UIWindowLevelNormal;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// MARK: - Private

/**
 获取指定Index的View
 */
- (UFPhotoView *)photoViewForPage:(NSUInteger)page {
    /* 从显示的View数组里面遍历，通过View的tag判断是否是需要的View */
    for (UFPhotoView *photoView in _visibleItemViews) {
        if (photoView.tag == page) {
            return photoView;
        }
    }
    return nil;
}

/**
 获取重用的View的方法
 */
- (UFPhotoView *)dequeueReusableItemView {
    /* 从集合中取出一个对象，系统会给你它认为你需要的对象 */
    UFPhotoView *photoView = [_reusableItemViews anyObject];
    if (photoView == nil) {
        /* 这里容一下错 */
        photoView = [[UFPhotoView alloc] initWithFrame:_scrollView.bounds imageManager:_imageManager];
    }
    else {
        /* 取出来要用的，所以从重用集合里面移除 */
        [_reusableItemViews removeObject:photoView];
    }
    /* 设置tag,这里还不清楚为何设置为-1 */
    photoView.tag = -1;
    return photoView;
}

/**
 更新可重用的View
 */
- (void)updateReusableItemViews {
    /* 用于记录不显示的View的数组 */
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (UFPhotoView *photoView in _visibleItemViews) {
        /* 遍历并且通过判断frame确定View是否在显示 */
        if (photoView.frame.origin.x + photoView.frame.size.width < _scrollView.contentOffset.x - _scrollView.frame.size.width ||
            photoView.frame.origin.x > _scrollView.contentOffset.x + 2 * _scrollView.frame.size.width) {
            /* 若View不在当前显示，则从父视图移除 */
            [photoView removeFromSuperview];
            /* 这里让View变成初始状态 */
            [self configPhotoView:photoView withItem:nil];
            /* 记录不显示的View */
            [itemsForRemove addObject:photoView];
            /* 把View加入重用集合里面 */
            [_reusableItemViews addObject:photoView];
        }
    }
    /* 从显示的View数组里面移除不显示的View数组 */
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

/**
 配置视图
 */
- (void)configItemViews {
    /* 这里重新设置UFPhotoView的位置 */
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i < 0 || i >= _photoItems.count) {
            continue;
        }
        UFPhotoView *photoView = [self photoViewForPage:i];
        if (photoView == nil) {
            photoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i * _scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = i;
            [_scrollView addSubview:photoView];
            [_visibleItemViews addObject:photoView];
        }
        if (photoView.item == nil && _presented) {
            UFPhotoModel *item = [_photoItems objectAtIndex:i];
            [self configPhotoView:photoView withItem:item];
        }
    }
    
    if (page != _currentPage && _presented && (page >= 0 && page < _photoItems.count)) {
        UFPhotoModel *item = [_photoItems objectAtIndex:page];
        _currentPage = page;
        [self configPageLabelWithPage:_currentPage];

//        if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didSelectItem:atIndex:)]) {
//            [_delegate ks_photoBrowser:self didSelectItem:item atIndex:page];
//        }
    }
}

- (void)p_updateReusableItemViews:(NSInteger)targetIndex{
    /* 记录不显示的View的数组 */
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (UFPhotoView *photoView in _visibleItemViews) {
        /* 遍历并且通过判断tag,tag与index一致 */
        if (photoView.tag != targetIndex && photoView.tag != self.currentPage) {
            /* 若View不在当前显示，则从父视图移除 */
            [photoView removeFromSuperview];
            /* 这里让View变成初始状态 */
            [self configPhotoView:photoView withItem:nil];
            /* 记录不显示的View */
            [itemsForRemove addObject:photoView];
            /* 把View加入重用集合里面 */
            [_reusableItemViews addObject:photoView];
        }
    }
    /* 从显示的View数组里面移除不显示的View数组 */
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

- (void)p_configItemViews:(NSInteger)targetIndex{
//    NSLog(@"start\n%@\n%@",self.visibleItemViews,self.reusableItemViews);
    /* 这里重新设置UFPhotoView的位置 */
    /* 这里的page是为了让label根据移动到中间时切换显示第几张 */
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    
    if (targetIndex < 0 || targetIndex >= _photoItems.count || self.targetIndex == targetIndex) {
        /* 首尾处理 并且在目标View已经配置的情况 */
    }
    else{
        /* 配置目标View */
        UFPhotoView *currentPhotoView = [self photoViewForPage:self.currentPage];
        if (currentPhotoView == nil) {
            currentPhotoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = self.currentPage * _scrollView.bounds.size.width;
            currentPhotoView.frame = rect;
            currentPhotoView.tag = self.currentPage;
            [_scrollView addSubview:currentPhotoView];
            [_visibleItemViews addObject:currentPhotoView];
        }
        if (currentPhotoView.item == nil && _presented) {
            UFPhotoModel *item = [_photoItems objectAtIndex:self.currentPage];
            [self configPhotoView:currentPhotoView withItem:item];
        }
        /* 配置目标View */
        UFPhotoView *photoView = [self photoViewForPage:targetIndex];
        if (photoView == nil) {
            photoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = targetIndex * _scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = targetIndex;
            [_scrollView addSubview:photoView];
            [_visibleItemViews addObject:photoView];
        }
        if (photoView.item == nil && _presented) {
            UFPhotoModel *item = [_photoItems objectAtIndex:targetIndex];
            [self configPhotoView:photoView withItem:item];
        }
        /* 配置完后记录 */
        self.targetIndex = targetIndex;
    }
//    NSLog(@"end\n%@\n%@",self.visibleItemViews,self.reusableItemViews);
    if (page != _currentPage && _presented && (page >= 0 && page < _photoItems.count)) {
        UFPhotoModel *item = [_photoItems objectAtIndex:page];
        _currentPage = page;
        [self configPageLabelWithPage:_currentPage];
        
        //        if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didSelectItem:atIndex:)]) {
        //            [_delegate ks_photoBrowser:self didSelectItem:item atIndex:page];
        //        }
    }
}

/**
 配置UFPhotoView（可以传入item为nil让View回到初始状态）
 */
- (void)configPhotoView:(UFPhotoView *)photoView withItem:(UFPhotoModel *)item{
    // TODO:
    [photoView setItem:item determinate:YES];
}

/**
 设置PageIndex指示器
 */
- (void)configPageLabelWithPage:(NSUInteger)page {
    _pageLabel.text = [NSString stringWithFormat:@"%lu / %lu", page+1, _photoItems.count];
}

- (void)handlePanBegin {
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    /* 开始拖动时取消当前的加载 */
    [photoView cancelCurrentImageLoad];
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
    /* 显示状态栏 */
    [self setStatusBarHidden:NO];
    /* 隐藏加载Layer */
    photoView.progressLayer.hidden = YES;
    /* 拖动是将原UIView设置透明，让用户产生错觉 */
    item.sourceView.alpha = 0;
}

// MARK: - Gesture Recognizer

- (void)addGestureRecognizer {
    /* 双击手势 */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    /* 单击手势 */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    /* 长按手势 */
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    /* 拖动手势 */
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

/**
 单击手势事件
 */
- (void)didSingleTap:(UITapGestureRecognizer *)tap {
    // TODO: 这里要加上判断，当没有对应的文字时就进行Dismiss，有文字时进行显示或隐藏文字
    [self showDismissalAnimation];
}

/**
 双击手势事件
 */
- (void)didDoubleTap:(UITapGestureRecognizer *)tap {
    // TODO: 这里有BUG,双击的时候
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
    if (!item.finished)  {
        /* PhotoView的图片还未加载完时，不响应双击放大 */
        return;
    }
    if (photoView.zoomScale > 1) {
        /* 放大状态时，回到原来的放大比例 */
        [photoView setZoomScale:1 animated:YES];
    }
    else {
        /* 获取点击的点，然后进行放大 */
        CGPoint location = [tap locationInView:self.view];
        CGFloat maxZoomScale = photoView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;
        [photoView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}

/**
 长按手势事件
 */
- (void)didLongPress:(UILongPressGestureRecognizer *)longPress {
    return;
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    UIImage *image = photoView.imageView.image;
    if (!image) {
        return;
    }
//    if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didLongPressItem:atIndex:)]) {
//        [_delegate ks_photoBrowser:self didLongPressItem:_photoItems[_currentPage] atIndex:_currentPage];
//        return;
//    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.sourceView = longPress.view;
        CGPoint point = [longPress locationInView:longPress.view];
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(point.x, point.y, 1, 1);
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

/**
 拖动手势事件
 */
- (void)didPan:(UIPanGestureRecognizer *)pan {
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    if (photoView.zoomScale > 1.1) {
        return;
    }
    [self performScaleWithPan:pan];
}

// MARK: - Animation

- (void)showCancellationAnimation {
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
    item.sourceView.alpha = 1;
    if (!item.finished) {
        photoView.progressLayer.hidden = NO;
    }
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
            // TODO: 这里不知为何，加上就会有显示BUG
//            self.view.backgroundColor = [UIColor blackColor];
//            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self setStatusBarHidden:YES];
            [self configPhotoView:photoView withItem:item];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
//            self.view.backgroundColor = [UIColor blackColor];
//            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self setStatusBarHidden:YES];
            [self configPhotoView:photoView withItem:item];
        }];
    }
}

/**
 动画
 */
- (void)showDismissalAnimation {
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    [photoView cancelCurrentImageLoad];
    [self setStatusBarHidden:NO];
    
    /* 未传入原视图时 */
    if (item.sourceView == nil) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO];
        }];
        return;
    }
    
    /* 有原视图时，换算出frame用来显示动画 */
    photoView.progressLayer.hidden = YES;
    item.sourceView.alpha = 0;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    if (_bounces) {
        /* 弹性动画 */
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO];
        }];
    }
    else {
        /* 不是弹性动画 */
        CGRect startRect = photoView.imageView.frame;
        CGRect endBounds = CGRectMake(0, 0, sourceRect.size.width, sourceRect.size.height);
        CGRect startBounds = CGRectMake(0, 0, startRect.size.width, startRect.size.height);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startBounds cornerRadius:0.1];
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:endBounds cornerRadius:MAX(item.sourceView.layer.cornerRadius, 0.1)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = endBounds;
        photoView.imageView.layer.mask = maskLayer;
        
        CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskAnimation.duration = kAnimationDuration;
        maskAnimation.fromValue = (__bridge id _Nullable)startPath.CGPath;
        maskAnimation.toValue = (__bridge id _Nullable)endPath.CGPath;
        maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayer addAnimation:maskAnimation forKey:nil];
        maskLayer.path = endPath.CGPath;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    for (UFPhotoView *photoView in _visibleItemViews) {
        [photoView cancelCurrentImageLoad];
    }
    UFPhotoModel *item = [_photoItems objectAtIndex:_currentPage];
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            item.sourceView.alpha = 1;
        }];
    } else {
        item.sourceView.alpha = 1;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 拖动手势的一些动画
 */
- (void)performScaleWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    UFPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            /* 记录开始位置 */
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            /* 拖动过程中改变背景透明度，以及PhotoView的平移和缩放 */
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;
            percent = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            /* 平移 */
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
            /* 缩放 */
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            photoView.imageView.transform = CGAffineTransformConcat(translation, scale);
            /* 改变透明度 */
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            /* 这里控制是否消失，或恢复显示 */
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self showDismissalAnimation];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

// MARK: - Animation Delegate

// TODO: 这里好像没用
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"id"] isEqualToString:@"throwAnimation"]) {
        [self dismissAnimated:YES];
    }
}

// MARK: - ScrollView Delegate

// TODO: 这里可以在UIScrollView 滚动的是否就开始判断并配置View
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 这里做判断 */
    CGFloat contentOffsetX = self.currentPage * self.scrollView.bounds.size.width;
    NSInteger offset = scrollView.contentOffset.x >= contentOffsetX ? 1 : -1;
    NSLog(@"方向：%zd %zd",offset,self.currentPage+offset);
    
    [self updateReusableItemViews];
    [self configItemViews];

//    [self p_updateReusableItemViews:self.currentPage+offset];
//    [self p_configItemViews:self.currentPage+offset];
}


@end
