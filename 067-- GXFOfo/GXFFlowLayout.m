//
//  GXFFlowLayout.m
//  021-- 图片轮播（无限）
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GXFFlowLayout.h"

@implementation GXFFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 设置一系列与cell布局有关的代码
    // 同时也可以在这里设置flowLayout附属的collectionView的属性
    self.itemSize = self.collectionView.bounds.size;
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}

@end
