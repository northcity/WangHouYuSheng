//
//  WHIsReloadManager.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/25.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHIsReloadManager.h"

static WHIsReloadManager *_singleInstance = nil;

@implementation WHIsReloadManager

-(instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isreload = NO;
    });
    return _singleInstance;
}
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleInstance == nil) {
            _singleInstance = [[self alloc]init];
        }
    });
    return _singleInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [super allocWithZone:zone];
    });
    return _singleInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _singleInstance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _singleInstance;
}

@end
