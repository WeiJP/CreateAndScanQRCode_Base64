//
//  ViewController.m
//  二维码
//
//  Created by use on 16/6/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WJPScanView.h"
#import "CreateQRCodeController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL isScanStop;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, weak) WJPScanView *scanView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startScan:(id)sender {
    if (_scanView == nil) {
        WJPScanView *scanView = [[WJPScanView alloc] init];
        _scanView = scanView;
        scanView.scanViewWidth = ScreenWidth - 100;
        scanView.scanViewHeight = ScreenWidth - 100;
        scanView.upOffset = 60;
        [self.view addSubview:scanView];
    }
    [_scanView startAnimation];
    [self requestScan];
}

- (IBAction)createQRCode:(UIButton *)sender {
    CreateQRCodeController *cqrcVC = [[CreateQRCodeController alloc] init];
    [self presentViewController:cqrcVC animated:YES completion:^{
        
    }];
}

- (void)requestScan
{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [self startScan];
                } else {
                    NSLog(@"%@", @"访问受限");
                }
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized: {
            [self startScan];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            NSLog(@"%@", @"访问受限");
            break;
        }
            
        default: {
            break;
        }
    }
}

- (void)startScan
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (deviceInput) {
        [session addInput:deviceInput];
        
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [session addOutput:metadataOutput]; // 这行代码要在设置 metadataObjectTypes 前
        metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.frame;
        [self.view.layer insertSublayer:_previewLayer atIndex:0];
        
        [session startRunning];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode] && !self.isScanStop) { // 成功后系统不会停止扫描，可以用一个变量来控制。
        self.isScanStop = YES;
        
        NSLog(@"%@", metadataObject.stringValue);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue currentQueue]
//                                                  usingBlock: ^(NSNotification *_Nonnull note) {
//                                                      _metadataOutput.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:CGRectMake(80, 80, 160, 160)];
//                                                  }];
}

- (void)viewWillAppear:(BOOL)animated
{
    _isScanStop = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
