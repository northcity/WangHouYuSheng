//
//  WHBianJiViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2020/2/8.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"
#import "LZDataModel.h"
#import "LoopBannerView.h"
#import "LoopBannerPage.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^backImage)(UIImage *selImage);
typedef void(^backModel)(NSString *titleString, NSString *contentString,NSString *timeString, NSString *loacaString);


@interface WHBianJiViewController : YSBaseViewController<SDCycleScrollViewDelegate>
@property (nonatomic, strong)LZDataModel *model;
//@property (nonatomic ,strong)UIImageView *headerImageView;

@property (nonatomic ,strong) SDCycleScrollView *headerImageView;

@property (nonatomic ,strong) UIImageView *locationImage;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (strong, nonatomic) UIImage *bgImage;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *localLabel;


@property (nonatomic, copy)backImage backImageBlock;
@property (nonatomic, copy)backModel backModelBlock;

@property (nonatomic, copy)NSString *pushFlag;
@property (nonatomic, copy)NSString *createFlag;

@end

NS_ASSUME_NONNULL_END
