//
//  TopSlideView.m
//  蝉游记_<项目>
//
//  Created by qianfeng on 15/6/12.
//  Copyright (c) 2015年 GZJ. All rights reserved.
//

#import "TopSlideView.h"

#define SELECT_COLOR [UIColor colorWithRed:78/255.0 green:159/255.0 blue:207/255.0 alpha:1]

@interface TopSlideView ()
@property (weak, nonatomic) IBOutlet UIButton *backBtnView;
@property (weak, nonatomic) IBOutlet UIButton *upBtnView;

- (IBAction)rightLabelClick:(UIButton *)sender;
- (IBAction)leftLabelClick:(UIButton *)sender;

@end

@implementation TopSlideView

- (instancetype)init
{
    if (self = [super init]){
        
        self = [[NSBundle mainBundle]loadNibNamed:@"TopSlideView" owner:nil options:nil].lastObject;
        
        self.backBtnView.layer.cornerRadius = 5;
        self.backBtnView.layer.borderWidth = 1;
        self.backBtnView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        
        self.upBtnView.layer.cornerRadius = 5;
        self.backBtnView.layer.borderWidth = 1;
        self.upBtnView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        
        [self.leftLabel setTitleColor:SELECT_COLOR forState:0];
        
        self.backBtnView.frame = CGRectMake(self.backBtnView.frame.origin.x, self.backBtnView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 16, self.backBtnView.frame.size.height);
        
        self.upBtnView.frame = CGRectMake(self.upBtnView.frame.origin.x, self.upBtnView.frame.origin.y, self.backBtnView.frame.size.width * 0.5, self.upBtnView.frame.size.height);
        
        self.leftLabel.frame = CGRectMake(self.backBtnView.frame.origin.x + 1, self.backBtnView.frame.origin.y + 1, self.backBtnView.frame.size.width * 0.5 - 1, self.backBtnView.frame.size.height - 2);
        
        self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.leftLabel.frame), self.backBtnView.frame.origin.y + 1, self.backBtnView.frame.size.width * 0.5 - 1, self.backBtnView.frame.size.height - 2);
        
        self.upBtnView.layer.borderWidth = 0.3;
        self.upBtnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    
    }
    return self;
}


- (IBAction)rightLabelClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(topSlideView:didChanged:)])
        [_delegate topSlideView:self didChanged:1];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.upBtnView.frame = sender.frame;
    }completion:^(BOOL finished) {
        [self.rightLabel setTitleColor:SELECT_COLOR forState:0];
        [self.leftLabel setTitleColor:[UIColor darkGrayColor] forState:0];
    }];

    
}

- (IBAction)leftLabelClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(topSlideView:didChanged:)])
        [_delegate topSlideView:self didChanged:0];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.upBtnView.frame = sender.frame;
    }completion:^(BOOL finished) {
        [self.leftLabel setTitleColor:SELECT_COLOR forState:0];
        [self.rightLabel setTitleColor:[UIColor darkGrayColor] forState:0];
    }];

}

- (void)slideToLeft
{
    [UIView animateWithDuration:0.35 animations:^{
        self.upBtnView.frame = self.leftLabel.frame;
    }completion:^(BOOL finished) {
        [self.leftLabel setTitleColor:SELECT_COLOR forState:0];
        [self.rightLabel setTitleColor:[UIColor darkGrayColor] forState:0];
    }];

}

- (void)slideToRight
{
    [UIView animateWithDuration:0.35 animations:^{
        self.upBtnView.frame = self.rightLabel.frame;
    }completion:^(BOOL finished) {
        [self.rightLabel setTitleColor:SELECT_COLOR forState:0];
        [self.leftLabel setTitleColor:[UIColor darkGrayColor] forState:0];
    }];
}

@end
