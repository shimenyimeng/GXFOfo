//
//  GXFLoopView.m
//  021-- 图片轮播（无限）
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GXFLoopView.h"
#import "GXFFlowLayout.h"
#import "GXFCollectionViewCell.h"

NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface GXFLoopView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation GXFLoopView {
    
    NSMutableArray *_images;
    NSTimer *_timer;
}

- (instancetype)initWithImages:(NSMutableArray *)images {
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[GXFFlowLayout alloc] init]]) {
        self.backgroundColor = [UIColor whiteColor];
        // 设置代理、数据源
        self.dataSource = self;
        self.delegate = self;
        
        // 注册cell
        [self registerClass:[GXFCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
        
    }
    
    // 保存数据
    _images = images;
    
    // 开启定时器
    self.timer;
    
    // 滚动到中间一组
    // 开启异步线程到祝队列，保证数据源方法走完之后再走这部分代码
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:5];
//        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        
//    });
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GXFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.image = _images[indexPath.row];
//    NSLog(@"%@", cell.image);
    return cell;
}

// 逻辑处理，当滚动到第6组第一个时，跳到第5组第1个，当滚动到第4组最后一个时，滚动到第5组最后一个（这里的最后一个，写成图片的个数减1，不要使用魔鬼数字）

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    // 拿到索引
////    NSIndexPath *indexPath = self.indexPathsForVisibleItems.firstObject;
//    NSInteger section = scrollView.contentOffset.x / self.bounds.size.width / _images.count;
//    NSInteger row = (scrollView.contentOffset.x - section * self.bounds.size.width * 3) / self.bounds.size.width;
////    NSLog(@"%zd--%zd", section, row);
//    if (section >= 6) {
//        // 滚动到第5组第1个
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:5] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    } else if (section <= 4) {
//        
//        GXFLog(@"+++++++%zd", row);
//        // 滚动到第5组最后一个
//        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:5] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    }
//    
////    // 设置currentPage
////    self.currentPage = indexPath.row;
//    
//    // 使用代理告诉viewController的pageControl当前的页数
//    self.pageControl.currentPage = row;
//    
//}

// 拖拽时暂停定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSArray *visibleItems = self.indexPathsForVisibleItems;
    NSIndexPath *indexPath = visibleItems[0];
    if ([self.customDelegate respondsToSelector:@selector(loopViewCurrentNumber:)]) {
        [self.customDelegate loopViewCurrentNumber:indexPath.row];
    }
    
    NSInteger section = self.contentOffset.x / self.bounds.size.width / _images.count;
    // 主要是用row
    NSInteger row = (self.contentOffset.x - section * self.bounds.size.width * 3) / self.bounds.size.width;
    
    if (section == 6) {
        
        // 无动画的跳到第5组第1个
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:5] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    } else if (section == 4) {
        
        // 无动画的调到第5组最后一个
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:5] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

// 停止减速后，开启定时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleItems = self.indexPathsForVisibleItems;
    NSIndexPath *indexPath = visibleItems[0];
    if ([self.customDelegate respondsToSelector:@selector(loopViewCurrentNumber:)]) {
        [self.customDelegate loopViewCurrentNumber:indexPath.row];
    }
    if (self.timer == nil) {
        self.timer;
    }
}


// 懒加载pageControl
- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _images.count;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    
    return _pageControl;
}

//- (NSTimer *)timer {
//    
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            
//            // 改变contentOffset
//            NSInteger section = self.contentOffset.x / self.bounds.size.width / _images.count;
//            // 主要是用row
//            NSInteger row = (self.contentOffset.x - section * self.bounds.size.width * 3) / self.bounds.size.width;
//            row++;
//            if (row == 3) {
//                row = 0;
//                
//                section ++;
//            }
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
//            [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//            
//        }];
//        
//    }
//    
//    return _timer;
//}

@end
