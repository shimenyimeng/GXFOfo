//
//  OFOMyWalletVc.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/18.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOMyWalletVc.h"

@interface OFOMyWalletVc ()

@end

@implementation OFOMyWalletVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的钱包";
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
