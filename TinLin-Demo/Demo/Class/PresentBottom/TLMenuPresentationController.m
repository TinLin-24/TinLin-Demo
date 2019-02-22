//
//  TLMenuPresentationController.m
//  Demo
//
//  Created by Mac on 2019/1/18.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLMenuPresentationController.h"

#define CORNER_RADIUS 8.f

@interface TLMenuPresentationController () <UIViewControllerAnimatedTransitioning>

@property(nonatomic, strong) UIView *maskView;

@property(nonatomic, strong) UIView *presentationWrappingView;

@end

@implementation TLMenuPresentationController

#pragma mark - Override

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        self.anchorPoint = CGPointMake(.9f, 0);
    }
    return self;
}

- (UIView *)presentedView {
    //这里返回自己的用来包装的View 在presentationTransitionWillBegin创建
    return self.presentationWrappingView;
}

- (void)presentationTransitionWillBegin {
    
    //取得原来的presentedView，
    UIView *presentedViewControllerView = [super presentedView];
    
    {
        //创建用来包裹的View
        UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
//        presentationWrapperView.layer.cornerRadius = CORNER_RADIUS;
//        presentationWrapperView.layer.masksToBounds = YES;
        self.presentationWrappingView = presentationWrapperView;
        
        // To undo the extra height added to presentationRoundedCornerView,
        // presentedViewControllerWrapperView is inset by CORNER_RADIUS points.
        // This also matches the size of presentedViewControllerWrapperView's
        // bounds to the size of -frameOfPresentedViewInContainerView.
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:presentationWrapperView.bounds];
        presentedViewControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Add presentedViewControllerView -> presentedViewControllerWrapperView.
        presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds;
        [presentedViewControllerWrapperView addSubview:presentedViewControllerView];
        
        // Add presentedViewControllerWrapperView -> presentationWrapperView.
        [presentationWrapperView addSubview:presentedViewControllerWrapperView];
    }
    
    !self.containerView ? : [self.containerView addSubview:self.maskView];
    
    // Get the transition coordinator for the presentation so we can
    // fade in the dimmingView alongside the presentation animation.
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.maskView.alpha = 0.f;
    self.presentationWrappingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 0.5f;
        self.presentationWrappingView.alpha = 1.f;
    } completion:NULL];
}

- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 0.f;
        self.presentationWrappingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (self.maskView.superview && completed) {
        [self.maskView removeFromSuperview];
    }
    if (completed == NO) {
        self.maskView = nil;
        self.presentationWrappingView = nil;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? 0.25 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    // This will be the current frame of fromViewController.view.
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    // For a presentation which removes the presenter's view, this will be
    // CGRectZero.  Otherwise, the current frame of fromViewController.view.
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    // This will be CGRectZero.
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    // For a presentation, this will be the value returned from the
    // presentation controller's -frameOfPresentedViewInContainerView method.
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation (will have no effect on dismissal because the
    // presenting view controller's view was not removed).
    [containerView addSubview:toView];
    
    /*
    CGSize size = CGSizeMake(self.frameOfPresentedViewInContainerView.size.width/3, self.frameOfPresentedViewInContainerView.size.height/3);
    
    CGFloat originX = CGRectGetMaxX(self.frameOfPresentedViewInContainerView) - size.width;
    CGFloat originY = self.frameOfPresentedViewInContainerView.origin.y;
    CGPoint origin = CGPointMake(originX, originY);

    if (isPresenting) {
        toViewInitialFrame.origin = origin;
        toViewInitialFrame.size = size;
        toView.frame = toViewInitialFrame;
    } else {
        fromViewFinalFrame.origin = origin;
        fromViewFinalFrame.size = size;
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toViewFinalFrame;
        } else {
            fromView.frame = fromViewFinalFrame;
        }
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    */
    
    
    CGAffineTransform transform = CGAffineTransformMakeScale(.5f, .5f);;

    if (isPresenting) {
        toView.frame = toViewFinalFrame;
        toView.transform = transform;
        toView.layer.anchorPoint = self.anchorPoint;//CGPointMake(.9f, 0);
    } else {
        
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.transform = CGAffineTransformIdentity;
        } else {
            fromView.transform = transform;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

#pragma mark - Layout

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size = presentedViewContentSize;
//    presentedViewControllerFrame.origin.x = containerViewBounds.size.width - 20.f - presentedViewContentSize.width;
//    presentedViewControllerFrame.origin.y = TLTopMargin(24.f);
    CGFloat originX = self.arrowPoint.x - presentedViewContentSize.width*self.anchorPoint.x;
    CGFloat originY = self.arrowPoint.y - presentedViewContentSize.height*self.anchorPoint.y;
    CGPoint origin = CGPointMake(originX, originY);
    presentedViewControllerFrame.origin = origin;
    return presentedViewControllerFrame;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    
    self.maskView.frame = self.containerView.bounds;
    self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView;
}

#pragma mark - Tap Gesture Recognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

#pragma mark - Getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.opaque = NO;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
