//
//  OFOMessageListCell.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/12.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOMessageListCell.h"

@interface OFOMessageListCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subtitleLbl;
@property (nonatomic, strong) UILabel *rightLbl;

@end

@implementation OFOMessageListCell

- (instancetype)initWithIconName:(NSString *)iconName title:(NSString *)title subtitle:(NSString *)subtitle rightText:(NSString *)rightText {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIndentifier"]) {
        UIImageView *iconView = [UIImageView new];
        iconView.image = [UIImage imageNamed:iconName];
        [self.contentView addSubview:iconView];
        UILabel *titleLbl = [UILabel new];
        titleLbl.text = title;
        titleLbl.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:titleLbl];
        UILabel *subtitleLbl = [UILabel new];
        subtitleLbl.text = subtitle;
        subtitleLbl.font = [UIFont systemFontOfSize:13];
        subtitleLbl.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subtitleLbl];
        UILabel *rightLbl = [UILabel new];
        rightLbl.text = rightText;
        rightLbl.font = [UIFont systemFontOfSize:12];
        rightLbl.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:rightLbl];
        self.iconView = iconView;
        self.titleLbl = titleLbl;
        self.subtitleLbl = subtitleLbl;
        self.rightLbl = rightLbl;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.top.equalTo(self.iconView).offset(5);
    }];
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.bottom.equalTo(self.iconView).offset(-5);
    }];
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.subtitleLbl.mas_top).offset(-10);
    }];
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UIImageView *iconView = [UIImageView new];
//        [self.contentView addSubview:<#(nonnull UIView *)#>];
//    }
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
