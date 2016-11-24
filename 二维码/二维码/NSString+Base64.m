//
//  NSString+Base64.m
//  Base64_Demo
//
//  Created by use on 16/6/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "NSString+Base64.h"
#import <objc/runtime.h>

static NSString *strKey = @"weijinpeng";

@implementation NSString (Base64)

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)setBaseStr:(NSString *)baseStr
{
    if (baseStr == nil) {
        baseStr = @"wwwwwjjjjppp";
    }
    objc_setAssociatedObject(self, &strKey, baseStr, OBJC_ASSOCIATION_COPY);
}

- (NSString *)baseStr
{
    return objc_getAssociatedObject(self, &strKey);
}

@end
