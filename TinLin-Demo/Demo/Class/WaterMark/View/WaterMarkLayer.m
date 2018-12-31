//
//  WaterMarkLayer.m
//  Demo
//
//  Created by TinLin on 2018/7/17.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterMarkLayer.h"

@interface WaterMarkLayer()

/*  */
@property (nonatomic ,strong)CALayer *logoLayer;
/*  */
@property (nonatomic ,strong)CALayer *qrCodeLayer;
/*  */
@property (nonatomic ,strong)CATextLayer *waterMarkStrLayer;

@end

@implementation WaterMarkLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_setupSubViews];
    }
    return self;
}

#pragma mark - 添加子layer

- (void)p_setupSubViews{
    [self addSublayer:self.logoLayer];
    [self addSublayer:self.qrCodeLayer];
    [self addSublayer:self.waterMarkStrLayer];
}

#pragma mark -

- (void)setFrameSize:(CGSize)size{
    [super setFrameSize:size];
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    PositionType logoPosition = 2;
    PositionType qrcodePosition = 3;
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImage *qrImage = [UIImage imageNamed:@"qrcode"];
    
    CGFloat proportion = width / [UIScreen mainScreen].bounds.size.width;
    
    CGRect logoLayerRect = [self _getPositionRect:logoPosition andViewSize:self.frame.size andImageSize:logoImage.size andProportion:proportion];
    [self.logoLayer setFrame:logoLayerRect];
    
    CGRect qrCodeLayerRect = [self _getPositionRect:qrcodePosition andViewSize:self.frame.size andImageSize:qrImage.size andProportion:proportion];
    [self.qrCodeLayer setFrame:qrCodeLayerRect];
    
    CGSize theSize;
    CGSize limitSize =CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:WatermarkFontSize * proportion] forKey:NSFontAttributeName];
    CGRect rect = [self.waterMarkStrLayer.string boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    
    CGFloat X = 0;
    if (theSize.width > width) {
        X = -(theSize.width - width)/2;
    }
    CGRect waterMarkStrLayerRect = CGRectMake(0, 0, theSize.width, theSize.height);
    [self.waterMarkStrLayer setBounds:waterMarkStrLayerRect];
    [self.waterMarkStrLayer setPosition:CGPointMake(width/2, height/2)];
    
    self.waterMarkStrLayer.fontSize = WatermarkFontSize * proportion;
}

-(CGRect)_getPositionRect:(PositionType)positionType andViewSize:(CGSize)viewSize andImageSize:(CGSize)imageSize andProportion:(CGFloat)proportion{
    
    /* 默认边距 按比例计算 */
    CGFloat margin= WatermarkImageMargin * proportion ;
    
    /* 按比例计算宽高 */
    CGFloat width = imageSize.width * proportion;
    CGFloat height = imageSize.height * proportion;
    
    /* 高度或者宽度超过设置的最大的宽度，重新计算宽高 */
    /* 在计算中必须乘以proportion ，适应图片分辨率问题 */
    if (imageSize.width > WatermarkImageMaxWidth || imageSize.height > WatermarkImageMaxWidth ) {
        width = WatermarkImageMaxWidth * proportion;
        height = WatermarkImageMaxWidth * imageSize.height / imageSize.width * proportion ;
    }
    
    switch (positionType) {
        case UpperLeftCorner:
            return CGRectMake(margin, margin, width, height);
            break;
        case UpperRightCorner:
            return CGRectMake(viewSize.width-margin-width, margin ,width, height);
            break;
        case LowerLeftCorner:
            return CGRectMake(margin, viewSize.height-margin-height ,width, height);
            break;
        case BottomRightCorner:
            return CGRectMake(viewSize.width-margin-width, viewSize.height-margin-height ,width, height);
            break;
        case CenterPosition:{
            CGFloat X = (viewSize.width -width)/2;
            CGFloat Y = (viewSize.height -height)/2;
            return CGRectMake(X ,Y ,width, height);
        }
            break;
        default:
            return CGRectZero;
            break;
    }
}

#pragma mark - 懒加载

-(CALayer *)logoLayer{
    if (!_logoLayer) {
        _logoLayer = [CALayer layer];
        UIImage *logoImage = [UIImage imageNamed:@"logo"];
        [_logoLayer setContents:(id)logoImage.CGImage];
    }
    return _logoLayer;
}

-(CALayer *)qrCodeLayer{
    if (!_qrCodeLayer) {
        _qrCodeLayer = [CALayer layer];
        UIImage *qrImage = [UIImage imageNamed:@"qrcode"];
        [_qrCodeLayer setContents:(id)qrImage.CGImage];
    }
    return _qrCodeLayer;
}

-(CATextLayer *)waterMarkStrLayer{
    if (!_waterMarkStrLayer) {
        _waterMarkStrLayer = [CATextLayer layer];
        _waterMarkStrLayer.fontSize = WatermarkFontSize;
        _waterMarkStrLayer.foregroundColor = WatermarkFontColor_GPUImage.CGColor;
        _waterMarkStrLayer.string = @"GPUImage加水印   GPUImage加水印   GPUImage加水印   GPUImage加水印   GPUImage加水印   GPUImage加水印";
        _waterMarkStrLayer.affineTransform = CGAffineTransformMakeRotation(TRANSFORM_ROTATION);
        _waterMarkStrLayer.alignmentMode = kCAAlignmentJustified;
    }
    return _waterMarkStrLayer;
}

@end
