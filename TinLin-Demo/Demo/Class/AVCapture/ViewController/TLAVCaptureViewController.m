//
//  TLAVCaptureViewController.m
//  Demo
//
//  Created by Mac on 2018/12/28.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLAVCaptureViewController.h"

#import "TLShutterButton.h"

#import <AVFoundation/AVFoundation.h>

@interface TLAVCaptureViewController () <AVCaptureFileOutputRecordingDelegate,AVCapturePhotoCaptureDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

// AVCaptureSession
@property (nonatomic, strong) AVCaptureSession *session;

// AVCaptureSession
@property (nonatomic, strong) AVCaptureSession *captureSession;
// AVCaptureDevice
@property (nonatomic, strong) AVCaptureDevice *frontDevice;
// AVCaptureDevice
@property (nonatomic, strong) AVCaptureDevice *backDevice;
// AVCaptureDevice
@property (nonatomic, strong) AVCaptureDevice *audioDevice;

// AVCaptureInput
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
// <#note#>
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;


// 照片输出
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
// 视频输出
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
// 元数据输出
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

// 预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation TLAVCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configure];
    
    [self _setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.rt_disableInteractivePop = NO;
}

- (void)dealloc {
    TLDealloc;
}

- (void)configure {
    if ([self.captureSession canAddInput:self.videoDeviceInput]) {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.photoOutput]) {
        [self.captureSession addOutput:self.photoOutput];
    }
    if ([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession beginConfiguration];
        [self.captureSession addOutput:self.movieFileOutput];
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        connection.automaticallyAdjustsVideoMirroring = YES;
        if (connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        [self.captureSession commitConfiguration];
    }
    [self.captureSession addOutput:self.metadataOutput];
    
    [self.captureSession startRunning];
    
    [self.view.layer addSublayer:self.previewLayer];
}

- (void)_setupSubViews {
    TLShutterButton *btn = [[TLShutterButton alloc] initWithFrame:CGRectMake(0, 0, 125, 125) EnableType:TLEnableTypeAll];
    btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-115.f);
    @weakify(self);
    btn.didTap = ^(TLShutterButton *sender) {
        @strongify(self);
        [self _takePicture];
    };
    btn.didStartLongPress = ^(TLShutterButton *sender) {
        @strongify(self);
        [self _startRecording];
    };
    btn.didEndLongPress = ^(TLShutterButton *sender) {
        @strongify(self);
        [self _didFinishRecording];
    };
    [self.view addSubview:btn];
}

#pragma mark - Action

- (void)_takePicture {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];;
    [settings setFlashMode:AVCaptureFlashModeOff];
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)_startRecording {
    NSString *fileName = [[NSUUID new].UUIDString stringByAppendingPathExtension:@"mp4"];
    NSString *filePath = [TLDocumentDirectory stringByAppendingPathComponent:fileName];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [self.movieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

- (void)_didFinishRecording {
    [self.movieFileOutput stopRecording];
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(nonnull AVCapturePhoto *)photo error:(nullable NSError *)error {
    NSData *data = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"image:%@", image);
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [MBProgressHUD tl_showTips:@"图片已保存至相册"];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"停止录制");
    UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.relativePath, nil, nil, nil);
    [MBProgressHUD tl_showTips:@"视频已保存至相册"];
}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate



#pragma mark - Setter

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (AVCaptureDevice *)frontDevice {
    if (!_frontDevice) {
        _frontDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    return _frontDevice;
}

- (AVCaptureDevice *)backDevice {
    if (!_backDevice) {
        _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        if (!_backDevice) {
            // If the back dual camera is not available, default to the back wide angle camera.
            _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
            // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
            if (!_backDevice) {
                _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
            }
        }
    }
    return _backDevice;
}

- (AVCaptureDevice *)audioDevice {
    if (!_audioDevice) {
        _audioDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInMicrophone mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified];
    }
    return _audioDevice;
}

- (AVCaptureDeviceInput *)videoDeviceInput {
    if (!_videoDeviceInput) {
        _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.backDevice error:nil];
    }
    return _videoDeviceInput;
}

- (AVCapturePhotoOutput *)photoOutput {
    if (!_photoOutput) {
        _photoOutput = [[AVCapturePhotoOutput alloc] init];
    }
    return _photoOutput;
}

- (AVCaptureMovieFileOutput *)movieFileOutput {
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    return _movieFileOutput;
}

- (AVCaptureMetadataOutput *)metadataOutput {
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
//        dispatch_queue_t queue = dispatch_queue_create("metadataOutputQueue", NULL);
//        [_metadataOutput setMetadataObjectsDelegate:self queue:queue];
    }
    return _metadataOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.frame = self.view.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (AVCaptureAudioDataOutput *)audioDataOutput {
    if (!_audioDataOutput) {
        _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        dispatch_queue_t captureQueue = dispatch_queue_create("com.TinLin.audioDataOutput", DISPATCH_QUEUE_SERIAL);
        [_audioDataOutput setSampleBufferDelegate:self queue:captureQueue];
    }
    return _audioDataOutput;
}

@end
