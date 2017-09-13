//
//  GXFLoopView.h
//  021-- 图片轮播（无限）
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXFLoopView;
@protocol GXFLoopViewDelegate <NSObject>

- (void)loopViewCurrentNumber:(NSInteger)currentNumber;

@end

@interface GXFLoopView : UICollectionView

// 把当前的页索引保存起来，供viewController使用
//@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<GXFLoopViewDelegate> customDelegate;

- (instancetype)initWithImages:(NSArray *)images;

@end
