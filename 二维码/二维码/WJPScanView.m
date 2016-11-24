//
//  WJPScanView.m
//  二维码
//
//  Created by use on 16/6/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPScanView.h"

@interface WJPScanView ()

@property (strong, nonatomic) CAShapeLayer *jp_upLayer;
@property (strong, nonatomic) CAShapeLayer *jp_leftLayer;
@property (strong, nonatomic) CAShapeLayer *jp_rightLayer;
@property (strong, nonatomic) CAShapeLayer *jp_downLayer;

@property (nonatomic, weak) UIImageView *aniImageView;
@property (nonatomic) CGRect originFrame;

@end

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation WJPScanView

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self initViewConfig];
    [self.layer addSublayer:self.jp_upLayer];
    [self.layer addSublayer:self.jp_leftLayer];
    [self.layer addSublayer:self.jp_rightLayer];
    [self.layer addSublayer:self.jp_downLayer];
}

- (void)initViewConfig
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake((ScreenWidth - _scanViewWidth)*0.5, (ScreenHeight - _scanViewHeight)*0.5 - _upOffset, _scanViewWidth, _scanViewHeight);
    [self addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.frame = CGRectMake((ScreenWidth - _scanViewWidth)*0.5, (ScreenHeight - _scanViewHeight)*0.5 - _upOffset - _scanViewHeight, _scanViewWidth, _scanViewHeight);
    imageView.frame = CGRectMake(0, -_scanViewHeight, _scanViewWidth, _scanViewHeight);
    imageView.image = [UIImage imageNamed:@"qrcode_scan_full_net"];
    imageView.alpha = 0.2f;
//    [self addSubview:imageView];
    [view addSubview:imageView];
    _aniImageView = imageView;
    _originFrame = _aniImageView.frame;
}

- (void)startAnimation
{
    _aniImageView.alpha = 0.2f;
    _aniImageView.frame = _originFrame;
    
    typeof(self) weakself = self;
    [UIView animateWithDuration:1.5f animations:^{
        _aniImageView.alpha = 1.0f;
        CGRect finalFrame = _originFrame;
//        finalFrame.origin.y = (ScreenHeight - _scanViewHeight)*0.5 - _upOffset;
        finalFrame.origin.y = 0;
        _aniImageView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [weakself performSelector:@selector(startAnimation) withObject:nil afterDelay:0.3];
    }];
}

- (CAShapeLayer *)jp_upLayer
{
    if (!_jp_upLayer) {
        _jp_upLayer = [CAShapeLayer layer];
        CGRect frame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight - _scanViewHeight)*0.5 - _upOffset);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        _jp_upLayer.path = path.CGPath;
        _jp_upLayer.fillColor = [self outBackgroudColor].CGColor;
    }
    return _jp_upLayer;
}

- (CAShapeLayer *)jp_leftLayer
{
    if (!_jp_leftLayer) {
        _jp_leftLayer = [CAShapeLayer layer];
        CGRect frame = CGRectMake(0, (ScreenHeight - _scanViewHeight)*0.5 - _upOffset, (ScreenWidth - _scanViewWidth)*0.5, _scanViewHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        _jp_leftLayer.path = path.CGPath;
        _jp_leftLayer.fillColor = [self outBackgroudColor].CGColor;
    }
    return _jp_leftLayer;
}

- (CAShapeLayer *)jp_rightLayer
{
    if (!_jp_rightLayer) {
        _jp_rightLayer = [CAShapeLayer layer];
        CGRect frame = CGRectMake((ScreenWidth - _scanViewWidth)*0.5+_scanViewWidth, (ScreenHeight - _scanViewHeight)*0.5 - _upOffset, (ScreenWidth - _scanViewWidth)*0.5, _scanViewHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        _jp_rightLayer.path = path.CGPath;
        _jp_rightLayer.fillColor = [self outBackgroudColor].CGColor;
    }
    return _jp_rightLayer;
}

- (CAShapeLayer *)jp_downLayer
{
    if (!_jp_downLayer) {
        _jp_downLayer = [CAShapeLayer layer];
        CGRect frame = CGRectMake(0, (ScreenHeight - _scanViewHeight)*0.5+_scanViewHeight - _upOffset, ScreenWidth, (ScreenHeight - _scanViewHeight)*0.5 + _upOffset);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        _jp_downLayer.path = path.CGPath;
        _jp_downLayer.fillColor = [self outBackgroudColor].CGColor;
    }
    return _jp_downLayer;
}

- (UIColor *)outBackgroudColor
{
    if (_outBackgroudColor == nil) {
        UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        _outBackgroudColor = color;
    }
    return _outBackgroudColor;
}

- (void)stopAnimation
{
    _aniImageView.hidden = YES;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end
