//
//  NCAlertView.h
//  NCAlertView
//
//  Created by 2345 on 2019/7/26.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NC_KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define NC_kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define NC_kAUTOHEIGHT(_hei)      ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO) ? _hei * 1 : _hei * ScreenHeight / 667.0)

/**
 *    @brief    颜色设置(UIColorFromRGB(0xffee00)).
 */
#define NC_PNCColorWithHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define NC_PNCColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NC_PNCColor(r,g,b) NC_PNCColorRGBA(r,g,b,1.0)
#define NC_PNCColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#ifndef PNCisIPHONEX
#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO))
#endif

#ifndef PNCisIPAD
#define PNCisIPAD  ([[UIDevice currentDevice].model isEqualToString:@"iPad"]? (YES):(NO))
#endif

//是否ios7编译环境
#define BuildWithIOS7Flag YES
#ifndef PNCisIOS7Later
#define PNCisIOS7Later  !([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)
#endif

#define NC_PCTopBarHeight                      ([UIScreen mainScreen].bounds.size.height >= 812.0f ?88.0f:((BuildWithIOS7Flag && PNCisIOS7Later) ?64.0f:44.0f))


#define Alert_Width NC_kAUTOWIDTH(260)
#define SuperVIPAlert_Width  ScreenWidth - NC_kAUTOWIDTH(40)

#define SuperVIPAlert_IPADWidth  ScreenWidth*2/3

typedef void(^SelDateBlock)(NSInteger fasongshijian);

@interface NCAlertView : UIView

@property (nonatomic, copy)dispatch_block_t woZhiDaoLeBlock;
@property (nonatomic, copy)dispatch_block_t guanBiBlock;
@property (nonatomic, copy)dispatch_block_t huFuBlock;
@property (nonatomic, copy)dispatch_block_t labelBlock;
@property (nonatomic, strong)UIButton *knowButton;
@property (nonatomic, strong)UIButton *huifuButton;
@property (nonatomic, strong)UIActivityIndicatorView *knowIndicator;
@property (nonatomic, strong)UIActivityIndicatorView *huFuIndicator;


@property (nonatomic, strong)UIButton *shibaButton;
@property (nonatomic, strong)UIButton *ershibaButton;
@property (nonatomic, strong)UIButton *sanshibaButton;
@property (nonatomic, strong)UIActivityIndicatorView *shibaknowIndicator;
@property (nonatomic, strong)UIActivityIndicatorView *ershiknowIndicator;
@property (nonatomic, strong)UIActivityIndicatorView *sanshiknowIndicator;
@property (nonatomic, copy)dispatch_block_t shibaBlock;
@property (nonatomic, copy)dispatch_block_t ershibaBlock;
@property (nonatomic, copy)dispatch_block_t sanshibaBlock;



- (void)showAlertViewWithTitle:(NSString *)titleString
                       content:(NSString *)contentString
                       redText:(NSString *)redText
                    knowButton:(NSString *)knowBtnText
                     imageName:(NSString *)imageName;

- (void)showDaiXXXAlertViewWithTitle:(NSString *)titleString
                             content:(NSString *)contentString
                             redText:(NSString *)redText
                          knowButton:(NSString *)knowBtnText
                           imageName:(NSString *)imageName;

- (void)showHuifuAlertViewWithTitle:(NSString *)titleString
                            content:(NSString *)contentString
                            redText:(NSString *)redText
                         knowButton:(NSString *)knowBtnText
                        huiFuButton:(NSString *)huFuBtnText
                          imageName:(NSString *)imageName;

- (void)showSuperVipAlertViewWithTitle:(NSString *)titleString
                               content:(NSString *)contentString
                               redText:(NSString *)redText
                            knowButton:(NSString *)knowBtnText
                           huiFuButton:(NSString *)huFuBtnText
                             imageName:(NSString *)imageName;


- (void)showThreeButtonDaiXXXAlertViewWithTitle:(NSString *)titleString
   content:(NSString *)contentString
   redText:(NSString *)redText
knowButton:(NSString *)knowBtnText
                                      imageName:(NSString *)imageName;


- (void)showXuanZeShiJianAlertWithImageName:(NSString *)imageName;
- (void)dismissAlertView;
- (void)showJuHua;
- (void)huiFuShowJuHua;
- (void)showSuperVipAlertView;


- (void)shibashowJuHua;
- (void)ershibashowJuHua;
- (void)sanshibashowJuHua;


@property (nonatomic, copy)SelDateBlock selDateBlock;
@end

