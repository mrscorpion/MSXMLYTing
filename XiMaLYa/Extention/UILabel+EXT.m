//
//  UILabel+EXT.m
//  TestPch
//
//  Created by mr.scorpion on 16/7/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "UILabel+EXT.h"

@implementation UILabel (EXT)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary * dic = @{NSFontAttributeName:self.font};
    CGSize rectSize = [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return rectSize;
}
@end
