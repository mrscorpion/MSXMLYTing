//
//  NSObject+EXT.m
//  TestPch
//
//  Created by mr.scorpion on 16/7/13.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import "NSObject+EXT.h"
#import <objc/runtime.h>

@implementation NSObject (EXT)
+ (id)myModelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([model class], &count);
    
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char * propertyName = property_getName(property);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        
        id value = nil;
        
        if ([key isEqualToString:@"Id"]) {
            if (![dic[key] isKindOfClass:[NSNull class]]) {
                value = dic[@"id"];
            }
        }else{
            if (![dic[key] isKindOfClass:[NSNull class]]) {
                value = dic[key];
            }
        }
        
        
        
        [model setValue:value forKey:key];
        
    }
    return model;
}

@end
