//
//  TopSlideView.h
//  蝉游记_<项目>
//
//  Created by qianfeng on 15/6/12.
//  Copyright (c) 2015年 GZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopSlideView;

@protocol TopSlideViewDelegate <NSObject>

@optional
- (void)topSlideView:(TopSlideView *)topSlide didChanged:(NSUInteger)index;

@end

@interface TopSlideView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightLabel;

- (void)slideToLeft;

- (void)slideToRight;

@property (nonatomic,assign)id<TopSlideViewDelegate> delegate;

@end
