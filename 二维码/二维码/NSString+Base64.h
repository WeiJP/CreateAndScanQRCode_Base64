//
//  NSString+Base64.h
//  Base64_Demo
//
//  Created by use on 16/6/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

@property (nonatomic, copy) NSString *baseStr;

- (NSString *)base64EncodedString;

- (NSString *)base64DecodedString;

@end
