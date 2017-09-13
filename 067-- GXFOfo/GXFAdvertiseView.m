//
//  GXFAdvertiseView.m
//  061-- GXFApplication
//
//  Created by 顾雪飞 on 17/4/18.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "GXFAdvertiseView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#define IMAGE_HOST @"https://timgsa.baidu.com/"
// https://timgsa.baidu.com/
// timg?image&quality=80&size=b9999_10000&sec=1492511357074&di=992edbe0ce0b9b0522da2f9d62a4d313&imgtype=0&src=http%3A%2F%2Fpic55.nipic.com%2Ffile%2F20141208%2F19462408_171130083000_2.jpg

// 网络请求广告图片的地址（假如为这个）
static NSString *const adImageName = @"timg?image&quality=80&size=b9999_10000&sec=1492511357074&di=992edbe0ce0b9b0522da2f9d62a4d313&imgtype=0&src=http%3A%2F%2Fpic55.nipic.com%2Ffile%2F20141208%2F19462408_171130083000_2.jpg";
static NSInteger const showtime = 3;

@interface GXFAdvertiseView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GXFAdvertiseView

+ (instancetype)advertiseView {
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 添加控件
        [self addSubview:self.bgImageView];
        [self addSubview:self.timeLabel];
        self.timeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeLabelClick:)];
        [self.timeLabel addGestureRecognizer:tap];
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self loadAd];
        
        [self downLoadAd];
        
        [self countRelease];
    }
    
    return self;
}

- (void)timeLabelClick:(UILabel *)timeLabel {
    
    [self dismiss];
}

- (void)loadAd {
    
    // 先去本地找
    NSString *imageName = [self getAdvertiseImage];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@", IMAGE_HOST, imageName];
    
    UIImage *existImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imagePath];
    
    if (existImage) {
        self.bgImageView.image = existImage;
    } else {
        self.hidden = YES;
    }
    
}

- (void)downLoadAd {
    
    NSString *imageName = adImageName;
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_HOST, imageName]];
    
    // 下载成功不需要自动设置图片，本地化以便下次启动使用
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        // 本地化
        NSLog(@"广告下载成功");
        [self saveAdvertiseImage:imageName];
        
    }];
    
}

- (void)countRelease {
    
    __block NSInteger time = showtime + 1;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        if (time <= 0) {
            
            // 停止定时器
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self dismiss];
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.timeLabel.text = [NSString stringWithFormat:@"%@（%zds）", @"跳过", time];
            });
            
            time--;
        }
        
    });
    dispatch_resume(timer);
    
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(40);
    }];
}

- (NSString *)getAdvertiseImage {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
}

- (void)saveAdvertiseImage:(NSString *)imageName {
    
    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:adImageName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _timeLabel;
}

@end
