//
//  NewSecondViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/8.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"

@interface NewSecondViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;//点击第几张
@property (nonatomic, strong) UIImageView *topImageView;//顶部图片
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, copy) NSString *pushFlag;

@end
