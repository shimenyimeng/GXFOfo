//
//  DZQrModel.h
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QRCodeNotificationCenter [NSNotificationCenter defaultCenter]
#define QRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define QRCodeScreenHeight [UIScreen mainScreen].bounds.size.height

//扫描内容的Y值
#define scanContent_Y self.frame.size.height * 0.24
//扫描内容的X值
#define scanContent_X self.frame.size.width * 0.15

//二维码扫描线动画时间
UIKIT_EXTERN CGFloat const QRCodeScanningLineAnimation;

//扫描得到的二维码信息
UIKIT_EXTERN NSString *const QRCodeInformationFromeScanning;
