//
//  DZQrScanningBaseVC.h
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZQrModel.h"
@class DZQrScanningBaseView;
@class DZQrScanningBaseVC;
@protocol DZQrScanningBaseVCDelegate <NSObject>

- (void)qrScanningBaseVC:(DZQrScanningBaseVC *)scanningBaseVC manualInputBtnClick:(UIButton *)button;

@end
@interface DZQrScanningBaseVC : UIViewController

@property (nonatomic, strong) DZQrScanningBaseView *scanningView;

@property (nonatomic, weak) id delegate;

@end
