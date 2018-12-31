//
//  UFPhotoView.m
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "UFPhotoView.h"
#import "UFPhotoModel.h"
#import "UFProgressLayer.h"
#import "UFImageManagerProtocol.h"

const CGFloat UFPhotoViewPadding = 10;
const CGFloat UFPhotoViewMaxScale = 3;

@interface UFPhotoView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UFProgressLayer *progressLayer;
@property (nonatomic, strong, readwrite) UFPhotoModel *item;
@property (nonatomic, strong) id<UFImageManager> imageManager;

@end

@implementation UFPhotoView

- (instancetype)initWithFrame:(CGRect)frame imageManager:(id<UFImageManager>)imageManager {
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = UFPhotoViewMaxScale;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.delegate = self;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor darkGrayColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        [self resizeImageView];
        
        self.progressLayer = [[UFProgressLayer alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.progressLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.progressLayer.hidden = YES;
        [self.layer addSublayer:self.progressLayer];
        
        self.imageManager = imageManager;
    }
    return self;
}

- (void)setItem:(UFPhotoModel *)item determinate:(BOOL)determinate {
    _item = item;
    [self.imageManager cancelImageRequestForImageView:self.imageView];
    if (item) {
        if (item.image) {
            self.imageView.image = item.image;
            self.item.finished = YES;
            [self.progressLayer stopSpin];
            self.progressLayer.hidden = YES;
            [self resizeImageView];
            return;
        }
        
        @weakify(self);
        UFImageManagerProgressBlock progressBlock = nil;
        if (determinate) {
            progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize) {
                @strongify(self);
                double progress = (double)receivedSize / expectedSize;
                self.progressLayer.hidden = NO;
                self.progressLayer.strokeEnd = MAX(progress, 0.01);
            };
        } else {
            [self.progressLayer startSpin];
        }
        self.progressLayer.hidden = NO;
        
        self.imageView.image = item.thumbImage;
        [self.imageManager setImageForImageView:self.imageView withURL:item.imageUrl placeholder:item.thumbImage progress:progressBlock completion:^(UIImage *image, NSURL *url, BOOL finished, NSError *error) {
            @strongify(self);
            if (finished) {
                [self resizeImageView];
            }
            [self.progressLayer stopSpin];
            self.progressLayer.hidden = YES;
            self.item.finished = YES;
        }];
    } else {
        [self.progressLayer stopSpin];
        self.progressLayer.hidden = YES;
        self.imageView.image = nil;
    }
    [self resizeImageView];
}

/**
 重新设置ImageView的大小
 */
- (void)resizeImageView {
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGFloat width = self.frame.size.width - 2 * UFPhotoViewPadding;
        CGFloat height = width * (imageSize.height / imageSize.width);
        CGRect rect = CGRectMake(0, 0, width, height);
        
        [UIView animateWithDuration:0.33 animations:^{
            self.imageView.frame = rect;
            
            // If image is very high, show top content.
            if (height <= self.bounds.size.height) {
                self.imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            } else {
                self.imageView.center = CGPointMake(self.bounds.size.width/2, height/2);
            }
        }];
        
        // If image is very wide, make sure user can zoom to fullscreen.
        if (width / height > 2) {
            self.maximumZoomScale = self.bounds.size.height / height;
        }
    } else {
        CGFloat width = (self.frame.size.width - 2 * UFPhotoViewPadding) / 2;
        self.imageView.frame = CGRectMake(0, 0, width, width * 2.0 / 3);
        self.imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    self.contentSize = self.imageView.frame.size;
    self.zoomScale = 1.f;
}

/**
 取消当前在加载的image
 */
- (void)cancelCurrentImageLoad {
    [self.imageManager cancelImageRequestForImageView:self.imageView];
    [self.progressLayer stopSpin];
}

/**
 
 */
- (BOOL)isScrollViewOnTopOrBottom {
    CGPoint translation = [self.panGestureRecognizer translationInView:self];
    if (translation.y > 0 && self.contentOffset.y <= 0) {
        return YES;
    }
    CGFloat maxOffsetY = floor(self.contentSize.height - self.bounds.size.height);
    if (translation.y < 0 && self.contentOffset.y >= maxOffsetY) {
        return YES;
    }
    return NO;
}

#pragma mark - ScrollViewDelegate

/* 返回将要缩放的UIView对象。要执行多次  */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

/* 当scrollView缩放时，调用该方法。在缩放过程中，回多次调用 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    /*  */
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;

    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;

    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            if ([self isScrollViewOnTopOrBottom]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
