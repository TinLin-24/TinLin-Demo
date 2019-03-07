//
//  LayerViewController.m
//  Demo
//
//  Created by Mac on 2018/12/12.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "LayerViewController.h"
#import "UIBezierPath+GetAllPoints.h"

@interface LayerViewController ()

//
@property (nonatomic, strong)CAEmitterLayer *emitterLayer;

@end

@implementation LayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self _test];
    
    [self _setupSubViews];

    [self _loadView];

    [self _name];

    [self _setZanBtn];

    [self _transformLayer];

    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加遮罩" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
}

- (void)_test {
    // 数学题
    CGFloat x = 0;
    CGFloat y = 64.f;
    CGFloat width = SCREEN_WIDTH/2;
    CGFloat height = SCREEN_HEIGHT - 64.f - 50.f;

//    CGFloat x = 50;
//    CGFloat y = 64.f+50;
//    CGFloat width = 200;
//    CGFloat height = 600;
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat pointX;
    CGFloat pointY;
    
    CGFloat tanf_60 = tanf(60.f/180.f*M_PI);
    CGFloat tanf_70 = tanf(70.f/180.f*M_PI);
    CGFloat tanf_80 = tanf(80.f/180.f*M_PI);

    [path moveToPoint:CGPointMake(x, y+height)];
    [path addLineToPoint:CGPointMake(x+width, y+height)];
    
    pointX = width/2;
    pointY = pointX*tanf_80;
    pointX += x;
    pointY = y+height - pointY;
    [path moveToPoint:CGPointMake(x, y+height)];
    [path addLineToPoint:CGPointMake(pointX, pointY)];
    [path addLineToPoint:CGPointMake(x+width, y+height)];
    
    pointX = width*tanf_60/(tanf_60+tanf_80);
    pointY = pointX*tanf_80;
    pointX += x;
    pointY = y+height - pointY;
    CGPoint pointF = CGPointMake(pointX, pointY);
    
    pointX = width*tanf_80/(tanf_70+tanf_80);
    pointY = pointX*tanf_70;
    pointX += x;
    pointY = y+height - pointY;
    CGPoint pointS = CGPointMake(pointX, pointY);

    [path moveToPoint:CGPointMake(x, y+height)];
    [path addLineToPoint:pointS];
    
    [path moveToPoint:CGPointMake(x+width, y+height)];
    [path addLineToPoint:pointF];
    
    [path moveToPoint:pointF];
    [path addLineToPoint:pointS];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}

#pragma mark - Action

- (void)rightBarButtonItemClick:(UIBarButtonItem *)item {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:.3].CGColor;
    layer.fillRule = kCAFillRuleEvenOdd;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path appendPath:path2];
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
}

#pragma mark - 圣诞树

- (void)_setupSDS {
    CALayer *layer = [CALayer layer];
}

#pragma mark - 扩散

///
- (void)_setupSubViews {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, TLTopMargin(64.f), 100, 100)];
    [self.view addSubview:bgView];
    
    bgView.layer.backgroundColor = [UIColor clearColor].CGColor;

    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = bgView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:bgView.bounds].CGPath;
    pulseLayer.fillColor = [UIColor redColor].CGColor;
    pulseLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = bgView.bounds;
    replicatorLayer.instanceCount = 6;
    replicatorLayer.instanceDelay = 1;
    [replicatorLayer addSublayer:pulseLayer];
    [bgView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.f, 0.f, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnima"];
}

#pragma mark - Name

- (void)_name {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, TLTopMargin(164.f), SCREEN_WIDTH, 100)];
    [self.view addSubview:bgView];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = bgView.bounds;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor= [UIColor colorWithHexString:@"#1296db"].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = 3.f;
    layer.strokeStart = 0.f;

    UIBezierPath *path = [UIBezierPath bezierPathWithText:@"Hello World!" font:[UIFont boldSystemFontOfSize:50.f]];
    layer.path = path.CGPath;
    [bgView.layer addSublayer:layer];
    
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (__bridge id)(TLImageNamed(@"pen").CGImage);
    // 锚点
    penLayer.anchorPoint = CGPointMake(0, 1);
    penLayer.frame = CGRectMake(0, 0, 50, 50);
    [bgView.layer addSublayer:penLayer];
    
    CGFloat duration = 10.f;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animation forKey:@"animation"];
    
    // 画笔动画
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = duration;
    penAnimation.path = path.CGPath;
    penAnimation.calculationMode = kCAAnimationPaced;
    //动画结束后保持动画最后的状态，两个属性需配合使用
    penAnimation.fillMode = kCAFillModeForwards;
    penAnimation.removedOnCompletion = NO;
    [penLayer addAnimation:penAnimation forKey:@"position"];
}

#pragma mark - 加载中

- (void)_loadView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(100, TLTopMargin(64.f), 100, 100)];
    [self.view addSubview:bgView];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:50 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES].CGPath;
//    layer.path = [UIBezierPath bezierPathWithOvalInRect:bgView.frame].CGPath;
    layer.frame = bgView.bounds;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 5.f;
    layer.lineCap = kCALineCapRound;
    [bgView.layer addSublayer:layer];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.removedOnCompletion=NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self _loadSuccess:layer];
}

- (void)_loadSuccess:(CAShapeLayer *)layer {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:50 startAngle:-M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
    [path moveToPoint:CGPointMake(20.f, 55.f)];
    [path addLineToPoint:CGPointMake(45.f, 75.f)];
    [path addLineToPoint:CGPointMake(80.f, 25.f)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeAnimationForKey:@"rotationAnimation"];
        layer.path = path.CGPath;
        layer.strokeStart = 0.f;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = 2.f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [layer addAnimation:animation forKey:@"success"];
    });
}

#pragma mark - 粒子

- (void)_setZanBtn {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, TLTopMargin(200.f+64.f), 100, 100)];
    [self.view addSubview:bgView];
    bgView.layer.borderColor = [UIColor redColor].CGColor;
    bgView.layer.borderWidth = 1.f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 24);
    btn.center = bgView.center;
    [btn setImage:TLImageNamed(@"dianzan") forState:UIControlStateNormal];
    [btn setImage:TLImageNamed(@"dianzan_s") forState:UIControlStateSelected];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    // 发射点的位置
    self.emitterLayer.position = CGPointMake(50, 50);
    [bgView.layer addSublayer:self.emitterLayer];
}

- (void)zanBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .5f;
        scaleAnimation.values = @[@1.5,@2.0,@0.8,@1.0];
        scaleAnimation.calculationMode = kCAAnimationCubic;
        [sender.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _showEmitterLayer];
        });
    }
}

- (void)_showEmitterLayer{
    // 用KVC设置颗粒个数
    [self.emitterLayer setValue:@1000 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    // 开始动画
    self.emitterLayer.beginTime = CACurrentMediaTime();
    // 延迟停止动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAnimation];
    });
}

- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    [self.emitterLayer removeAllAnimations];
}

- (CAEmitterLayer *)emitterLayer {
    if (!_emitterLayer) {
        // 1. 粒子
        CAEmitterCell * explosionCell = [CAEmitterCell emitterCell];
        explosionCell.name = @"explosionCell";
        explosionCell.alphaSpeed = -1.f;
        explosionCell.alphaRange = 0.10;
        explosionCell.lifetime = 1;
        explosionCell.lifetimeRange = 0.1;
        explosionCell.velocity = 40.f;
        explosionCell.velocityRange = 10.f;
        explosionCell.scale = 0.08;
        explosionCell.scaleRange = 0.02;
        explosionCell.contents = (id)[[UIImage imageNamed:@"spark_red"] CGImage];
        // 2.发射源
        CAEmitterLayer * explosionLayer = [CAEmitterLayer layer];

        // 发射源的大小,这个emitterSize结合position构建了发射源的位置及大小的矩形区域rect
        explosionLayer.emitterSize = CGSizeMake(64.f, 64.f);
        explosionLayer.emitterShape = kCAEmitterLayerCircle;
        // 发射模式
        explosionLayer.emitterMode = kCAEmitterLayerOutline;
        explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
        explosionLayer.emitterCells = @[explosionCell];
        
        _emitterLayer = explosionLayer;
    }
    return _emitterLayer;
}

/**
 renderMode:渲染模式,控制着在视觉上粒子图片是如何混合的。
 NSString * const kCAEmitterLayerUnordered;
 NSString * const kCAEmitterLayerOldestFirst;
 NSString * const kCAEmitterLayerOldestLast;
 NSString * const kCAEmitterLayerBackToFront;
 NSString * const kCAEmitterLayerAdditive;
 
 emitterMode: 发射模式,这个字段规定了在特定形状上发射的具体形式是什么
 kCAEmitterLayerPoints: 点模式,发射器是以点的形势发射粒子。
 kCAEmitterLayerOutline:这个模式下整个边框都是发射点,即边框进行发射
 kCAEmitterLayerSurface:这个模式下是我们边框包含下的区域进行抛洒
 kCAEmitterLayerVolume: 同上
 
 emitterShape:规定了发射源的形状。
 kCAEmitterLayerPoint:点形状,发射源的形状就是一个点,位置在上面position设置的位置
 kCAEmitterLayerLine:线形状,发射源的形状是一条线,位置在rect的横向的位于垂直方向中间那条
 kCAEmitterLayerRectangle:矩形状,发射源是一个矩形,就是上面生成的那个矩形rect
 kCAEmitterLayerCuboid:立体矩形形状,发射源是一个立体矩形,这里要生效的话需要设置z方向的数据,如果不设置就同矩形状
 kCAEmitterLayerCircle:圆形形状,发射源是一个圆形,形状为矩形包裹的那个圆,二维的
 kCAEmitterLayerSphere:立体圆形,三维的圆形,同样需要设置z方向数据,不设置则通二维一样
 
 emitterSize:发射源的大小,这个emitterSize结合position构建了发射源的位置及大小的矩形区域rect
 emitterPosition:发射点的位置。
 lifetime:粒子的生命周期。
 velocity:粒子速度。
 scale:粒子缩放比例。
 spin:自旋转速度。
 seed:用于初始化产生的随机数产生的种子。
 emitterCells:CAEmitterCell对象的数组,被用于把粒子投放到layer上
 
 CAEmitterCell:
 粒子在X.Y.Z三个方向上的加速度。
 @property CGFloat xAcceleration;
 @property CGFloat yAcceleration;
 @property CGFloat zAcceleration;
 粒子缩放比例、缩放范围及缩放速度。(0.0`1.0)
 @property CGFloat scale;
 @property CGFloat scaleRange;
 @property CGFloat scaleSpeed;
 粒子自旋转速度及范围:
 @property CGFloat spin;
 @property CGFloat spinRange;
 粒子RGB及alpha变化范围、速度。
 //范围:
 @property float redRange;
 @property float greenRange;
 @property float blueRange;
 @property float alphaRange;
 //速度:
 @property float redSpeed;
 @property float greenSpeed;
 @property float blueSpeed;
 @property float alphaSpeed;
 
 emitterCells:子粒子。
 color:指定了一个可以混合图片内容颜色的混合色。
 birthRate:粒子产生系数,默认1.0.
 contents:是个CGImageRef的对象,既粒子要展现的图片;
 emissionRange:值是2π,这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值,就可以创造出一个圆锥形。
 指定值在时间线上的变化,例如: alphaSpeed = 0.4,说明粒子每过一秒减小0.4。
 */

- (void)_transformLayer {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    bgView.left = 100.f;
    bgView.top = TLTopMargin(64.f+200.f);
    bgView.layer.borderColor = [UIColor redColor].CGColor;
    bgView.layer.borderWidth = 1.f;
    [self.view addSubview:bgView];
    
    // 普通的一个layer
    CALayer *plane1 = [CALayer layer];
    plane1.anchorPoint = CGPointMake(0.5, 0.5);                 // 锚点
    plane1.frame = (CGRect){CGPointZero, CGSizeMake(75, 75)};   // 尺寸
    plane1.position = CGPointMake(50, 50);                      // 位置
    plane1.opacity = 0.6;                                       // 背景透明度
    plane1.backgroundColor = [UIColor redColor].CGColor;        // 背景色
    plane1.borderWidth = 3;                                     // 边框宽度
    plane1.borderColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor; // 边框颜色(设置了透明度)
    plane1.cornerRadius = 10;                                   // 圆角值
    
    // Z轴平移
    CATransform3D plane1_3D = CATransform3DIdentity;
    plane1_3D = CATransform3DTranslate(plane1_3D, 0, 0, -10);
    plane1.transform = plane1_3D;
    
    // 普通的一个layer
    CALayer *plane2 = [CALayer layer];
    plane2.anchorPoint = CGPointMake(0.5, 0.5);                 // 锚点
    plane2.frame = (CGRect){CGPointZero, CGSizeMake(75, 75)};   // 尺寸
    plane2.position = CGPointMake(50, 50);                      // 位置
    plane2.opacity = 0.6;                                       // 背景透明度
    plane2.backgroundColor = [UIColor greenColor].CGColor;      // 背景色
    plane2.borderWidth = 3;                                     // 边框宽度
    plane2.borderColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor; // 边框颜色(设置了透明度)
    plane2.cornerRadius = 10;                                   // 圆角值
    
    // Z轴平移
    CATransform3D plane2_3D = CATransform3DIdentity;
    plane2_3D = CATransform3DTranslate(plane2_3D, 0, 0, 10);
    plane2.transform = plane2_3D;
    
    // 创建容器layer
    CATransformLayer *container = [CATransformLayer layer];
    container.frame = bgView.bounds;
    [bgView.layer addSublayer:container];
    [container addSublayer:plane1];
    [container addSublayer:plane2];
 
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3;
    rotationAnimation.removedOnCompletion=NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [container addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
