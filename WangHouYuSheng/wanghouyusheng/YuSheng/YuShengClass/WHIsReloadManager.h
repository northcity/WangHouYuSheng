//
//  WHIsReloadManager.h
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/25.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHIsReloadManager : NSObject

+(instancetype)shareInstance;

@property (nonatomic,assign)BOOL isreload;
@end

NS_ASSUME_NONNULL_END
