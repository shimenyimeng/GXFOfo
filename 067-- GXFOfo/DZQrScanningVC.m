//
//  DZQrScanningVC.m
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import "DZQrScanningVC.h"

@interface DZQrScanningVC ()

@end

@implementation DZQrScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [QRCodeNotificationCenter addObserver:self selector:@selector(QRCodeInformationFromeScanning:) name:QRCodeInformationFromeScanning object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)QRCodeInformationFromeScanning:(NSNotification *)noti {
    
    NSString *string = noti.object;
    GXFLog(@"%@", string);
}

- (void)dealloc {
    NSLog(@"DZQrScanningVC - dealloc");
    [QRCodeNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
