//
//  TLCameraControlView.m
//  Demo
//
//  Created by Mac on 2018/12/30.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "TLCameraControlView.h"

#import "TLShutterButton.h"

@interface TLCameraControlView ()

//
@property (nonatomic, assign, readwrite)TLCaptureType type;

//
@property (nonatomic, strong)UIButton *cancelBtn;
//
@property (nonatomic, strong)TLShutterButton *shutterButton;

@end

@implementation TLCameraControlView

- (instancetype)initWithFrame:(CGRect)frame CaptureType:(TLCaptureType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    [self addSubview:self.cancelBtn];
    
    [self addSubview:self.shutterButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shutterButton.center = CGPointMake(self.width/2, self.height-90.f);
}

#pragma mark - Action

- (void)_didCancel:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancel:)]) {
        [self.delegate didCancel:self];
    }
}

- (void)_didTakePicture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTakePicture:)]) {
        [self.delegate didTakePicture:self];
    }
}

- (void)_didStartVideoCapture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartVideoCapture:)]) {
        [self.delegate didStartVideoCapture:self];
    }
}

- (void)_didEndVideoCapture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndVideoCapture:)]) {
        [self.delegate didEndVideoCapture:self];
    }
}

#pragma mark - Getter

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(20.f, TLTopMargin(20.f), 50.f, 30.f);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(_didCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (TLShutterButton *)shutterButton {
    if (!_shutterButton) {
        _shutterButton = [[TLShutterButton alloc] initWithFrame:CGRectMake(0, 0, 125.f, 125.f) EnableType:(TLEnableType)self.type];
        @weakify(self);
        _shutterButton.didTap = ^(TLShutterButton *sender) {
            @strongify(self);
            [self _didTakePicture];
        };
        _shutterButton.didStartLongPress = ^(TLShutterButton *sender) {
            @strongify(self);
            [self _didStartVideoCapture];
        };
        _shutterButton.didEndLongPress = ^(TLShutterButton *sender) {
            @strongify(self);
            [self _didEndVideoCapture];
        };
    }
    return _shutterButton;
}

@end
