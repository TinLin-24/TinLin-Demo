//
//  TLCameraViewController.m
//  Demo
//
//  Created by Mac on 2018/12/27.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface TLCameraViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TLCameraControlViewDelegate>

//
@property (nonatomic, strong)TLCameraControlView *controlView;

@end

@implementation TLCameraViewController

- (instancetype)initWithCaptureType:(TLCaptureType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self configCaptureType:type];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self _isVideoRecordingAvailable]) {
        return;
    }

    self.delegate = self;
    
    //隐藏系统自带UI
    self.showsCameraControls = NO;
    
    self.cameraOverlayView = self.controlView;
    //设置摄像头
//    [self switchCameraIsFront:NO];
    //设置视频画质类别
    self.videoQuality = UIImagePickerControllerQualityTypeMedium;
    //设置闪光灯类型
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    //设置录制的最大时长
//    self.videoMaximumDuration = 10;
}

#pragma mark - Private methods

- (BOOL)_isVideoRecordingAvailable {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (void)configCaptureType:(TLCaptureType)type {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    switch (type) {
        case TLCaptureTypePhoto: {
            self.mediaTypes = @[(NSString *)kUTTypeImage];
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//            float aspectRatio = 4.0/3.0;
//            float scale = screenSize.height/screenSize.width * aspectRatio;
//            self.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
            break;
        }
        case TLCaptureTypeVideo: {
            self.mediaTypes = @[(NSString *)kUTTypeMovie];
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            break;
        }
        case TLCaptureTypeAll: {
            self.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            break;
        }
    }
}

#pragma mark - TLCameraControlViewDelegate

- (void)didCancel:(TLCameraControlView *)controlView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTakePicture:(TLCameraControlView *)controlView {
    [self takePicture];
}

- (void)didStartVideoCapture:(TLCameraControlView *)controlView {
    [self startVideoCapture];
}

- (void)didEndVideoCapture:(TLCameraControlView *)controlView {
    [self stopVideoCapture];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //录制完的视频保存到相册
    
//    UIImagePickerControllerOriginalImage,
//    UIImagePickerControllerMediaType,
//    UIImagePickerControllerMediaMetadata
    NSString *type = info[@"UIImagePickerControllerMediaType"];
    
    
    NSLog(@"type:%@",type);
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __block NSString *createdAssetID = nil;//唯一标识，可以用于图片资源获取
//    NSError *error;
//    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//        createdAssetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
//    } error:&error];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (TLCameraControlView *)controlView {
    if (!_controlView) {
        _controlView = [[TLCameraControlView alloc] initWithFrame:self.view.bounds CaptureType:self.type];
        _controlView.delegate = self;
    }
    return _controlView;
}


@end
