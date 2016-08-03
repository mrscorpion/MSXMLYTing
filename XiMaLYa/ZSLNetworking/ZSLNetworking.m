//
//  ZSLNetworking.m
//  图文混排
//
//  Created by mr.scorpion on 16/6/12.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "ZSLNetworking.h"

@implementation ZSLNetworking
{
    NSURLConnection * _connection;
    NSMutableData * _receiveData;
}
- (void)starRequest:(NSString *)urlString finishedBlcok:(finishedBlock)finished failedBlock:(failedBlock)failed{
    
    if (_finished != finished) {
        _finished = nil;
        _finished = finished;
    }
    if (_failed != failed) {
        _failed = nil;
        _failed = failed;
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            if (self.finished) {
                self.finished(data);
            }
        }
        if (error) {
            if (self.failed) {
                self.failed(error.localizedDescription);
            }
        }
    }];
    [dataTask resume];
}

@end
