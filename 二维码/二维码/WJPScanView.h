//
//  WJPScanView.h
//  二维码
//
//  Created by use on 16/6/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPScanView : UIView

@property (nonatomic, assign) CGFloat scanViewWidth;
@property (nonatomic, assign) CGFloat scanViewHeight;
/**
 *  以屏幕中心为基准，>0 上移
 */
@property (nonatomic, assign) CGFloat upOffset;

@property (nonatomic, strong) UIColor *outBackgroudColor;

- (void)startAnimation;
- (void)stopAnimation;

@end
