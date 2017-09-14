//
//  DZQrScanningBaseView.h
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZQrScanningBaseView;
@protocol DZQrScanningBaseViewDelegate <NSObject>

- (void)qrScanningBaseView:(DZQrScanningBaseView *)scanningBaseView closeBtnClick:(UIButton *)closeBtn;
- (void)qrScanningBaseView:(DZQrScanningBaseView *)scanningBaseView manualBtnClcik:(UIButton *)manualBtn;

@end

@interface DZQrScanningBaseView : UIView

+ (instancetype)scanningViewWithFrame:(CGRect )frame layer:(CALayer *)layer;

- (void)addTimer;
- (void)removeTimer;

@property (nonatomic, weak) id delegate;
@end
