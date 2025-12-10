//
//  AppDelegate.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) MFSideMenuContainerViewController *sideMenu;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

