//
//  DZQrScanningBaseView.m
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import "DZQrScanningBaseView.h"
#import <AVFoundation/AVFoundation.h>
#import "DZQrModel.h"

@interface DZQrScanningBaseView ()

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) CALayer *tempLayer;
@property (nonatomic, strong) UIImageView *scanningline;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *light_button;

@end
@implementation DZQrScanningBaseView
//扫描动画线的高度
static CGFloat const scanninglineHeight = 5;
//扫描内容外部View的alpha值
static CGFloat const scanBorderOutsideViewAlpha = 0.4;

- (CALayer *)tempLayer {
    if (!_tempLayer) {
        _tempLayer = [[CALayer alloc] init];
    }
    return _tempLayer;
}

- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer {
    if (self = [super initWithFrame:frame]) {
        self.tempLayer = layer;
        // 布局扫描界面
        [self setupSubviews];
        
    }
    return self;
}

+ (instancetype)scanningViewWithFrame:(CGRect )frame layer:(CALayer *)layer {
    return [[self alloc] initWithFrame:frame layer:layer];
}
- (void)setupSubviews {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"whiteClose"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnCliak) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(30);
    }];
    
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"yellowBikeWhiteTitle"];
    [self addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(30);
    }];
    
    // 扫描内容的创建
    CALayer *scanContent_layer = [[CALayer alloc] init];
    CGFloat scanContent_layerY = scanContent_Y;
    CGFloat scanContent_layerW = self.frame.size.width - 2 * scanContent_X;
    CGFloat scanContent_layerH = scanContent_layerW;
    scanContent_layer.frame = CGRectMake(scanContent_X, scanContent_layerY, scanContent_layerW, scanContent_layerH);
    scanContent_layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
//    scanContent_layer.borderWidth = 20;
    scanContent_layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.tempLayer addSublayer:scanContent_layer];
    
    // 扫描框图片
    UIImageView *QrImageView = [UIImageView new];
    QrImageView.image = [UIImage imageNamed:@"bg_QRCodeStorke"];
    [self addSubview:QrImageView];
    QrImageView.frame = CGRectMake(scanContent_X, scanContent_layerY, scanContent_layerW, scanContent_layerH);
    
    // 顶部layer的创建
    CALayer *top_layer = [[CALayer alloc] init];
    CGFloat top_layerX = 0;
    CGFloat top_layerY = 0;
    CGFloat top_layerW = self.frame.size.width;
    CGFloat top_layerH = scanContent_layerY;
    top_layer.frame = CGRectMake(top_layerX, top_layerY, top_layerW, top_layerH);
    top_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:top_layer];
    
    // 左侧layer的创建
    CALayer *left_layer = [[CALayer alloc] init];
    CGFloat left_layerX = 0;
    CGFloat left_layerY = scanContent_layerY;
    CGFloat left_layerW = scanContent_X;
    CGFloat left_layerH = scanContent_layerH;
    left_layer.frame = CGRectMake(left_layerX, left_layerY, left_layerW, left_layerH);
    left_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:left_layer];
    
    // 右侧layer的创建
    CALayer *right_layer = [[CALayer alloc] init];
    CGFloat right_layerX = CGRectGetMaxX(scanContent_layer.frame);
    CGFloat right_layerY = scanContent_layerY;
    CGFloat right_layerW = scanContent_X;
    CGFloat right_layerH = scanContent_layerH;
    right_layer.frame = CGRectMake(right_layerX, right_layerY, right_layerW, right_layerH);
    right_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:right_layer];
    
    // 下面layer的创建
    CALayer *bottom_layer = [[CALayer alloc] init];
    CGFloat bottom_layerX = 0;
    CGFloat bottom_layerY = CGRectGetMaxY(scanContent_layer.frame);
    CGFloat bottom_layerW = self.frame.size.width;
    CGFloat bottom_layerH = self.frame.size.height - bottom_layerY;
    bottom_layer.frame = CGRectMake(bottom_layerX, bottom_layerY, bottom_layerW, bottom_layerH);
    bottom_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:bottom_layer];
    
    // 提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = scanContent_layer.frame.origin.y - 40;
    CGFloat promptLabelW = self.frame.size.width;
    CGFloat promptLabelH = 25;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = @"对准车牌上的二维码，即可自动扫描";
    [self addSubview:promptLabel];
    
    // 添加闪光灯按钮
    UIButton *light_button = [[UIButton alloc] init];
    self.light_button = light_button;
    light_button.layer.cornerRadius = 22.5;
    light_button.layer.masksToBounds = YES;
    [light_button setImage:[UIImage imageNamed:@"btn_unenableTorch_w"] forState:UIControlStateNormal];
    [light_button setImage:[UIImage imageNamed:@"btn_enableTorch_w"] forState:UIControlStateSelected];
    [light_button addTarget:self action:@selector(light_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    light_button.backgroundColor = [UIColor colorWithRed:93/255.0 green:92/255.0 blue:87/255.0 alpha:1.0];
    [self addSubview:light_button];
    [light_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-80);
        make.bottom.equalTo(self).offset(-50);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    // 设置手电筒
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (self.device.torchMode == AVCaptureTorchModeOn) {
        // 改变手电筒按钮的状态
        self.light_button.selected = YES;
    }
    
    UILabel *torchLbl = [UILabel new];
    torchLbl.text = @"打开手电筒";
    torchLbl.font = [UIFont systemFontOfSize:14];
    torchLbl.textColor = [UIColor whiteColor];
    [self addSubview:torchLbl];
    [torchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(light_button);
        make.top.equalTo(light_button.mas_bottom).offset(10);
    }];
    
    // 手动输入
    UIButton *manualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [manualBtn setImage:[UIImage imageNamed:@"inputBlikeNo"] forState:UIControlStateNormal];
    manualBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:92/255.0 blue:87/255.0 alpha:1.0];
    manualBtn.layer.cornerRadius = 22.5;
    manualBtn.layer.masksToBounds = YES;
    [manualBtn addTarget:self action:@selector(manualBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:manualBtn];
    [manualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.bottom.equalTo(self).offset(-50);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    UILabel *manualLbl = [UILabel new];
    manualLbl.text = @"手动输入";
    manualLbl.font = [UIFont systemFontOfSize:14];
    manualLbl.textColor = [UIColor whiteColor];
    [self addSubview:manualLbl];
    [manualLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(manualBtn);
        make.top.equalTo(manualBtn.mas_bottom).offset(10);
    }];
    
    // 左上侧的image
    CGFloat margin = 7;
    
    UIImage *left_image = [UIImage imageNamed:@"qrLeftTop"];
    UIImageView *left_imageView = [[UIImageView alloc] init];
    CGFloat left_imageViewX = CGRectGetMinX(scanContent_layer.frame) - left_image.size.width * 0.5 + margin;
    CGFloat left_imageViewY = CGRectGetMinY(scanContent_layer.frame) - left_image.size.width * 0.5 + margin;
    CGFloat left_imageViewW = left_image.size.width;
    CGFloat left_imageViewH = left_image.size.height;
    left_imageView.frame = CGRectMake(left_imageViewX, left_imageViewY, left_imageViewW, left_imageViewH);
    left_imageView.image = left_image;
    [self.tempLayer addSublayer:left_imageView.layer];
    
    // 右上侧的image
    UIImage *right_image = [UIImage imageNamed:@"qrRightTop"];
    UIImageView *right_imageView = [[UIImageView alloc] init];
    CGFloat right_imageViewX = CGRectGetMaxX(scanContent_layer.frame) - right_image.size.width * 0.5 - margin;
    CGFloat right_imageViewY = left_imageView.frame.origin.y;
    CGFloat right_imageViewW = left_image.size.width;
    CGFloat right_imageViewH = left_image.size.height;
    right_imageView.frame = CGRectMake(right_imageViewX, right_imageViewY, right_imageViewW, right_imageViewH);
    right_imageView.image = right_image;
    [self.tempLayer addSublayer:right_imageView.layer];
    
    // 左下侧的image
    UIImage *left_image_down = [UIImage imageNamed:@"qrLeftBottom"];
    UIImageView *left_imageView_down = [[UIImageView alloc] init];
    CGFloat left_imageView_downX = left_imageView.frame.origin.x;
    CGFloat left_imageView_downY = CGRectGetMaxY(scanContent_layer.frame) - left_image_down.size.width * 0.5 - margin;
    CGFloat left_imageView_downW = left_image.size.width;
    CGFloat left_imageView_downH = left_image.size.height;
    left_imageView_down.frame = CGRectMake(left_imageView_downX, left_imageView_downY, left_imageView_downW, left_imageView_downH);
    left_imageView_down.image = left_image_down;
    [self.tempLayer addSublayer:left_imageView_down.layer];
    
    // 右下侧的image
    UIImage *right_image_down = [UIImage imageNamed:@"qrRightBottom"];
    UIImageView *right_imageView_down = [[UIImageView alloc] init];
    CGFloat right_imageView_downX = right_imageView.frame.origin.x;
    CGFloat right_imageView_downY = left_imageView_down.frame.origin.y;
    CGFloat right_imageView_downW = left_image.size.width;
    CGFloat right_imageView_downH = left_image.size.height;
    right_imageView_down.frame = CGRectMake(right_imageView_downX, right_imageView_downY, right_imageView_downW, right_imageView_downH);
    right_imageView_down.image = right_image_down;
    [self.tempLayer addSublayer:right_imageView_down.layer];
}
- (void)light_buttonAction:(UIButton *)button {
    if (button.selected == NO) { // 点击打开照明灯
        [self turnOnLight:YES];
        button.selected = YES;
    } else { // 点击关闭照明灯
        [self turnOnLight:NO];
        button.selected = NO;
    }
}
- (void)turnOnLight:(BOOL)on {
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}
- (UIImageView *)scanningline {
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = [UIImage imageNamed:@"bg_QRCodeLine"];
        _scanningline.frame = CGRectMake(scanContent_X, scanContent_Y, self.frame.size.width - scanContent_X * 2 , scanninglineHeight);
    }
    return _scanningline;
}

- (void)addScanningline {
    // 扫描动画添加
    [self.tempLayer addSublayer:self.scanningline.layer];
}

- (void)closeBtnCliak {
    if ([self.delegate respondsToSelector:@selector(qrScanningBaseView:closeBtnClick:)]) {
        [self.delegate qrScanningBaseView:self closeBtnClick:nil];
    }
}

- (void)manualBtnClick {
    if ([self.delegate respondsToSelector:@selector(qrScanningBaseView:manualBtnClcik:)]) {
        [self.delegate qrScanningBaseView:self manualBtnClcik:nil];
    }
}

#pragma mark - - - 添加定时器
- (void)addTimer {
    [self addScanningline];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:QRCodeScanningLineAnimation target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark - - - 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
    self.scanningline = nil;
}

#pragma mark - - - 执行定时器方法
- (void)timeAction {
    __block CGRect frame = _scanningline.frame;
    
    static BOOL flag = YES;
    
    if (flag) {
        frame.origin.y = scanContent_Y;
        flag = NO;
        [UIView animateWithDuration:QRCodeScanningLineAnimation animations:^{
            frame.origin.y += 5;
            _scanningline.frame = frame;
        } completion:nil];
    } else {
        if (_scanningline.frame.origin.y >= scanContent_Y) {
            CGFloat scanContent_MaxY = scanContent_Y + self.frame.size.width - 2 * scanContent_X;
            if (_scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = scanContent_Y;
                _scanningline.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:QRCodeScanningLineAnimation animations:^{
                    frame.origin.y += 5;
                    _scanningline.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
