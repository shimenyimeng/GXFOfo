//
//  OFOMessageHeaderView.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/12.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOMessageHeaderView.h"
#import "GXFLoopView.h"
#import "OFOMessageFucView.h"

@interface OFOMessageHeaderView () <GXFLoopViewDelegate>
@property (nonatomic, strong) GXFLoopView *loopView;
@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) UILabel *indexLbl;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation OFOMessageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.loopView = [[GXFLoopView alloc] initWithImages:self.imagesArray];
        self.loopView.customDelegate = self;
        [self addSubview:self.loopView];
        UILabel *lbl = [UILabel new];
        self.lbl = lbl;
        lbl.text = @"我的消息";
        lbl.font = [UIFont systemFontOfSize:25];
        [self addSubview:lbl];
        UILabel *indexLbl = [UILabel new];
        self.indexLbl = indexLbl;
        indexLbl.text = [NSString stringWithFormat:@"1/%zd", self.imagesArray.count];
        indexLbl.textColor = [UIColor grayColor];
        [self addSubview:indexLbl];
        [self addSubview:self.functionView];
        UIView *bottomView = [UIView new];
        self.bottomView = bottomView;
        bottomView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self addSubview:bottomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.height.mas_equalTo(200);
    }];
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self.loopView.mas_top).offset(0);
    }];
    [self.indexLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.loopView.mas_top).offset(-5);
    }];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.bottom.equalTo(self).offset(-50);
        make.height.mas_equalTo(70);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - GXFLoopViewDelegate
- (void)loopViewCurrentNumber:(NSInteger)currentNumber {
    self.indexLbl.text = [NSString stringWithFormat:@"%zd/%zd", currentNumber + 1, self.imagesArray.count];
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"freegoNoBond"], [UIImage imageNamed:@"adoptNoBond"], [UIImage imageNamed:@"ComeInbanner"]]];
    }
    return _imagesArray;
}

- (UIView *)functionView {
    if (!_functionView) {
        _functionView = [UIView new];
        OFOMessageFucView *funcView1 = [[OFOMessageFucView alloc] initWithImageName:@"icon_slide_certify" title:@"邀请好友"];
        [_functionView addSubview:funcView1];
        [funcView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_functionView);
            make.width.mas_equalTo(60);
        }];
        OFOMessageFucView *funcView2 = [[OFOMessageFucView alloc] initWithImageName:@"HomePage_nearbyBikeRedPacket" title:@"兑优惠券"];
        [_functionView addSubview:funcView2];
        [funcView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(funcView1);
            make.center.equalTo(_functionView);
        }];
        OFOMessageFucView *funcView3 = [[OFOMessageFucView alloc] initWithImageName:@"free_pic" title:@"爱心公益"];
        [_functionView addSubview:funcView3];
        [funcView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_functionView);
            make.width.equalTo(funcView1);
        }];
    }
    return _functionView;
}

@end
