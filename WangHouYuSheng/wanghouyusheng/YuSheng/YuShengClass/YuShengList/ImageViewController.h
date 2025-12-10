//
//  ImageViewController.h
//  shijianjiaonang
//
//  Created by 北城 on 2018/8/9.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"

@interface ImageViewController : UIViewController

@property (nonatomic, strong)LZDataModel *model;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;
@end
