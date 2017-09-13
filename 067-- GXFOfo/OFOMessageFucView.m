//
//  OFOMessageFucView.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/12.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOMessageFucView.h"

@interface OFOMessageFucView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLbl;

@end

@implementation OFOMessageFucView

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        UILabel *titleLbl = [UILabel new];
        titleLbl.text = title;
        titleLbl.font = [UIFont systemFontOfSize:13];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl];
        self.imageView = imageView;
        self.titleLbl = titleLbl;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self.bounds.size.width);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
    }];
}

@end
