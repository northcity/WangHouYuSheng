//
//  NCAlertView.m
//  NCAlertView
//
//  Created by 2345 on 2019/7/26.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import "NCAlertView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NC_KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define NC_kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define NC_kAUTOHEIGHT(_hei)      ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO) ? _hei * 1 : _hei * ScreenHeight / 667.0)
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
#define SuperVIPAlert_Width ScreenWidth - NC_kAUTOWIDTH(40)


@interface NCAlertView ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIBlurEffect *effectT;
@property (nonatomic, strong)UIVisualEffectView *effectViewT;
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)CALayer *subLayer;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIWindow *window;
@property (nonatomic, strong)UIButton *guanBiButton;
@property (nonatomic, strong)UIImageView * iconImageView;

@property (nonatomic, strong)NSArray * buttonArr;



@end

@implementation NCAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{

    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.alpha = 0.6;
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];

    
    if (@available(iOS 13.0, *)) {
        _effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
    } else {
        _effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }    _effectViewT = [[UIVisualEffectView alloc] initWithEffect:_effectT];
    _effectViewT.frame = _bgView.frame;
    _effectViewT.alpha = 1.f;
    _effectViewT.userInteractionEnabled = YES;
    [self addSubview:_effectViewT];

    _alertView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, NC_kAUTOWIDTH(180))];
    if (@available(iOS 13.0, *)) {
        _alertView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    _alertView.layer.cornerRadius = NC_kAUTOWIDTH(7);
    _alertView.center = self.window.center;
    _alertView.userInteractionEnabled = YES;
    [self addSubview:_alertView];

    _subLayer=[CALayer layer];
    CGRect fixframe = CGRectZero;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = NC_kAUTOWIDTH(10);
    _subLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds = NO;
    _subLayer.shadowColor = [UIColor grayColor].CGColor;
    _subLayer.shadowOffset = CGSizeMake(0,0);
    _subLayer.shadowOpacity = 0.2f;
    _subLayer.shadowRadius = 10;
    _subLayer.hidden = YES;
    [self.layer insertSublayer:_subLayer below:self.alertView.layer];


    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(20), NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(40))];
    _iconImageView.backgroundColor = [UIColor clearColor];
    [_alertView addSubview:_iconImageView];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), CGRectGetMaxY(_iconImageView.frame) + NC_kAUTOWIDTH(5), Alert_Width - NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(30))];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(16)]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"我是标题";
    
    if (@available(iOS 13.0, *)) {
           self.titleLabel.textColor = [UIColor labelColor];
       } else {
           self.titleLabel.textColor = [UIColor blackColor];
       }
    [_alertView addSubview:self.titleLabel];

    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(5), Alert_Width - NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(30))];
    [self.contentLabel setFont:[UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(13)]];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"我是标题";
    if (@available(iOS 13.0, *)) {
        self.contentLabel.textColor = [UIColor labelColor];
    } else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
    [_alertView addSubview:self.contentLabel];

    self.knowButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40))];
    self.knowButton.backgroundColor = [UIColor clearColor];
    [self.knowButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.knowButton setTitle:NSLocalizedString(@"立即体验" , nil) forState:UIControlStateNormal];
    self.knowButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(16)];
//    [self.knowButton addTarget:self action:@selector(writeAPaper) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.knowButton];

}

- (void)showAlertViewWithTitle:(NSString *)titleString
                       content:(NSString *)contentString
                       redText:(NSString *)redText
                    knowButton:(NSString *)knowBtnText
                     imageName:(NSString *)imageName{
    
    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];
    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",imageName]];

    self.titleLabel.text = titleString;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(14)];
    UIFont *normalFont = [UIFont fontWithName:@"HeiTi SC" size:NC_kAUTOWIDTH(14)];
    NSRange range = [contentString rangeOfString:redText];
    [attrString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, contentString.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(range.location, range.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    self.contentLabel.attributedText = attrString;
    [self.contentLabel sizeToFit];

    CGFloat contentW = self.contentLabel.frame.size.width;
    CGFloat contentH = self.contentLabel.frame.size.height;

    self.contentLabel.frame = CGRectMake(Alert_Width/2 - contentW/2, CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(5), contentW, contentH);
    CGFloat AlertH = NC_kAUTOWIDTH(55) + NC_kAUTOWIDTH(35) + self.contentLabel.frame.size.height + NC_kAUTOWIDTH(50);
    self.alertView.frame = CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, AlertH);
    self.alertView.center =  self.window.center;

    _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         CGRect fixframe =_alertView.layer.frame;
                         _subLayer.frame = fixframe;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             _subLayer.hidden = NO;
                         });
                         
                     }];

    self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)showDaiXXXAlertViewWithTitle:(NSString *)titleString
                       content:(NSString *)contentString
                       redText:(NSString *)redText
                    knowButton:(NSString *)knowBtnText
                           imageName:(NSString *)imageName{
    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];

    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",imageName]];
    self.titleLabel.text = titleString;

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(14)];
    UIFont *normalFont = [UIFont fontWithName:@"HeiTi SC" size:NC_kAUTOWIDTH(14)];
    NSRange range = [contentString rangeOfString:redText];
    [attrString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, contentString.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(range.location, range.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    self.contentLabel.attributedText = attrString;
    [self.contentLabel sizeToFit];

    CGFloat contentW = self.contentLabel.frame.size.width;
    CGFloat contentH = self.contentLabel.frame.size.height;

    self.contentLabel.frame = CGRectMake(Alert_Width/2 - contentW/2, CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(5), contentW, contentH);
    CGFloat AlertH = NC_kAUTOWIDTH(55) + NC_kAUTOWIDTH(35) + self.contentLabel.frame.size.height + NC_kAUTOWIDTH(50);
    self.alertView.frame = CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, AlertH);
    self.alertView.center =  self.window.center;

    _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         CGRect fixframe =_alertView.layer.frame;
                         _subLayer.frame = fixframe;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             _subLayer.hidden = NO;
                         });

                     }];

    self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(50)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.knowButton addSubview:_knowIndicator];

    self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
    UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
    [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
    self.guanBiButton.backgroundColor = [UIColor clearColor];
    [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.guanBiButton];
}






- (void)showThreeButtonDaiXXXAlertViewWithTitle:(NSString *)titleString
                       content:(NSString *)contentString
                       redText:(NSString *)redText
                    knowButton:(NSString *)knowBtnText
                           imageName:(NSString *)imageName{
    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];

    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",imageName]];
    self.titleLabel.text = titleString;

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(14)];
    UIFont *normalFont = [UIFont fontWithName:@"HeiTi SC" size:NC_kAUTOWIDTH(14)];
    NSRange range = [contentString rangeOfString:redText];
    [attrString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, contentString.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(range.location, range.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    self.contentLabel.attributedText = attrString;
    [self.contentLabel sizeToFit];

    CGFloat contentW = self.contentLabel.frame.size.width;
    CGFloat contentH = self.contentLabel.frame.size.height;

    self.contentLabel.frame = CGRectMake(Alert_Width/2 - contentW/2, CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(5), contentW, contentH);
    CGFloat AlertH = NC_kAUTOWIDTH(55) + NC_kAUTOWIDTH(35) + self.contentLabel.frame.size.height + NC_kAUTOWIDTH(50) + NC_kAUTOWIDTH(70);
    self.alertView.frame = CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, AlertH);
    self.alertView.center =  self.window.center;

    _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         CGRect fixframe =_alertView.layer.frame;
                         _subLayer.frame = fixframe;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             _subLayer.hidden = NO;
                         });

                     }];

    
     self.shibaButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(60),NC_kAUTOWIDTH(25))];
        self.shibaButton.backgroundColor = [UIColor clearColor];
        [self.shibaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.shibaButton setTitle:NSLocalizedString(@"立即体验" , nil) forState:UIControlStateNormal];
        self.shibaButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(11)];
        [_alertView addSubview:self.shibaButton];
    
    self.shibaButton.layer.borderColor = [UIColor redColor].CGColor;
    self.shibaButton.layer.borderWidth = 0.5;
    self.shibaButton.layer.cornerRadius = NC_kAUTOWIDTH(3);
    self.shibaButton.layer.masksToBounds = YES;
    
    
    self.ershibaButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(12), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30))];
        self.ershibaButton.backgroundColor = [UIColor clearColor];
        [self.ershibaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.ershibaButton setTitle:NSLocalizedString(@"立即体验" , nil) forState:UIControlStateNormal];
        self.ershibaButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(11)];
        [_alertView addSubview:self.ershibaButton];
    
    self.ershibaButton.layer.borderColor = [UIColor redColor].CGColor;
     self.ershibaButton.layer.borderWidth = 0.5;
     self.ershibaButton.layer.cornerRadius = NC_kAUTOWIDTH(3);
     self.ershibaButton.layer.masksToBounds = YES;
     
    
    self.sanshibaButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30))];
           self.sanshibaButton.backgroundColor = [UIColor clearColor];
           [self.sanshibaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
           [self.sanshibaButton setTitle:NSLocalizedString(@"立即体验" , nil) forState:UIControlStateNormal];
           self.sanshibaButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(11)];
           [_alertView addSubview:self.sanshibaButton];
       
    self.sanshibaButton.layer.borderColor = [UIColor redColor].CGColor;
     self.sanshibaButton.layer.borderWidth = 0.5;
     self.sanshibaButton.layer.cornerRadius = NC_kAUTOWIDTH(3);
     self.sanshibaButton.layer.masksToBounds = YES;
     

    self.knowButton.hidden = YES;
    
     
    self.shibaButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(8), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(25));
    self.ershibaButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMaxY(self.shibaButton.frame) + NC_kAUTOWIDTH(8), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(25));
    
    self.sanshibaButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(40), CGRectGetMaxY(self.ershibaButton.frame) + NC_kAUTOWIDTH(8), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(25));
    
    [self.shibaButton setTitle:NSLocalizedString(@"普通款 ￥12" , nil) forState:UIControlStateNormal];

    [self.ershibaButton setTitle:NSLocalizedString(@"升级款 ￥28" , nil) forState:UIControlStateNormal];
    
    [self.sanshibaButton setTitle:NSLocalizedString(@"尊享款 ￥40" , nil) forState:UIControlStateNormal];
    
    
    [self.shibaButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.ershibaButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.sanshibaButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    
    
    _shibaknowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(40)- NC_kAUTOWIDTH(12.5),0,NC_kAUTOWIDTH(25),NC_kAUTOWIDTH(25))];
       _shibaknowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
       [self.shibaButton addSubview:_shibaknowIndicator];
    
    _ershiknowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(40)- NC_kAUTOWIDTH(12.5),0,NC_kAUTOWIDTH(25),NC_kAUTOWIDTH(25))];
          _ershiknowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
          [self.ershibaButton addSubview:_ershiknowIndicator];
    
    
    _sanshiknowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(40)- NC_kAUTOWIDTH(12.5),0,NC_kAUTOWIDTH(25),NC_kAUTOWIDTH(25))];
           _sanshiknowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
           [self.sanshibaButton addSubview:_sanshiknowIndicator];
     
    
    [self.shibaButton addTarget:self action:@selector(shibaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ershibaButton addTarget:self action:@selector(ershibaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sanshibaButton addTarget:self action:@selector(sanshibaBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    
//    self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
//    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
//    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(80)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
//    [self.knowButton addSubview:_knowIndicator];

    self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
    UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
    [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
    self.guanBiButton.backgroundColor = [UIColor clearColor];
    [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.guanBiButton];
    
}


- (void)shibashowJuHua{
    [self.shibaButton setTitle:@"" forState:UIControlStateNormal];
    [_shibaknowIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)ershibashowJuHua{
    [self.ershibaButton setTitle:@"" forState:UIControlStateNormal];
    [_ershiknowIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)sanshibashowJuHua{
    [self.sanshibaButton setTitle:@"" forState:UIControlStateNormal];
    [_sanshiknowIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)shibaBtnClick{
    if (self.shibaBlock) {
        self.shibaBlock();
    }
}

- (void)ershibaBtnClick{
    if (self.ershibaBlock) {
        self.ershibaBlock();
    }
}

- (void)sanshibaBtnClick{
    if (self.sanshibaBlock) {
        self.sanshibaBlock();
    }
}




























- (void)showHuifuAlertViewWithTitle:(NSString *)titleString
                             content:(NSString *)contentString
                             redText:(NSString *)redText
                         knowButton:(NSString *)knowBtnText
                        huiFuButton:(NSString *)huFuBtnText
                            imageName:(NSString *)imageName{

    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];

    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",imageName]];
    self.titleLabel.text = titleString;

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(14)];
    UIFont *normalFont = [UIFont fontWithName:@"HeiTi SC" size:NC_kAUTOWIDTH(14)];
    NSRange range = [contentString rangeOfString:redText];
    [attrString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, contentString.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(range.location, range.length)];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    self.contentLabel.attributedText = attrString;
    [self.contentLabel sizeToFit];

    CGFloat contentW = self.contentLabel.frame.size.width;
    CGFloat contentH = self.contentLabel.frame.size.height;

    self.contentLabel.frame = CGRectMake(Alert_Width/2 - contentW/2, CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(5), contentW, contentH);
    CGFloat AlertH = NC_kAUTOWIDTH(55) + NC_kAUTOWIDTH(35) + self.contentLabel.frame.size.height + NC_kAUTOWIDTH(50);
   
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    self.contentLabel.userInteractionEnabled = YES;
    [self.contentLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    
    self.alertView.frame = CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, AlertH);
    self.alertView.center =  self.window.center;

    _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {

                         CGRect fixframe =_alertView.layer.frame;
                         _subLayer.frame = fixframe;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             _subLayer.hidden = NO;
                         });
                     }];

    self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(50)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.knowButton addSubview:_knowIndicator];


    self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
    UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
    [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
    self.guanBiButton.backgroundColor = [UIColor clearColor];
    [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.guanBiButton];

    _huifuButton= [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width - NC_kAUTOWIDTH(90), NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(80), NC_kAUTOWIDTH(40))];
    _huifuButton.backgroundColor = [UIColor clearColor];
    [_alertView addSubview:_huifuButton];
    [_huifuButton setTitle:NSLocalizedString(huFuBtnText , nil) forState:UIControlStateNormal];
    _huifuButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(12)];
    [_huifuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_huifuButton addTarget:self action:@selector(huFuBtnCLick) forControlEvents:UIControlEventTouchUpInside];

    _huFuIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(40)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _huFuIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.huifuButton addSubview:_huFuIndicator];
}





- (void)showXuanZeShiJianAlertWithImageName:(NSString *)imageName{
    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];

    
    self.buttonArr = @[@"随机",@"半年",@"一年",@"五年",@"十年"];
    
    
    _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",imageName]];
    self.titleLabel.text = @"选择发信日期";
    _contentLabel.hidden = YES;
    
    CGFloat ButtonW = (Alert_Width - kAUTOWIDTH(30) - 4*kAUTOWIDTH(10))/5;
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(NC_kAUTOWIDTH(15) + i*(kAUTOWIDTH(10)+ButtonW),CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(20), ButtonW, kAUTOWIDTH(20));
        button.backgroundColor = [UIColor clearColor];
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = kAUTOWIDTH(3);
        button.layer.masksToBounds = YES;

//        if (i == 0) {
            [button setTitle:_buttonArr[i] forState:UIControlStateNormal];
//        }
        
        
        
        if (@available(iOS 13.0, *)) {
            [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        
        button.tag = 200 + i;
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
    }
    
    CGFloat AlertH = NC_kAUTOWIDTH(55) + kAUTOWIDTH(30) + kAUTOWIDTH(55) + kAUTOWIDTH(55);

    self.alertView.frame = CGRectMake((ScreenWidth - Alert_Width)/2, 0, Alert_Width, AlertH);
       self.alertView.center =  self.window.center;

       _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
       [UIView animateWithDuration:0.5f
                             delay:0
            usingSpringWithDamping:1.0
             initialSpringVelocity:0.3
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:^(BOOL finished) {

                            CGRect fixframe =_alertView.layer.frame;
                            _subLayer.frame = fixframe;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                _subLayer.hidden = NO;
                            });
                        }];

       self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
       [self.knowButton setTitle:NSLocalizedString(@"自定义时间" , nil) forState:UIControlStateNormal];
       [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

       _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(50)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
       _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
//       [self.knowButton addSubview:_knowIndicator];


       self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
       self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
       UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
       [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
       self.guanBiButton.backgroundColor = [UIColor clearColor];
       [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
       [self.window addSubview:self.guanBiButton];

    
//    self.knowButton.hidden = YES;
    
}


- (void)buttonClick:(UIButton *)button{
    
    [BCShanNianKaPianManager maDaQingZhenDong];
    
    button.selected = YES;
    
    
    for (int i = 0 ; i < _buttonArr.count; i ++) {

        if (button.tag == 200 + i ) {
            button.selected = YES;
            button.backgroundColor = [UIColor redColor];
            continue;
        }
        UIButton *button = (UIButton *)[self viewWithTag:200 + i];
        button.selected = NO;
        button.backgroundColor = [UIColor clearColor];
    
    }
    
    if (self.selDateBlock) {
        self.selDateBlock(button.tag - 200);
    }
}

- (void)dismissAlertView{

    [self.subLayer removeFromSuperlayer];
    self.subLayer = nil;

    _alertView.transform = CGAffineTransformMakeScale(1,1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         self.alertView.alpha = 0;
                         self.effectViewT.alpha = 0;
                         self.guanBiButton.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.bgView removeFromSuperview];
                         [self.alertView removeFromSuperview];
                         [self.guanBiButton removeFromSuperview];
                         self.guanBiButton = nil;
                         self.bgView = nil;
                         self.alertView = nil;
                     }];
}

- (void)knowBtnClick{
    if (self.woZhiDaoLeBlock) {
        self.woZhiDaoLeBlock();
    }
}
- (void)showJuHua{
    [self.knowButton setTitle:@"" forState:UIControlStateNormal];
    [_knowIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)huiFuShowJuHua{
    [self.huifuButton setTitle:@"" forState:UIControlStateNormal];
    [_huFuIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)guanBiBtnClick{

    [self dismissAlertView];
    if (self.guanBiBlock) {
        self.guanBiBlock();
    }
}

- (void)huFuBtnCLick{
    if (self.huFuBlock) {
        self.huFuBlock();
    }
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
   UILabel *label=(UILabel*)recognizer.view;
   NSLog(@"%@被点击了",label.text);
    if (self.labelBlock) {
          self.labelBlock();
      }
}



- (void)showSuperVipAlertView{
    [self.bgView removeFromSuperview];
    _bgView = nil;
    _effectT = nil;
    _alertView = nil;
    _subLayer = nil;

    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.alpha = 0.6;
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];

    
    if (@available(iOS 13.0, *)) {
        _effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
    } else {
        _effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    _effectViewT = [[UIVisualEffectView alloc] initWithEffect:_effectT];
    _effectViewT.frame = _bgView.frame;
    _effectViewT.alpha = 1.f;
    _effectViewT.userInteractionEnabled = YES;
    [self addSubview:_effectViewT];

    _alertView = [[UIView alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), NC_PCTopBarHeight + NC_kAUTOWIDTH(30), SuperVIPAlert_Width, SuperVIPAlert_Width)];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = NC_kAUTOWIDTH(7);
    _alertView.center = self.window.center;
    _alertView.userInteractionEnabled = YES;
    [self addSubview:_alertView];

    _subLayer=[CALayer layer];
    CGRect fixframe = CGRectZero;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = NC_kAUTOWIDTH(10);
    _subLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds = NO;
    _subLayer.shadowColor = [UIColor grayColor].CGColor;
    _subLayer.shadowOffset = CGSizeMake(0,0);
    _subLayer.shadowOpacity = 0.2f;
    _subLayer.shadowRadius = 10;
    _subLayer.hidden = YES;
    [self.layer insertSublayer:_subLayer below:self.alertView.layer];


}

- (void)showSuperVipAlertViewWithTitle:(NSString *)titleString
                            content:(NSString *)contentString
                            redText:(NSString *)redText
                         knowButton:(NSString *)knowBtnText
                        huiFuButton:(NSString *)huFuBtnText
                          imageName:(NSString *)imageName{

    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.userInteractionEnabled = YES;
    [self.window addSubview:self];

    _alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {

                         CGRect fixframe =_alertView.layer.frame;
                         _subLayer.frame = fixframe;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             _subLayer.hidden = NO;
                         });
                     }];

    self.knowButton.frame = CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.contentLabel.frame), NC_kAUTOWIDTH(100),NC_kAUTOWIDTH(40));
    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(50)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.knowButton addSubview:_knowIndicator];


    self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
    UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
    [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
    self.guanBiButton.backgroundColor = [UIColor clearColor];
    [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.guanBiButton];

    _huifuButton= [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width - NC_kAUTOWIDTH(90), NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(80), NC_kAUTOWIDTH(40))];
    _huifuButton.backgroundColor = [UIColor clearColor];
    [_alertView addSubview:_huifuButton];
    [_huifuButton setTitle:NSLocalizedString(huFuBtnText , nil) forState:UIControlStateNormal];
    _huifuButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(12)];
    [_huifuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_huifuButton addTarget:self action:@selector(huFuBtnCLick) forControlEvents:UIControlEventTouchUpInside];

    _huFuIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(40)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(40))];
    _huFuIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.huifuButton addSubview:_huFuIndicator];
}













@end

