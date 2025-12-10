//
//  AboutMeViewController.h
//  shoudiantong
//
//  Created by chenxi on 2018/3/7.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCSuperVipAlertView.h"

typedef void(^BuySuccessBlock)(BOOL isSuccess);


@interface SettingViewController : UIViewController
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *bgViews;
@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong) UIImageView *smartImage;
@property(nonatomic,strong) UIImageView *blurImageView;


@property (nonatomic, strong) NCSuperVipAlertView *ncview;
@property (nonatomic,copy)NSString *kaiguanFlag;

@property (nonatomic,copy)BuySuccessBlock buySuccessBlock;

@property (nonatomic,copy)NSString *nowLookADType;

- (void)initNeiGouView3;
@end
