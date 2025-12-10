//
//  SecondViewController.h
//  CardTransitionDemo
//
//  Created by hztuen on 2017/6/9.
//  Copyright © 2017年 cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)(NSInteger index);

@interface SecondViewController : UIViewController 

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;//点击第几张
@property (nonatomic, strong) UIImageView *topImageView;//顶部图片
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, copy) NSString *pushFlag;

@property (nonatomic, copy)backBlock backBlock;
@end
