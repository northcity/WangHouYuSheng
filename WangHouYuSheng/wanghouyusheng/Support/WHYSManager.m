//
//  WHYSManager.m
//  wanghouyusheng
//
//  Created by dev2 better on 2021/9/3.
//  Copyright © 2021 com.beicheng. All rights reserved.
//

#import "WHYSManager.h"

@implementation WHYSManager
+ (NSString *)getCurrentTimeToHaoMiao{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)getCurrentTimeToSecond{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/** 添加本地推送通知*/
+ (void)addLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body timeInterval:(long)timeInterval identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo repeats:(int)repeats
{
    if (title.length == 0 || body.length == 0 || identifier.length == 0) {
        return;
    }
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        if (title.length) {
            content.title = title;
        }
        if (subTitle.length) {
            content.subtitle = subTitle;
        }
        // 内容
        if (body.length) {
            content.body = body;
        }
        if (userInfo != nil) {
            content.userInfo = userInfo;
        }
        // 声音
        // 默认声音
        content.sound = [UNNotificationSound defaultSound];
        // 添加自定义声音
        //content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
        // 角标 （我这里测试的角标无效，暂时没找到原因）
        content.badge = @1;
        // 多少秒后发送,可以将固定的日期转化为时间
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:timeInterval] timeIntervalSinceNow];
        UNNotificationTrigger *trigger = nil;
        // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
        if (repeats > 0 && repeats < 7) {
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
            // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            // 获取不同时间字段的信息
            NSDateComponents* comp = [gregorian components:unitFlags fromDate:date];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.second = comp.second;
            if (repeats == 6) {
                //每分钟循环
            } else if (repeats == 5) {
                //每小时循环
                components.minute = comp.minute;
            } else if (repeats == 4) {
                //每天循环
                components.minute = comp.minute;
                components.hour = comp.hour;
            } else if (repeats == 3) {
                //每周循环
                components.minute = comp.minute;
                components.hour = comp.hour;
                components.weekday = comp.weekday;
            } else if (repeats == 2) {
                //每月循环
                components.minute = comp.minute;
                components.hour = comp.hour;
                components.day = comp.day;
                components.month = comp.month;
            } else if (repeats == 1) {
                //每年循环
                components.minute = comp.minute;
                components.hour = comp.hour;
                components.day = comp.day;
                components.month = comp.month;
                components.year = comp.year;
            }
            trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        } else {
            //不循环
            trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        }
        // 添加通知的标识符，可以用于移除，更新等操作 identifier
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"ECKPushSDK log:添加本地推送成功");
        }];
    } else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 发出推送的日期
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
        if (title.length > 0) {
            notif.alertTitle = title;
        }
        // 推送的内容
        if (body.length > 0) {
            notif.alertBody = body;
        }
        if (userInfo != nil) {
            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            [mdict setObject:identifier forKey:@"identifier"];
            notif.userInfo = mdict;
        } else {
            // 可以添加特定信息
            notif.userInfo = @{@"identifier":identifier};
        }
        // 角标
        notif.applicationIconBadgeNumber = 1;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        // 循环提醒
        if (repeats == 6) {
            //每分钟循环
            notif.repeatInterval = NSCalendarUnitMinute;
        } else if (repeats == 5) {
            //每小时循环
            notif.repeatInterval = NSCalendarUnitHour;
        } else if (repeats == 4) {
            //每天循环
            notif.repeatInterval = NSCalendarUnitDay;
        } else if (repeats == 3) {
            //每周循环
            notif.repeatInterval = NSCalendarUnitWeekday;
        } else if (repeats == 2) {
            //每月循环
            notif.repeatInterval = NSCalendarUnitMonth;
        } else if (repeats == 1) {
            //每年循环
            notif.repeatInterval = NSCalendarUnitYear;
        } else {
            //不循环
        }
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}


/** 移除某一个指定的通知*/
+ (void)removeNotificationWithIdentifierID:(NSString *)noticeId
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests){
                NSLog(@"ECKPushSDK log: 当前存在的本地通知identifier: %@\n", req.identifier);
            }
        }];
        [center removePendingNotificationRequestsWithIdentifiers:@[noticeId]];
    } else {
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in array){
            NSDictionary *userInfo = localNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"identifier"];
            if ([obj isEqualToString:noticeId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

/** 移除所有通知*/
+ (void)removeAllNotification
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

@end
