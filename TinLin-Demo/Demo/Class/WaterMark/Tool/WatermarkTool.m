//
//  WatermarkTool.m
//
//
//  Created by TinLin on 2018/7/9.
//

#import "WatermarkTool.h"

#import "TZAssetModel.h"

#import "TZImageManager.h"

#import "WaterMarkLayer.h"

@interface WatermarkTool ()

/* logo图片地址 */
@property (nonatomic ,strong)NSString *logoUrl;
/* 二维码图片地址 */
@property (nonatomic ,strong)NSString *qrCodeUrl;
/* logo的位置 */
@property (nonatomic ,assign)NSInteger logoPosition;
/* 二维码的位置 */
@property (nonatomic ,assign)NSInteger qrcodePosition;
/* 是否加上水印图片 */
@property (nonatomic ,assign)BOOL isOpen;

/* logo图片 */
@property (nonatomic ,strong)UIImage *logoImage;
/* 二维码图片 */
@property (nonatomic ,strong)UIImage *qrCodeImage;

/* *************************************************** */

/* 水印文字 */
@property (nonatomic ,strong)NSString *watermarkStr;
/* 是否加上水印文字 */
@property (nonatomic ,assign)BOOL isOpenWatermark;

/* *************************************************** */

/* 用来判断是否要加水印 */
@property (nonatomic ,assign)BOOL isNeed;

/* *************************************************** */
/// GPUImage

/*  */
@property (nonatomic ,strong)WaterMarkLayer *layer;

/*  */
@property (nonatomic ,assign)CGSize lastSize;

/*  */
@property (nonatomic ,strong)GPUImageAlphaBlendFilter *filter;

/*  */
@property (nonatomic ,strong)GPUImageFilter *disFilter;

@end

static WatermarkTool *_watermark = nil;

@implementation WatermarkTool
{
    /// 串行压缩视频的队列
    dispatch_queue_t _watermarkQueue;
}

+(instancetype)watermarkInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _watermark = [[WatermarkTool alloc] init];
    });
    
    return _watermark;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 创建串行队列
        _watermarkQueue = dispatch_queue_create("ios.watermark.queue", NULL);
        _watermarkStr = @"绘制加水印";
        _logoImage = [UIImage imageNamed:@"logo"];
        _qrCodeImage = [UIImage imageNamed:@"qrcode"];
        _logoPosition = 2;
        _qrcodePosition = 3;
        _isOpen = YES;
        _isOpenWatermark = YES;
    }
    return self;
}

#pragma mark - GPUImage加水印

/**
 单个图片添加水印 - GPUImage
 */
-(void)getWaterMarkImage: (UIImage *)originalImage Complete:(void(^)(UIImage *resultImage))complete{
    dispatch_async(_watermarkQueue, ^{
        [self _purgeAllUnassignedFramebuffers];
        [self _adjunctionWatermark:originalImage Complete:complete];
    });
}

/**
 单个图片添加水印 - GPUImage
 */
-(void)_adjunctionWatermark:(UIImage *)originalImage Complete:(void(^)(UIImage *resultImage))complete{
    
    /* 优化，对于同样大小的图片，没必要重新设置size，耗性能 */
    CGSize size = CGSizeMake(originalImage.size.width, originalImage.size.height);
    if (size.width != self.lastSize.width || size.height != self.lastSize.height) {
        [self.layer setFrameSize:size];
        [self.layer setNeedsDisplay];
        self.lastSize = size;
    }
    
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithLayer:self.layer];
    
    /* 设置要渲染的区域 */
    [self.disFilter forceProcessingAtSize:originalImage.size];
    /* 持续图片呈现(必须要加这句不然会生成nil)  滤镜收到原图产生的一个frame，并将它作为自己的当前图像缓存 */
    [self.disFilter useNextFrameForImageCapture];
    /* 获取数据源 */
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:originalImage];
    /* 将输入源和滤镜绑定 */
    [sourcePicture addTarget:self.disFilter];
    /* 添加上滤镜 */
    [self.disFilter addTarget:self.filter];
    /* 添加上滤镜 */
    [uiElement addTarget:self.filter];
    
    [uiElement update];
    
    /* 开始渲染 为原图附上滤镜效果 */
    [sourcePicture processImageUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !complete ? : complete(processedImage);
        });
    }];
}

#pragma mark - 绘制加水印

/**
 单个图片添加水印 - 绘制
 */
-(UIImage *)getWaterMarkImage: (UIImage *)originalImage{
    UIImage *image = [self _getWaterMarkImage:originalImage
                              andWatermarkStr:self.watermarkStr
                                 andLogoImage:self.logoImage
                         andLogoImagePosition:self.logoPosition
                                   andQRImage:self.qrCodeImage
                           andQRImagePosition:self.qrcodePosition];
    return image;
}

/**
 添加水印方法
 @originalImage 需要加水印的原图
 @watermarkStr 水印文字
 @logoImage 企业logo图片
 @logoImagePositionType logo位置
 @qrImage 二维码图片
 @qrImagePositionType 二维码位置
 */
-(UIImage *)_getWaterMarkImage: (UIImage *)originalImage andWatermarkStr: (NSString *)watermarkStr
                  andLogoImage: (UIImage *)logoImage andLogoImagePosition: (PositionType)logoImagePositionType
                    andQRImage: (UIImage *)qrImage andQRImagePosition: (PositionType)qrImagePositionType{
    
    //原始image的宽高
    CGFloat viewWidth = originalImage.size.width;
    CGFloat viewHeight = originalImage.size.height;
    //绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
    
    //先将原始image绘制上
    [originalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    /* 计算比例 按屏幕的宽度与原图片的宽度比 图片可能是高清的 */
    CGFloat proportion = viewWidth / SCREEN_WIDTH;
    
    if (self.isOpen) {
        /* 单独添加水印图片 */
        [self _adjunctionLogoImage:logoImage
              andLogoImagePosition:logoImagePositionType
                        andQRImage:qrImage
                andQRImagePosition:qrImagePositionType
                     andProportion:proportion
                       andViewSize:originalImage.size];
    }
    
    if (self.isOpenWatermark && watermarkStr) {
        /* 单独添加水印文字 */
        [self _adjunctionWatermarkStr:watermarkStr
                        andProportion:proportion
                          andViewSize:originalImage.size];
    }
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImg;
}

/**
 单独添加 企业logo图片和二维码图片
 @logoImage 企业logo图片
 @logoImagePositionType logo位置
 @qrImage 二维码图片
 @qrImagePositionType 二维码位置
 @viewSize 水印图片的size
 @proportion 比例系数
 */
-(void)_adjunctionLogoImage: (UIImage *)logoImage andLogoImagePosition: (PositionType)logoImagePositionType
                 andQRImage: (UIImage *)qrImage andQRImagePosition: (PositionType)qrImagePositionType
              andProportion:(CGFloat)proportion andViewSize:(CGSize)viewSize{
    
    /******* 绘制logo *******/
    
    CGRect logoImageRect=[self _getPositionRect:logoImagePositionType
                                    andViewSize:viewSize
                                   andImageSize:logoImage.size
                                  andProportion:proportion];
    [logoImage drawInRect:logoImageRect];
    
    /******* 绘制二维码 *******/
    
    CGRect qrImageRect=[self _getPositionRect:qrImagePositionType
                                  andViewSize:viewSize
                                 andImageSize:qrImage.size
                                andProportion:proportion];
    [qrImage drawInRect:qrImageRect];
    
}

/**
 单独添加水印文字
 @watermarkStr 水印文字
 @proportion 比例系数
 @viewSize 水印图片的size
 @sqrtLength 水印图片的对角线长度
 */
-(void)_adjunctionWatermarkStr:(NSString *)watermarkStr andProportion:(CGFloat)proportion andViewSize:(CGSize)viewSize{
    
    //原始image的宽高
    CGFloat viewWidth = viewSize.width;
    CGFloat viewHeight = viewSize.height;
    
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt( viewWidth * viewWidth + viewHeight * viewHeight);
    
    /******* 绘制水印文字 *******/
    
    //计算适合的字体大小
    CGFloat fontSize = WatermarkFontSize * proportion ;
    
    //设置文字大小颜色
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    UIColor *color = WatermarkFontColor;
    
    //文字的属性
    NSDictionary *attr = @{
                           //设置字体大小
                           NSFontAttributeName: font,
                           //设置文字颜色
                           NSForegroundColorAttributeName :color,
                           };
    
    //添加水印文本之间的空隙
    watermarkStr = [watermarkStr stringByAppendingString:@"      "];
    NSString *mark = watermarkStr;
    
    //转换为富文本字符串
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    
    //加长文字 通过对角线的长度判断
    for (int i=0; i<20; i++) {
        [attrStr appendAttributedString:attrStr];
        strWidth = attrStr.size.width;
        strHeight = attrStr.size.height;
        if (strWidth > sqrtLength) {
            break;
        }
    }
    //取得最后需要绘制的字符串
    mark=attrStr.string;
    
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(TRANSFORM_ROTATION));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    
    //绘制文本 这个CGRect要根据旋转的角度和绘制原点计算
    [mark drawInRect:CGRectMake(-viewWidth/2, viewHeight/2, strWidth, strHeight) withAttributes:attr];
    
}

/**
 计算水印图片绘制的Rect
 @positionType 水印图片的位置
 @viewSize 原图片的size
 @imageSize 水印图片的size
 @proportion 比例系数
 */
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

#pragma mark - 是否要加水印

/* 判断是否要加水印 */
-(BOOL)isNeed{
    return (self.isOpen || self.isOpenWatermark);
}

#pragma mark - 辅助方法

/* 计算NSData的大小 */
- (void)_calulateFileSize:(NSData *)data {
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"data length is 【 %.3f 】【 %@ 】",dataLength,typeArray[index]);
}

/* 清除显存 */
-(void)_purgeAllUnassignedFramebuffers{
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

#pragma mark - 懒加载

-(WaterMarkLayer *)layer{
    if (!_layer) {
        _layer = [WaterMarkLayer layer];
        _layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _layer;
}

-(GPUImageAlphaBlendFilter *)filter{
    if (!_filter) {
        _filter = [[GPUImageAlphaBlendFilter alloc] init];
        _filter.mix = 1.f;
    }
    return _filter;
}

-(GPUImageFilter *)disFilter{
    if (!_disFilter) {
        _disFilter = [[GPUImageFilter alloc] init];
    }
    return _disFilter;
}

@end
