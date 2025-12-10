//
//  NCSuperVipAlertView.h
//  NCAlertView
//
//  Created by 2345 on 2019/7/30.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NCSuperVipAlertView : UIView

@property (nonatomic, copy)dispatch_block_t woZhiDaoLeBlock;
@property (nonatomic, copy)dispatch_block_t lookADBlock;
@property (nonatomic, copy)dispatch_block_t guanBiBlock;
@property (nonatomic, copy)dispatch_block_t huiYuanNianBlock;

@property (nonatomic, copy)dispatch_block_t huFuBlock;
@property (nonatomic, strong)UIButton *knowButton;
@property (nonatomic, strong)UIButton *knowNianButton;

@property (nonatomic, strong)UIButton *LookADBtn;


@property (nonatomic, strong)UIButton *huifuButton;
@property (nonatomic, strong)UIActivityIndicatorView *knowIndicator;
@property (nonatomic, strong)UIActivityIndicatorView *huFuIndicator;

@property (nonatomic, strong)UIActivityIndicatorView *knowNianIndicator;


@property (nonatomic, copy)dispatch_block_t openYinSiZhengCeBlock;
@property (nonatomic, copy)dispatch_block_t openFuWuXieYiBlock;


- (void)showSuperVipAlertViewWithTitle:(NSString *)titleString
    content:(NSString *)contentString
    redText:(NSString *)redText
 knowButton:(NSString *)knowBtnText
huiFuButton:(NSString *)huFuBtnText
                             imageName:(NSString *)imageName;

- (void)dismissAlertView;
@end


NS_ASSUME_NONNULL_END
