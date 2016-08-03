//
//  NSString+EXT.m
//  TestPch
//
//  Created by mr.scorpion on 16/7/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "NSString+EXT.h"

@implementation NSString (EXT)
- (CGSize)myBoundingRectWithSize:(CGSize)size withFontSize:(CGFloat)fontSize{
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize rectSize = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return rectSize;
    
}
@end
