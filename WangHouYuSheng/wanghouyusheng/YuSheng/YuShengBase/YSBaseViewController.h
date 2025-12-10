//
//  YSBaseViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQShineLabel.h"

@interface YSBaseViewController : UIViewController
@property(nonatomic,strong)RQShineLabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *rightBtn;

- (void)initOtherUI;
@end
