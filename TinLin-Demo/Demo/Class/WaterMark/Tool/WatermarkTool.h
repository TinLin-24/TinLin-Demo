//
//  WatermarkTool.h
//
//
//  Created by TinLin on 2018/7/9.
//
//  批量加水印 by TinLin
//

#import <Foundation/Foundation.h>

/* 水印文字 默认字体大小 */
#define WatermarkFontSize 35
/* 水印文字 默认字体颜色 */
#define WatermarkFontColor [[UIColor whiteColor] colorWithAlphaComponent:0.4]
/* 水印文字 倾斜度 */
#define TRANSFORM_ROTATION (-M_PI_4)
/* 水印图片的默认边距 边距会按图片重新计算 */
#define WatermarkImageMargin 10.f
/* 水印图片的最大宽度 高度按比例计算 */
#define WatermarkImageMaxWidth 80.f

/* 水印文字 默认字体颜色 GPUImage加水印 */
#define WatermarkFontColor_GPUImage [UIColor whiteColor] 

typedef void(^CoreSuccess)(id result);

/**
 水印图片的位置
 数值与后台对应
 */
typedef enum : NSInteger {
    UpperLeftCorner = 1,        //左上角
    UpperRightCorner = 2,       //右上角
    LowerLeftCorner = 4,        //左下角
    BottomRightCorner = 3,      //右下角
    CenterPosition = 5,         //居中
} PositionType;

@interface WatermarkTool : NSObject

/**
 单例
 */
+ (instancetype)watermarkInstance;

-(UIImage *)getWaterMarkImage: (UIImage *)originalImage;

-(void)getWaterMarkImage: (UIImage *)originalImage Complete:(void(^)(UIImage *resultImage))complete;

@end
