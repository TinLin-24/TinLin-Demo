//
//  CAAnimationViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "CAAnimationViewController.h"

@interface CAAnimationViewController ()

/*  */
@property (nonatomic,strong)UIButton *btn;

@end

@implementation CAAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn];
    
    [self _setupSubViews];
}

///
- (void)_setupSubViews {
    
}

#pragma mark - Layer

- (void)_animationView {
    UIView *animationView = [UIView new];
    animationView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    animationView.center = self.view.center;
    animationView.backgroundColor = [UIColor lightGrayColor];
    animationView.clipsToBounds = YES;
    [self.view addSubview:animationView];

    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
    animationLayer.bounds = CGRectMake(0, 0, 20, 20);
    animationLayer.cornerRadius = 10;
    animationLayer.position = CGPointMake(SCREEN_WIDTH/2, 100);

    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    NSValue *value = [NSValue valueWithCATransform3D:CATransform3DMakeScale(10, 10, 1)];
    transformAnim.toValue = value;
    transformAnim.duration = 2;

    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.toValue = 0;
    alphaAnim.duration = 2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[transformAnim,alphaAnim];
    animGroup.duration = 2;
    animGroup.repeatCount = HUGE;
    [animationLayer addAnimation:animGroup forKey:nil];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer new];
    [replicatorLayer addSublayer:animationLayer];
    replicatorLayer.instanceCount = 3;  //三个复制图层
    replicatorLayer.instanceDelay = 0.3 ; // 复制间隔0.3秒
    [animationView.layer addSublayer:replicatorLayer];
}

#pragma mark - CA动画

-(void)createBtn{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"home_suspension_edit"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(200, 150, 100, 100);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.btn=btn;
    [self start];
}

-(void)start{
    [self.btn.layer addAnimation:[self shakeAnimation] forKey:@"shakeAnimation"];
}

-(void)btnClick:(UIButton*)btn{
    NSLog(@"点击");
    btn.selected=!btn.selected;
    if (btn.selected) {
        [self.btn.layer removeAllAnimations];
    }
    else{
        [self start];
    }
}

/**
 类似弹簧的动画效果
 */
-(CAAnimation *)CASpringAnimation{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    /* mass属性相当于物体的重量,默认100,数值大于0 */
    springAnimation.mass = 10.f;
    /* stiffness属性代表了弹簧的刚度,默认10,数值大于0 */
    springAnimation.stiffness = 50.f;
    /* damping属性代表阻尼系数 */
    springAnimation.damping = 8;
    /* initialVelocity属性代表动画的初始速度 */
    springAnimation.initialVelocity = 20.f;
    /* settlingDuration是动画的预估执行时间 */
    
    springAnimation.fromValue = [NSNumber numberWithFloat: self.btn.frame.origin.y];
    springAnimation.toValue = [NSNumber numberWithFloat: 250.f];
    springAnimation.duration = springAnimation.settlingDuration;

    springAnimation.removedOnCompletion = NO;

    return springAnimation;
}

/**
 
 */
-(CAAnimation *)keyframeAnimation{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 贝塞尔曲线关键帧
    // 设置路径, 绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 200, 200); // 起始点
    CGPathAddCurveToPoint(path, NULL, 100, 300, 300, 500, 200, 600);
    // CGPathAddCurveToPoint(path, NULL, 控制点1.x, 控制点1.y, 控制点2.x, 控制点2.y, 终点.x, 终点.y);
    // 设置path属性
    keyframeAnimation.path = path;
    CGPathRelease(path);
    
    // 设置其他属性
    keyframeAnimation.duration = 4;
    keyframeAnimation.beginTime = CACurrentMediaTime() + 1; // 设置延迟2秒执行, 不设置这个属性, 默认直接执行
    // 3. 添加动画到图层, 会自动执行
    return keyframeAnimation;
}

/**
 组动画
 */
-(CAAnimation *)animationGroup{
    //创建组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    /* beginTime 可以分别设置每个动画的beginTime来控制组动画中每个动画的触发时间，时间不能够超过动画的时间，默认都为0.f */
    
    //缩放动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.5],[NSNumber numberWithFloat:1.0]];
    animation1.beginTime = 0.f;
    
    //按照圆弧移动动画
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(300, 200)];
    [bezierPath addQuadCurveToPoint:CGPointMake(200, 300) controlPoint:CGPointMake(300, 300)];
    [bezierPath addQuadCurveToPoint:CGPointMake(100, 200) controlPoint:CGPointMake(100, 300)];
    [bezierPath addQuadCurveToPoint:CGPointMake(200, 100) controlPoint:CGPointMake(100, 100)];
    [bezierPath addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(300, 100)];
    animation2.path = bezierPath.CGPath;
    animation2.beginTime = 0.f;
    
    //透明度动画
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation3.fromValue = [NSNumber numberWithDouble:0.0];
    animation3.toValue = [NSNumber numberWithDouble:1.0];
    animation3.beginTime = 0.f;
    
    //添加组动画
    animationGroup.animations = @[animation1,animation2,animation3];
    return animationGroup;
}

/**
 心脏缩放动画
 */
-(CAAnimation *)scaleAnimations{
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; //选中的这个keyPath就是缩放
//    scaleAnimation.fromValue = [NSNumber numberWithDouble:0.5]; //一开始时是0.5的大小
//    scaleAnimation.toValue = [NSNumber numberWithDouble:1.5];  //结束时是1.5的大小
//    scaleAnimation.duration = 1; //设置时间
//    scaleAnimation.repeatCount = MAXFLOAT; //重复次数
//    return scaleAnimation;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithDouble:0.5];
    NSValue *value2 = [NSNumber numberWithDouble:1.5];
    NSValue *value3 = [NSNumber numberWithDouble:0.5];
    scaleAnimation.duration = 1.f;
    scaleAnimation.values = @[value1,value2,value3];
    scaleAnimation.repeatCount = MAXFLOAT;
    return scaleAnimation;
}

/**
 旋转效果
 */
-(CAAnimation *)rotationAnimation{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3;
    rotationAnimation.removedOnCompletion=NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    return rotationAnimation;
}

/**
 抖动效果
 */
-(CAAnimation *)shakeAnimation{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*8];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*8];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*8];
    shakeAnimation.values = @[value1,value2,value3];
    shakeAnimation.repeatCount = MAXFLOAT;
    return shakeAnimation;
}

#pragma mark - keyPath 可以设置的值

/*
 CATransform3D{
     //rotation旋转
     transform.rotation.x
     transform.rotation.y
     transform.rotation.z
 
     //scale缩放
     transform.scale.x
     transform.scale.y
     transform.scale.z
 
     //translation平移
     transform.translation.x
     transform.translation.y
     transform.translation.z
 }
 
 CGPoint{
     position
     position.x
     position.y
 }
 
 CGRect{
     bounds
     bounds.size
     bounds.size.width
     bounds.size.height
 
     bounds.origin
     bounds.origin.x
     bounds.origin.y
 }
 
 property{
     opacity
     backgroundColor
     cornerRadius
     borderWidth
     contents
 
     Shadow{
         shadowColor
         shadowOffset
         shadowOpacity
         shadowRadius
     }
 }
 */

@end
