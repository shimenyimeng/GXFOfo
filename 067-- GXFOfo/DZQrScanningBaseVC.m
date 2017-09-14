//
//  DZQrScanningBaseVC.m
//  Dazui
//
//  Created by Mr_朱 on 2017/4/13.
//  Copyright © 2017年 you. All rights reserved.
//

#import "DZQrScanningBaseVC.h"
#import <AVFoundation/AVFoundation.h>
#import "DZQrScanningBaseView.h"


@interface DZQrScanningBaseVC () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DZQrScanningBaseViewDelegate>
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation DZQrScanningBaseVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"DZQrScanningBaseVC - dealloc");
    [self removeScanningView];
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}
-(void)backTap{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)albumButtonClick {
    
    UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        pickerVc.delegate = self;
        pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerVc animated:YES completion:nil];
        [pickerVc.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    }
}

-(void) createBackBtn{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setFrame:CGRectMake(0, 0, 0, 0)];
    [back setImage:[UIImage imageNamed:@"backNew"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"backNew"] forState:UIControlStateHighlighted];
    [back sizeToFit];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    [back addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchUpInside];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBackBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(albumButtonClick)];
    self.title = @"扫一扫";
    [self.view addSubview:self.scanningView];
    [self setupSGQRCodeScanning];
    self.scanningView.delegate = self;
}
- (DZQrScanningBaseView *)scanningView {
    if (!_scanningView) {
        _scanningView = [DZQrScanningBaseView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}
- (void)setupSGQRCodeScanning {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    self.session = [[AVCaptureSession alloc] init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    
    [_session addOutput:output];
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    [_session startRunning];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self playSound:@"sound.caf"];
    
    [self.session stopRunning];
    
    [self.previewLayer removeFromSuperlayer];
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        [QRCodeNotificationCenter postNotificationName:QRCodeInformationFromeScanning object:obj.stringValue];
    }
}

//播放音效文件
- (void)playSound:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(soundID);
}
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //声音播放完成
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DZQrScanningBaseViewDelegate
- (void)qrScanningBaseView:(DZQrScanningBaseView *)scanningBaseView closeBtnClick:(UIButton *)closeBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)qrScanningBaseView:(DZQrScanningBaseView *)scanningBaseView manualBtnClcik:(UIButton *)manualBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(qrScanningBaseVC:manualInputBtnClick:)]) {
        [self.delegate qrScanningBaseVC:self manualInputBtnClick:nil];
    }
}

//+ (NSString *)QRCodeContentWithQRCodeImage:(NSImage *)qrCodeImage
//{
//    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
//    NSData *data = [qrCodeImage TIFFRepresentation];
//    CIImage * ciimage = [CIImage imageWithData:[qrCodeImage TIFFRepresentation]];
//    NSArray * features = [detector featuresInImage:ciimage];
//    for (CIFeature * feature in features) {
//        if ([[feature type] isEqualToString:CIFeatureTypeQRCode]) {
//            return [(CIQRCodeFeature *)feature messageString];
//        }
//    }
//    return @"Get content failed.";
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
