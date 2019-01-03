//
//  TLCaptureManager.m
//  Demo
//
//  Created by Mac on 2019/1/3.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLCaptureManager.h"

#import <AVFoundation/AVFoundation.h>

@interface TLCaptureManager ()

// 负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *captureSession;

// 视频输入
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
// 音频输入
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
// 视频输出流
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
// 音频输出流
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

// 图片输出流 iOS10以前
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
// 图片输出流 iOS10以后
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;

// <#note#>
@property (nonatomic, strong) AVAssetWriter *assetWriter;
// <#note#>
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;
// <#note#>
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;
// <#note#>
@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
// <#note#>
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;
// <#note#>
@property (nonatomic, assign) BOOL canWrite;

// 预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

// videoQueue
@property (nonatomic, strong) dispatch_queue_t videoQueue;


@end

@implementation TLCaptureManager


#pragma mark - Private

/**
 *  设置视频录入
 */
- (void)_setupVideo {
    AVCaptureDevice *captureDevice = [self _fetchCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice){
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error){
        NSLog(@"取得设备输入videoInput对象时出错，错误原因：%@", error);
        return;
    }
    // 将设备输出添加到会话中
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 立即丢弃旧帧，节省内存，默认YES
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.captureSession canAddOutput:self.videoOutput]) {
        [self.captureSession addOutput:self.videoOutput];
    }
}

/**
 *  设置音频录入
 */
- (void)_setupAudio {
    NSError *error = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    if (error) {
        NSLog(@"取得设备输入audioInput对象时出错，错误原因：%@", error);
        return;
    }
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
    
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if([self.captureSession canAddOutput:self.audioOutput]) {
        [self.captureSession addOutput:self.audioOutput];
    }
}

- (void)_setupStillImageOutput {
    NSDictionary *outputSettings = @{
                                     // AVVideoScalingModeKey:AVVideoScalingModeResizeAspect,
                                     AVVideoCodecKey:AVVideoCodecTypeJPEG
                                     };
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.captureSession canAddOutput:self.stillImageOutput]) {
        [self.captureSession addOutput:self.stillImageOutput];
    }
}

- (void)_setupPhotoOutput {
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.captureSession canAddOutput:self.photoOutput]) {
        [self.captureSession addOutput:self.photoOutput];
    }
}

/**
 *  设置预览layer
 */
- (void)_setupCaptureVideoPreviewLayer {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
//    CALayer *layer = self.viewContainer.layer;
    
//    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // 填充模式
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
//    [layer addSublayer:_captureVideoPreviewLayer];
}

#pragma mark - Public

/**
 *  开启会话
 */
- (void)startSession {
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

/**
 *  停止会话
 */
- (void)stopSession {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate


#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate


#pragma mark - AVCapturePhotoCaptureDelegate


#pragma mark - 辅助方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)_fetchCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if (!device) {
        // If the back dual camera is not available, default to the back wide angle camera.
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    if (!device) {
        // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    return device;
}

#pragma mark - Setter

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (dispatch_queue_t)videoQueue {
    if (!_videoQueue) {
        _videoQueue = dispatch_queue_create("com.tinlin.videoQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _videoQueue;
}

@end
