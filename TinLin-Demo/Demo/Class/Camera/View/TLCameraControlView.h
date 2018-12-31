//
//  TLCameraControlView.h
//  Demo
//
//  Created by Mac on 2018/12/30.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TLCaptureType) {
    
    TLCaptureTypePhoto = 0x0001,
    TLCaptureTypeVideo = 0x0002,
    TLCaptureTypeAll   = TLCaptureTypePhoto | TLCaptureTypeVideo
};

@class TLCameraControlView;

@protocol TLCameraControlViewDelegate <NSObject>

- (void)didCancel:(TLCameraControlView *)controlView;

- (void)didTakePicture:(TLCameraControlView *)controlView;

- (void)didStartVideoCapture:(TLCameraControlView *)controlView;

- (void)didEndVideoCapture:(TLCameraControlView *)controlView;

@end

@interface TLCameraControlView : UIView

//
@property (nonatomic, weak, nullable)id <TLCameraControlViewDelegate> delegate;

//
@property (nonatomic, assign, readonly)TLCaptureType type;

- (instancetype)initWithFrame:(CGRect)frame CaptureType:(TLCaptureType)type;

@end
