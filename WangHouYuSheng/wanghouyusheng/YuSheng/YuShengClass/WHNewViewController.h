//
//  WHNewViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2020/2/7.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"
#import "LZDataModel.h"
#import "iCarousel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHNewViewController : YSBaseViewController

@property (nonatomic, strong)iCarousel *myCarousel;
@property (nonatomic,strong) CALayer * subLayer;

@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *qieHuanButton;

@property (nonatomic,assign)BOOL isCollection;


- (void)loadDate;

@end

NS_ASSUME_NONNULL_END
