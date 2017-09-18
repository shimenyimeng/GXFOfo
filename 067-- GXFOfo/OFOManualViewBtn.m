//
//  OFOManualViewBtn.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/17.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOManualViewBtn.h"

@implementation OFOManualViewBtn

+ (instancetype)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title {
    OFOManualViewBtn *btn = [OFOManualViewBtn buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = CGRectMake(contentRect.size.width * 0.5 - 10.5, 0, 21, 21);
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = CGRectMake(0, 35, contentRect.size.width, contentRect.size.height * 0.4);
    return rect;
}

@end
