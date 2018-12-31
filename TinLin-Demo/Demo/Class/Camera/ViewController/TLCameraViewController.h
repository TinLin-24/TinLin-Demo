//
//  TLCameraViewController.h
//  Demo
//
//  Created by Mac on 2018/12/27.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCameraControlView.h"

@interface TLCameraViewController : UIImagePickerController

//
@property (nonatomic, assign)NSTimeInterval tl_videoMaximumDuration;

//
@property (nonatomic, assign, readonly)TLCaptureType type;

//
@property (nonatomic, copy)void (^didFetchImage)(UIImage *originalImage);

//
@property (nonatomic, copy)void (^didFetchVideo)(NSURL *videoPath);

- (instancetype)initWithCaptureType:(TLCaptureType)type;

@end
