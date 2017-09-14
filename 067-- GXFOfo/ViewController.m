//
//  ViewController.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/11.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import "OFOMessageViewController.h"
#import "OFOUserCenterBtn.h"
#import "pop.h"
#import "DZQrScanningVC.h"

#define kManualViewHeight 600

@interface ViewController () <MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, DZQrScanningBaseVCDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) NSArray *oldAnnotations;

@property (nonatomic, strong) AMapGeoPoint *oldCenterLocation;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *upDownbutton;
@property (weak, nonatomic) IBOutlet UIView *useView;
@property (weak, nonatomic) IBOutlet UIImageView *roundImageView;
@property (nonatomic, weak) UIButton *useBtn;
@property (nonatomic, weak) UIButton *leftUserCenterBtn;
@property (nonatomic, weak) UIButton *rightMessageBtn;
@property (nonatomic, assign) CGFloat oldX;
@property (nonatomic, assign) CGFloat oldY;
@property (nonatomic, strong) UIView *userCenterBottomView;
@property (nonatomic, strong) UIView *userCenterTopView;
@property (nonatomic, strong) UIView *manualCoverView;
@property (nonatomic, strong) UIView *manualView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self configLocationManager];
    [self startSerialLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupUI {
    
    // 初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    // 把地图添加至view
    [self.view addSubview:mapView];
    mapView.delegate = self;
    mapView.showsCompass = NO;
    mapView.rotateEnabled = NO;
    self.mapView = mapView;
    
    [mapView setZoomLevel:17 animated:YES];
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.rotateCameraEnabled= NO;    //NO表示禁用倾斜手势，YES表示开启
    
    // 定位按钮
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"leftBottomImage"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:locationButton];
    locationButton.frame = CGRectMake(50, 100, 40, 40);
    [self.view bringSubviewToFront:self.bottomView];
    
    // 加载原图
    UIImage *originalImage = [UIImage imageNamed:@"home_arc_bg"];
    // 注意c函数，使用的坐标都是像素
    CGFloat imageW = originalImage.size.width * 2;
    CGFloat imageH = originalImage.size.height * 2;
    CGFloat imageX = 0;
    CGFloat imageY = originalImage.size.height;
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(originalImage.CGImage, CGRectMake(imageX, imageY, imageW, imageH));
    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    [self.upDownbutton setBackgroundImage:image forState:UIControlStateNormal];
    self.roundImageView.image = image;
    
    [self.upDownbutton setImage:[UIImage imageNamed:@"HomePage_rightArrow"] forState:UIControlStateNormal];
    
    UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.useBtn = useBtn;
    [useBtn setImage:[UIImage imageNamed:@"start_button_bg_scan"] forState:UIControlStateNormal];
    [useBtn addTarget:self action:@selector(useBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.useView addSubview:useBtn];
    [useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useView);
        make.centerX.equalTo(self.useView);
        make.width.height.mas_equalTo(180);
    }];
    UIButton *userCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userCenterBtn setImage:[UIImage imageNamed:@"user_center_icon"] forState:UIControlStateNormal];
    self.leftUserCenterBtn = userCenterBtn;
    [userCenterBtn sizeToFit];
    [userCenterBtn addTarget:self action:@selector(userCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.useView addSubview:userCenterBtn];
    [userCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useView).offset(20);
        make.bottom.equalTo(self.useView).offset(-20);
    }];
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightMessageBtn = messageBtn;
    [messageBtn setImage:[UIImage imageNamed:@"gift_icon"] forState:UIControlStateNormal];
    [messageBtn sizeToFit];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.useView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.useView).offset(-20);
        make.bottom.equalTo(self.useView).offset(-20);
    }];
    
    // 给useView添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(upDownUseView:)];
    [self.bottomView addGestureRecognizer:pan];
}

#pragma mark - 配置locationManager
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

#pragma mark - 开始定位
- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}
#pragma mark - 结束定位
- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - 对图片进行旋转
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

#pragma mark - 搜索周边
- (void)searchAroundWithLocation:(AMapGeoPoint *)location {
    
    // poi设置
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    request.keywords = @"超市";
    request.radius = 300;
    //    request.requireExtension    = YES;
    
    [self.search AMapPOIAroundSearch:request];
    
}

#pragma mark - 回到当前位置
- (void)locationButtonClick:(UIButton *)button {
    
    // 获取用户当前的位置
    AMapGeoPoint *location = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    
    // 如果中心点没变，即用户没有进行拖动，则不重新搜索周边（主要是控制点击定位按钮）
    if (self.oldCenterLocation.latitude == self.mapView.centerCoordinate.latitude && self.oldCenterLocation.longitude == self.mapView.centerCoordinate.longitude) {
        
        NSLog(@"ddd");
        return;
    }
    
    // 首先移除上次的大头针
    [self.mapView removeAnnotations:self.oldAnnotations];
    
    [self searchAroundWithLocation:location];
    
    // 记录上一次中心点位置
    NSLog(@"记录一下");
    self.oldCenterLocation = [AMapGeoPoint locationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    [self startSerialLocation];
}

#pragma mark - 弹出收回面板
- (IBAction)upDownButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            // 高210
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, 200);
            self.useBtn.transform = CGAffineTransformMakeTranslation(0, 50);
            self.leftUserCenterBtn.transform = CGAffineTransformMakeTranslation(0, 40);
            self.rightMessageBtn.transform = CGAffineTransformMakeTranslation(0, 40);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            // 高210
            self.bottomView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.05 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.useBtn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.leftUserCenterBtn.transform = CGAffineTransformIdentity;
                self.rightMessageBtn.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
}

#pragma mark - 拖拽手势弹出收回面板
- (void)upDownUseView:(UIPanGestureRecognizer *)pan {
    NSInteger num = 0;
    if (pan.state == UIGestureRecognizerStateBegan) {
        num = 0;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
    }
    CGPoint translation = [pan locationInView:self.useView];
    CGFloat newY = translation.y;
    if (self.upDownbutton.isSelected) {
        if (newY > self.oldY) {
            NSLog(@"下");
        } else {
            NSLog(@"上");
            if (newY < -30) {
                [self upDownButtonClick:self.upDownbutton];
            }
        }
    } else {
        CGPoint translation = [pan locationInView:self.useView];
        CGFloat newY = translation.y;
        if (newY > self.oldY) {
            NSLog(@"下");
            if (newY > 30) {
                [self upDownButtonClick:self.upDownbutton];
            }
        } else {
            NSLog(@"上");
        }
    }
    self.oldY = newY;
}

- (void)userCenterBtnClick {
    // 上下同时出现
    UIView *topView = [UIView new];
    self.userCenterTopView = topView;
    topView.backgroundColor = [UIColor colorWithRed:253/255.0 green:223/255.0 blue:50/255.0 alpha:1.0];
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
        make.height.mas_equalTo(self.view.bounds.size.height - 30);
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

- (void)messageBtnClick {
    OFOMessageViewController *messageVc = [OFOMessageViewController new];
    [self.navigationController pushViewController:messageVc animated:YES];
}

#pragma mark - 扫码用车
- (void)useBtnClcik {
    DZQrScanningVC *scanningVc = [DZQrScanningVC new];
    scanningVc.delegate = self;
    [self presentViewController:scanningVc animated:YES completion:nil];
}

- (void)closeManualView {
    [self.manualCoverView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.manualView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 用户中心的拖拽手势
- (void)removeUserCenterView:(UIPanGestureRecognizer *)pan {
    [UIView animateWithDuration:0.25 animations:^{
        self.userCenterBottomView.transform = CGAffineTransformIdentity;
        self.userCenterTopView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.userCenterBottomView removeFromSuperview];
        self.userCenterBottomView = nil;
    }];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self stopSerialLocation];
}

#pragma mark -  MAMapViewDelegate
- (void)mapInitComplete:(MAMapView *)mapView {
    
    [self locationButtonClick:nil];
    
    // 添加中心点大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    pointAnnotation.title = @"center";
    [pointAnnotation setLockedScreenPoint:CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5)];
    pointAnnotation.lockedToScreen = YES;
    [self.mapView addAnnotation:pointAnnotation];
    
    self.oldCenterLocation = [AMapGeoPoint locationWithLatitude:pointAnnotation.coordinate.latitude longitude:pointAnnotation.coordinate.longitude];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    if (wasUserAction) {
        
        // 首先移除上次的大头针
        [self.mapView removeAnnotations:self.oldAnnotations];
        
        // 在新的中心点重新搜索周边
        // 先找到中心点的位置
        AMapGeoPoint *location = [AMapGeoPoint locationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
        
        [self searchAroundWithLocation:location];
        
        self.oldCenterLocation = location;
    }
    
}

// 用户位置定位好之后，进行周边搜索
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
    
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    MAPointAnnotation *pointAnno = (MAPointAnnotation *)annotation;
    if ([pointAnno.title isEqualToString:@""]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pointReuseIndentifier"];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pointReuseIndentifier"];
        }
        if ([pointAnno.title isEqualToString:@"ofo"]) {
            annotationView.image = [UIImage imageNamed:@"HomePage_nearbyBike"];
        } else if ([pointAnno.title isEqualToString:@"center"]) {
            annotationView.image = [UIImage imageNamed:@"homePage_wholeAnchor"];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSInteger i = 0; i < response.pois.count; i++) {
        
        // 创建大头针
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        AMapPOI *poi = response.pois[i];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        pointAnnotation.title = @"ofo";
        
        [self.mapView addAnnotation:pointAnnotation];
        [annotations addObject:pointAnnotation];
    }
    
    self.oldAnnotations = annotations;
    
    [self.mapView showAnnotations:annotations animated:YES];
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

- (void)qrScanningBaseVC:(DZQrScanningBaseVC *)scanningBaseVC manualInputBtnClick:(UIButton *)button {
    // 添加透明底图
    [self.view addSubview:self.manualCoverView];
    [self.manualCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 添加手动输入视图
    [self.view addSubview:self.manualView];
    [self.manualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(kManualViewHeight);
    }];
    
    [UIView animateWithDuration:0.01 animations:^{
        self.manualView.transform = CGAffineTransformMakeTranslation(0, -1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.manualView.transform = CGAffineTransformMakeTranslation(0, -kManualViewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (UIView *)manualCoverView {
    if (!_manualCoverView) {
        _manualCoverView = [UIView new];
        _manualCoverView.backgroundColor = [UIColor clearColor];
        UIImageView *logoView = [UIImageView new];
        logoView.image = [UIImage imageNamed:@"yellowBikeLogo"];
        [_manualCoverView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_manualCoverView).offset(20);
            make.top.equalTo(_manualCoverView).offset(30);
        }];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"closeFork"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeManualView) forControlEvents:UIControlEventTouchUpInside];
        [_manualCoverView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_manualCoverView).offset(-20);
            make.top.equalTo(_manualCoverView).offset(30);
        }];
    }
    return _manualCoverView;
}

- (UIView *)manualView {
    if (!_manualView) {
        _manualView = [UIView new];
        _manualView.backgroundColor = [UIColor clearColor];
        // 半圆图片
        UIImageView *roundImageView = [UIImageView new];
        roundImageView.image = [UIImage imageNamed:@"home_arc_bg"];
        [_manualView addSubview:roundImageView];
        [roundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_manualView);
        }];
        // 计费说明
        UILabel *jiFeiLbl = [UILabel new];
        jiFeiLbl.layer.cornerRadius = 8;
        jiFeiLbl.layer.masksToBounds = YES;
        jiFeiLbl.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        jiFeiLbl.textAlignment = NSTextAlignmentCenter;
        jiFeiLbl.text = @"计费说明：1元/小时";
        jiFeiLbl.font = [UIFont systemFontOfSize:15];
        [_manualView addSubview:jiFeiLbl];
        [jiFeiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_manualView);
            make.top.equalTo(_manualView).offset(80);
            make.width.mas_equalTo(138);
            make.height.mas_equalTo(18);
        }];
        // 底部视图
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor whiteColor];
        [_manualView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_manualView);
            make.top.equalTo(roundImageView.mas_bottom);
        }];
        UILabel *lbl = [UILabel new];
        lbl.text = @"输入车牌号，获取解锁码";
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor grayColor];
        [bottomView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(5);
        }];
        UITextField *tf = [UITextField new];
        tf.font = [UIFont systemFontOfSize:15];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        tf.placeholder = @"请输入车牌号";
        [bottomView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbl.mas_bottom).offset(15);
            make.centerX.equalTo(bottomView);
            make.width.mas_equalTo(kScreenWidth - 80);
            make.height.mas_equalTo(45);
        }];
    }
    return _manualView;
}

@end
