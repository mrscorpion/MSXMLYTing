//
//  UIColor+EXT.h
//  TestPch
//
//  Created by mr.scorpion on 16/7/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (EXT)
+ (UIColor *)mycolorWithString:(NSString *)color;

+ (UIColor *)mycolorWithString:(NSString *)color alpha:(CGFloat)alpha;
@end
