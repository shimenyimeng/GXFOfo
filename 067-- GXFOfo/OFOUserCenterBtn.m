//
//  OFOUserCenterBtn.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/13.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOUserCenterBtn.h"

@implementation OFOUserCenterBtn

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect rect = self.titleLabel.frame;
    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y, rect.size.width, rect.size.height);
    self.titleLabel.frame = newRect;
    CGRect rect2 = self.imageView.frame;
    CGRect newRect2 = CGRectMake(rect2.origin.x, rect2.origin.y + 1, rect2.size.width - 2, rect2.size.height -2);
    self.imageView.frame = newRect2;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
