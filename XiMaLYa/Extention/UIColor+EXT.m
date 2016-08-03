//
//  UIColor+EXT.m
//  TestPch
//
//  Created by mr.scorpion on 16/7/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "UIColor+EXT.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@implementation UIColor (EXT)
+ (UIColor *)mycolorWithString:(NSString *)color alpha:(CGFloat)alpha{
    
    
    //去除空格，并大写
    NSString * cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //判断是不是6位，前两位R，中间两位G，最后两位B
    
    if ([cString length]<6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.length = 2;
    
    //前两位
    range.location = 0;
    NSString * rString = [cString substringWithRange:range];
    
    //中两位
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    //后两位
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    //转换
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return RGBA_COLOR((float)r, (float)g, (float)b, alpha);
    
    //return [UIColor colorWithRed:((float)r /255.0f) green:((float)g /255.0f) blue:((float)b /255.0f) alpha:alpha];
    
}
+ (UIColor *)mycolorWithString:(NSString *)color{
    return [UIColor mycolorWithString:color alpha:1.0f];
}

@end
