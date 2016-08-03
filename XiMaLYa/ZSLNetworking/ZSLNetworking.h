//
//  ZSLNetworking.h
//  图文混排
//
//  Created by mr.scorpion on 16/6/12.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^finishedBlock) (NSData * data);
typedef void (^failedBlock) (NSString * errorMessage);


@interface ZSLNetworking : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic,copy)finishedBlock finished;
@property (nonatomic,copy)failedBlock failed;
- (void)starRequest:(NSString *)urlString finishedBlcok:(finishedBlock)finished failedBlock:(failedBlock)failed;
@end
