//
//  WSYSMainViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"
#import "YSMainTimeViewController.h"
#import "WSMainViewController.h"
#import "SecondViewController.h"

#import "WHNewViewController.h"

@interface WSYSMainViewController : YSBaseViewController

@property (nonatomic ,strong)WSMainViewController *wsVC;
@property (nonatomic ,strong)YSMainTimeViewController *ysVC;

@property (nonatomic, strong) SecondViewController *secondVC;


@property (nonatomic ,strong)WHNewViewController *whNewVc;

@end
