//
//  OFOUserCenterVc.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/18.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOUserCenterVc.h"
#import "pop.h"
#import "OFOUserCenterBtn.h"
#import "OFOMyTripVc.h"
#import "OFOMyWalletVc.h"
#import "OFOInviteFriendVc.h"
#import "OFOYouHuiVc.h"
#import "OFOMyServiceVc.h"

@interface OFOUserCenterVc ()
@property (nonatomic, strong) UIView *userCenterTopView;
@property (nonatomic, strong) UIView *userCenterBottomView;
@end

@implementation OFOUserCenterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBar.barTintColor = GXFRGBColor(253, 223, 50);
    
    // 上下同时出现
    UIView *topView = [UIView new];
    self.userCenterTopView = topView;
    topView.backgroundColor = GXFRGBColor(253, 223, 50);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top);
        make.height.mas_equalTo(200);
    }];
    [self.view addSubview:self.userCenterBottomView];
    [self.userCenterBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(self.view.bounds.size.height - 64);
    }];
    
    [UIView animateWithDuration:0.01 animations:^{
        topView.transform = CGAffineTransformMakeTranslation(0, 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            topView.transform = CGAffineTransformMakeTranslation(0, 200);
            self.userCenterBottomView.transform = CGAffineTransformMakeTranslation(0, -self.userCenterBottomView.bounds.size.height);
        }];
    }];
}

#pragma mark - 用户中心条目的点击
- (void)useCenterBtnClick:(OFOUserCenterBtn *)button {
    self.navigationController.navigationBar.hidden = NO;
    if (button.tag == 0) { // 我的行程
        OFOMyTripVc *myTripVc = [OFOMyTripVc new];
        [self.navigationController pushViewController:myTripVc animated:YES];
    } else if (button.tag == 1) { // 我的钱包
        OFOMyWalletVc *myWalletVc = [OFOMyWalletVc new];
        [self.navigationController pushViewController:myWalletVc animated:YES];
    } else if (button.tag == 2) { // 邀请好友
        OFOInviteFriendVc *inviteFriendVc = [OFOInviteFriendVc new];
        [self.navigationController pushViewController:inviteFriendVc animated:YES];
    } else if (button.tag == 3) { // 兑优惠券
        OFOYouHuiVc *youHuiVc = [OFOYouHuiVc new];
        [self.navigationController pushViewController:youHuiVc animated:YES];
    } else if (button.tag == 4) { // 我的客服
        OFOMyServiceVc *myServiceVc = [OFOMyServiceVc new];
        [self.navigationController pushViewController:myServiceVc animated:YES];
    }
}

#pragma mark - 用户中心的拖拽手势
- (void)removeUserCenterView:(UIPanGestureRecognizer *)pan {
    [UIView animateWithDuration:0.25 animations:^{
        self.userCenterBottomView.transform = CGAffineTransformIdentity;
        self.userCenterTopView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.userCenterBottomView removeFromSuperview];
        self.userCenterBottomView = nil;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (UIView *)userCenterBottomView {
    if (!_userCenterBottomView) {
        _userCenterBottomView = [UIView new];
        _userCenterBottomView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeUserCenterView:)];
        [_userCenterBottomView addGestureRecognizer:pan];
        
        UIImageView *roundView = [UIImageView new];
        UIImage *originalImage = [UIImage imageNamed:@"home_arc_bg"];
        // 注意c函数，使用的坐标都是像素
        CGFloat imageW = originalImage.size.width * 2;
        CGFloat imageH = originalImage.size.height * 2;
        CGFloat imageX = 0;
        CGFloat imageY = originalImage.size.height;
        CGImageRef cgImage = CGImageCreateWithImageInRect(originalImage.CGImage, CGRectMake(imageX, imageY, imageW, imageH));
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        roundView.image = [UIImage imageNamed:@"home_arc_bg"];
        [roundView sizeToFit];
        [_userCenterBottomView addSubview:roundView];
        [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_userCenterBottomView);
            make.top.equalTo(_userCenterBottomView).offset(0);
        }];
        UIImageView *iconView = [UIImageView new];
        iconView.image = [UIImage imageNamed:@"UserInfo_defaultIcon"];
        [iconView sizeToFit];
        [_userCenterBottomView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userCenterBottomView).offset(50);
            make.top.equalTo(_userCenterBottomView).offset(20);
        }];
        
        UIView *selectView = [UIView new];
        selectView.backgroundColor = [UIColor whiteColor];
        [_userCenterBottomView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_userCenterBottomView);
            make.top.equalTo(iconView.mas_bottom);
        }];
        
        UIView *phoneNumView = [UIView new];
        UILabel *phoneNumLbl = [UILabel new];
        phoneNumLbl.text = @"15075057832";
        [phoneNumView addSubview:phoneNumLbl];
        [phoneNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(phoneNumView);
        }];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"icon_slide_certify"];
        [imageView sizeToFit];
        [phoneNumView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneNumLbl.mas_right).offset(5);
            make.centerY.equalTo(phoneNumLbl);
            make.width.height.mas_equalTo(15);
        }];
        UILabel *scoreLbl = [UILabel new];
        scoreLbl.font = [UIFont systemFontOfSize:13];
        scoreLbl.text = @"已认证信用分257";
        scoreLbl.textColor = [UIColor grayColor];
        [phoneNumView addSubview:scoreLbl];
        [scoreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneNumLbl);
            make.top.equalTo(phoneNumLbl.mas_bottom).offset(5);
        }];
        [selectView addSubview:phoneNumView];
        [phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectView).offset(50);
            make.top.equalTo(selectView).offset(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(100);
        }];
        NSArray *iconNameArray = @[@"icon_slide_trip2", @"icon_slide_wallet2", @"icon_slide_invite2", @"icon_slide_coupon2", @"icon_slide_usage_guild2"];
        NSArray *titleArray = @[@"我的行程", @"我的钱包", @"邀请好友", @"兑优惠券", @"我的客服"];
        for (NSInteger i = 0; i<5; i++) {
            UIButton *btn = [OFOUserCenterBtn buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:iconNameArray[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = i;
            [btn addTarget:self action:@selector(useCenterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(phoneNumView);
                make.top.equalTo(selectView.mas_bottom);
            }];
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.springBounciness = 2;
            anim.springSpeed = 10;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(90, 100 + i * 40)];
            // 设置按钮动画的开始时间
            anim.beginTime = CACurrentMediaTime() + 0.1 * i;
            [btn pop_addAnimation:anim forKey:nil];
        }
    }
    return _userCenterBottomView;
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
