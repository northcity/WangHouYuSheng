//
//  WHYSManager.h
//  wanghouyusheng
//
//  Created by dev2 better on 2021/9/3.
//  Copyright © 2021 com.beicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHYSManager : NSObject
+ (NSString *)getCurrentTimeToHaoMiao;
+ (NSString *)getCurrentTimeToSecond;

+ (void)addLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body timeInterval:(long)timeInterval identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo repeats:(int)repeats;
+ (void)removeNotificationWithIdentifierID:(NSString *)noticeId;
@end

NS_ASSUME_NONNULL_END
