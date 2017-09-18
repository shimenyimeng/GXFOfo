//
//  OFOBaseViewController.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/18.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOBaseViewController.h"

@interface OFOBaseViewController ()

@end

@implementation OFOBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIndicator"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
