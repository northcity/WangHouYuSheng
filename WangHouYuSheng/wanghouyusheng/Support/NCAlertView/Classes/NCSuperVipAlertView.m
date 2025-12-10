//
//  NCSuperVipAlertView.m
//  NCAlertView
//
//  Created by 2345 on 2019/7/30.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import "NCSuperVipAlertView.h"
#import "NCAlertView.h"
#import "NcSuperVipCollectionViewCell.h"

@interface NCSuperVipAlertView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{

    dispatch_source_t _timer;

}
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
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong)UIButton *yinsiBtn;
@property (nonatomic, strong)UIButton *fuwuBtn;
@property (nonatomic, strong)UIView *segmentView;
@property (nonatomic, strong)UILabel *showDaoJiShiLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayerNian;


@property (nonatomic, strong) NSArray * imageNameArr;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * contentArr;

@end

@implementation NCSuperVipAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        _imageNameArr = @[@"mimabaohu2",@"沙漏",@"beedaefafeefe-2",@"云端",@"wuxian",@"huiyuan"];
        _titleArr = @[@"隐私保护",@"可爱图标主题",@"无广告",@"恋人同步",@"无限模式",@"高级功能"];
        _contentArr = @[@"开启密码保护，防止窥屏",@"使用多套『往后余生』分类图标",@"清爽页面，享受自由",@"恋人共享清单",@"无限添加/删除『往后余生』",@"所有高级功能"];

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
    }
    _effectViewT = [[UIVisualEffectView alloc] initWithEffect:_effectT];
    _effectViewT.frame = _bgView.frame;
    _effectViewT.alpha = 1.f;
    _effectViewT.userInteractionEnabled = YES;
    [self addSubview:_effectViewT];

    _alertView = [[UIView alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), NC_PCTopBarHeight + NC_kAUTOWIDTH(30), SuperVIPAlert_Width, SuperVIPAlert_Width)];
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


//    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(20), NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(40))];
//    _iconImageView.backgroundColor = [UIColor clearColor];
//    [_alertView addSubview:_iconImageView];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), NC_kAUTOWIDTH(30), SuperVIPAlert_Width - NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(30))];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(17)]];
    
    if (PNCisIPAD) {
           self.titleLabel.frame = CGRectMake((20), (30), SuperVIPAlert_IPADWidth - (40), (30));
           [self.titleLabel setFont:[UIFont boldSystemFontOfSize:(17)]];
       }
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"时间胶囊-超级会员";
    [_alertView addSubview:self.titleLabel];


    self.collectionView.frame = CGRectMake(NC_kAUTOWIDTH(25), CGRectGetMaxY(self.titleLabel.frame) + NC_kAUTOWIDTH(10), SuperVIPAlert_Width - NC_kAUTOWIDTH(50),SuperVIPAlert_Width - NC_kAUTOWIDTH(40));

//    if (PNCisIPAD) {
//        self.collectionView.frame = CGRectMake(40, CGRectGetMaxY(self.titleLabel.frame) + (10), SuperVIPAlert_Width - 200 ,SuperVIPAlert_Width - (100));
//    }
//
    
    [_alertView addSubview:self.collectionView];


    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(0), Alert_Width - NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(30))];
    [self.contentLabel setFont:[UIFont fontWithName:@"HeiTi SC" size:NC_kAUTOWIDTH(10)]];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"我是标题";
    if (@available(iOS 13.0, *)) {
        self.contentLabel.textColor = [UIColor labelColor];
    } else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
    [_alertView addSubview:self.contentLabel];

    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(SuperVIPAlert_Width/2 - 0.25, CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(5), 0.5, NC_kAUTOWIDTH(30))];
    if (@available(iOS 13.0, *)) {
        self.segmentView.backgroundColor = [UIColor labelColor];
    } else {
        self.segmentView.backgroundColor = [UIColor blackColor];
    }
    self.segmentView.alpha = 0.3;
    [_alertView addSubview:self.segmentView];

    self.yinsiBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.segmentView.frame) - NC_kAUTOWIDTH(80), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(5), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30))];
    
    
    
    self.yinsiBtn.backgroundColor = [UIColor clearColor];
    [self.yinsiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.yinsiBtn setTitle:NSLocalizedString(@"隐私政策" , nil) forState:UIControlStateNormal];
     self.yinsiBtn.titleLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(13)] : [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(12)];

    [self.yinsiBtn addTarget:self action:@selector(yinSiZhengCeClick) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.yinsiBtn];

    self.fuwuBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.segmentView.frame) , CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(5), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30))];
    self.fuwuBtn.backgroundColor = [UIColor clearColor];
    [self.fuwuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.fuwuBtn setTitle:NSLocalizedString(@"技术支持" , nil) forState:UIControlStateNormal];
    self.fuwuBtn.titleLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(13)] : [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(12)];

    [self.fuwuBtn addTarget:self action:@selector(fuWuXieYiClick) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.fuwuBtn];

    self.knowButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(130),NC_kAUTOWIDTH(28))];
    self.knowButton.backgroundColor = [UIColor clearColor];
    [self.knowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.knowButton setTitle:NSLocalizedString(@"￥6/月永久获取" , nil) forState:UIControlStateNormal];
    self.knowButton.titleLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"PingFangSC-Semibold" size:15] : [UIFont fontWithName:@"PingFangSC-Semibold" size:kAUTOWIDTH(10)];
    self.knowButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    //    [self.knowButton addTarget:self action:@selector(writeAPaper) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.knowButton];
    self.knowButton.layer.cornerRadius = NC_kAUTOWIDTH(5);


    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.knowButton.frame;
    self.gradientLayer.colors = @[(id)NC_PNCColorWithHex(0xF5576C).CGColor, (id)NC_PNCColorWithHex(0xF093FB).CGColor];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = PNCisIPAD ? 5  : NC_kAUTOWIDTH(5);
    [self.alertView.layer insertSublayer:self.gradientLayer below:self.knowButton.layer];

    
    self.LookADBtn = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.knowButton.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(130),NC_kAUTOWIDTH(28))];
    self.LookADBtn.backgroundColor = [UIColor redColor];
    [self.LookADBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.LookADBtn setTitle:NSLocalizedString(@"点赞也能获取高级功能" , nil) forState:UIControlStateNormal];
    self.LookADBtn.titleLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"PingFangSC-Semibold" size:15] : [UIFont fontWithName:@"PingFangSC-Semibold" size:kAUTOWIDTH(10)];
    self.LookADBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    //    [self.knowButton addTarget:self action:@selector(writeAPaper) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:self.LookADBtn];
    self.LookADBtn.layer.cornerRadius = NC_kAUTOWIDTH(5);

    
    self.knowNianButton = [[UIButton alloc]initWithFrame:CGRectMake(Alert_Width/2 - NC_kAUTOWIDTH(50), CGRectGetMinY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(130),NC_kAUTOWIDTH(28))];
    self.knowNianButton.backgroundColor = [UIColor clearColor];
    [self.knowNianButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.knowNianButton setTitle:NSLocalizedString(@"￥6/月永久获取" , nil) forState:UIControlStateNormal];
    self.knowNianButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(15)];
    self.knowNianButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_alertView addSubview:self.knowNianButton];
    self.knowNianButton.layer.cornerRadius = NC_kAUTOWIDTH(5);
    
    self.gradientLayerNian = [CAGradientLayer layer];
       self.gradientLayerNian.frame = self.knowButton.frame;
       self.gradientLayerNian.colors = @[(id)NC_PNCColorWithHex(0xF5576C).CGColor, (id)NC_PNCColorWithHex(0xF093FB).CGColor];
       self.gradientLayerNian.locations = @[@(0),@(1)];
       self.gradientLayerNian.startPoint = CGPointMake(0, 0.5);
       self.gradientLayerNian.endPoint = CGPointMake(1, 0.5);
       self.gradientLayerNian.cornerRadius = NC_kAUTOWIDTH(5);
//       [self.alertView.layer insertSublayer:self.gradientLayerNian below:self.knowNianButton.layer];

       
    
    
    self.showDaoJiShiLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(20), CGRectGetMaxY(self.knowButton.frame), SuperVIPAlert_Width - NC_kAUTOWIDTH(40), NC_kAUTOWIDTH(30))];
    [self.showDaoJiShiLabel setFont:[UIFont fontWithName:@"HeiTi SC" size:10]];
    self.showDaoJiShiLabel.textAlignment = NSTextAlignmentCenter;
    self.showDaoJiShiLabel.numberOfLines = 0;
    self.showDaoJiShiLabel.textColor = [UIColor grayColor];
    self.showDaoJiShiLabel.text = @"";
    [_alertView addSubview:self.showDaoJiShiLabel];
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

    self.titleLabel.text = titleString;

    self.contentLabel.text = contentString;
    [self.contentLabel sizeToFit];

    CGFloat contentW = self.contentLabel.frame.size.width;
    CGFloat contentH = self.contentLabel.frame.size.height;

    CGFloat AlertH = 0;
   
    if (PNCisIPAD) {
        self.collectionView.frame = CGRectMake(50, CGRectGetMaxY(self.titleLabel.frame) + (10), SuperVIPAlert_IPADWidth - 100 ,SuperVIPAlert_IPADWidth - (100));
        self.contentLabel.frame = CGRectMake(ScreenWidth/2 - (20) - contentW/2, CGRectGetMaxY(_collectionView.frame) + (5), contentW, contentH);
        AlertH = (60) + SuperVIPAlert_IPADWidth - (30) + self.contentLabel.frame.size.height + (45) - (48);
        self.alertView.frame = CGRectMake((ScreenWidth - SuperVIPAlert_IPADWidth)/2, 0, SuperVIPAlert_IPADWidth, AlertH);
        _alertView.center = self.window.center;
    
    }else{
        self.contentLabel.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(20) - contentW/2, CGRectGetMaxY(_collectionView.frame) + NC_kAUTOWIDTH(5), contentW, contentH);
        AlertH = NC_kAUTOWIDTH(60) + SuperVIPAlert_Width - NC_kAUTOWIDTH(30) + self.contentLabel.frame.size.height + NC_kAUTOWIDTH(130) + NC_kAUTOWIDTH(45) - NC_kAUTOWIDTH(48);
        self.alertView.frame = CGRectMake((ScreenWidth - SuperVIPAlert_Width)/2, 0, SuperVIPAlert_Width, AlertH);
        _alertView.center = self.window.center;

    }
    
    
    
    
    
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

    self.segmentView.frame =CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - 0.5, CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(15), 0.5, NC_kAUTOWIDTH(20));

    self.yinsiBtn.frame = CGRectMake(CGRectGetMinX(self.segmentView.frame) - NC_kAUTOWIDTH(80), CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30));

    self.fuwuBtn.frame = CGRectMake(CGRectGetMaxX(self.segmentView.frame) , CGRectGetMaxY(self.contentLabel.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(80),NC_kAUTOWIDTH(30));

    
   

    self.knowButton.frame = CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(60), CGRectGetMaxY(self.fuwuBtn.frame) + NC_kAUTOWIDTH(5), NC_kAUTOWIDTH(120),NC_kAUTOWIDTH(30));
    [self.knowButton setTitle:NSLocalizedString(knowBtnText , nil) forState:UIControlStateNormal];
    [self.knowButton addTarget:self action:@selector(knowBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.LookADBtn.frame = CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(60), CGRectGetMaxY(self.knowButton.frame) + NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(120),NC_kAUTOWIDTH(30));
    self.LookADBtn.backgroundColor = PNCColorWithHex(0xF5576C);
    [self.LookADBtn addTarget:self action:@selector(LookADClick) forControlEvents:UIControlEventTouchUpInside];

    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
        self.LookADBtn.hidden = YES;
    }
    
    self.gradientLayer.frame = self.knowButton.frame;
    if (PNCisIPAD) {
           self.segmentView.frame =CGRectMake((SuperVIPAlert_IPADWidth)/2, AlertH - 190, 0.5, (20));

           self.yinsiBtn.frame = CGRectMake(CGRectGetMinX(self.segmentView.frame) - (80),  AlertH - 190, (80),(30));

           self.fuwuBtn.frame = CGRectMake(CGRectGetMaxX(self.segmentView.frame) , AlertH - 190, (80),(30));
           self.knowButton.frame = CGRectMake((SuperVIPAlert_IPADWidth)/2 - 60, CGRectGetMaxY(self.fuwuBtn.frame) + (5), (120),(30));
           self.gradientLayer.frame = self.knowButton.frame;

       }

    _knowIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(60)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(30))];
    if (PNCisIPAD) {
        _knowIndicator.frame =CGRectMake((60)- (20),0,(40),(30));

    }
    _knowIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
    [self.knowButton addSubview:_knowIndicator];

    _knowIndicator.transform = CGAffineTransformMakeScale(0.7,0.7);

    CALayer *knowLayer = [CALayer layer];
    CGRect fixframe = CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.fuwuBtn.frame) + NC_kAUTOWIDTH(25), NC_kAUTOWIDTH(100), NC_kAUTOWIDTH(10));
    
    if (PNCisIPAD) {
        fixframe = CGRectMake((SuperVIPAlert_IPADWidth)/2 - 50, CGRectGetMaxY(self.fuwuBtn.frame) + (25), (100), (10));

    }
    
    knowLayer.frame = fixframe;
    knowLayer.cornerRadius = NC_kAUTOWIDTH(10);
    knowLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    knowLayer.masksToBounds = NO;
    knowLayer.shadowColor = [UIColor grayColor].CGColor;
    knowLayer.shadowOffset = CGSizeMake(0,2);
    knowLayer.shadowOpacity = 0.7f;
    knowLayer.shadowRadius = 5;
    [self.alertView.layer insertSublayer:knowLayer below:self.gradientLayer];

    
    
    
    self.knowNianButton.frame = CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(60), CGRectGetMaxY(self.knowButton.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(120),NC_kAUTOWIDTH(30));
    [self.knowNianButton setTitle:NSLocalizedString(@"￥35/年立即获取" , nil) forState:UIControlStateNormal];
    [self.knowNianButton addTarget:self action:@selector(knowNianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.knowNianButton.titleLabel.font = [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(13)];
    self.gradientLayerNian.frame = self.knowNianButton.frame;


    _knowNianIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(60)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(30))];
    _knowNianIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
    [self.knowNianButton addSubview:_knowNianIndicator];

    _knowNianIndicator.transform = CGAffineTransformMakeScale(0.7,0.7);

    CALayer *knowNianLayer = [CALayer layer];
    CGRect fixNianframe = CGRectMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(50), CGRectGetMaxY(self.knowNianButton.frame) - NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(100), NC_kAUTOWIDTH(10));
    knowNianLayer.frame = fixNianframe;
    knowNianLayer.cornerRadius = NC_kAUTOWIDTH(10);
    knowNianLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    knowNianLayer.masksToBounds = NO;
    knowNianLayer.shadowColor = [UIColor grayColor].CGColor;
    knowNianLayer.shadowOffset = CGSizeMake(0,2);
    knowNianLayer.shadowOpacity = 0.7f;
    knowNianLayer.shadowRadius = 5;
//    [self.alertView.layer insertSublayer:knowNianLayer below:self.gradientLayerNian];

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    self.showDaoJiShiLabel.frame = CGRectMake(NC_kAUTOWIDTH(20), CGRectGetMaxY(self.knowButton.frame) + NC_kAUTOWIDTH(5), ScreenWidth - NC_kAUTOWIDTH(80), NC_kAUTOWIDTH(20));


    self.guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - NC_kAUTOWIDTH(15), CGRectGetMaxY(_alertView.frame) + NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(30));
    
    if (PNCisIPAD) {
        self.guanBiButton.frame = CGRectMake(ScreenWidth/2 - (15), CGRectGetMaxY(_alertView.frame) + (85), (30), (30));
        self.showDaoJiShiLabel.frame = CGRectMake(0, CGRectGetMaxY(self.knowButton.frame) + (5), SuperVIPAlert_IPADWidth, (20));

    }
    UIImage *buttonImage = [UIImage imageNamed:@"NCAlertViewBundle.bundle/guanbi"];
    [self.guanBiButton setImage:buttonImage forState:UIControlStateNormal];
    self.guanBiButton.backgroundColor = [UIColor clearColor];
    [self.guanBiButton addTarget:self action:@selector(guanBiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.guanBiButton];

    _huifuButton= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_knowButton.frame), CGRectGetMinY(_knowButton.frame), NC_kAUTOWIDTH(70), NC_kAUTOWIDTH(30))];
    
    if (PNCisIPAD) {
        _huifuButton.frame  = CGRectMake(CGRectGetMaxX(_knowButton.frame), CGRectGetMinY(_knowButton.frame), (70), (30));

    }
    
    _huifuButton.backgroundColor = [UIColor clearColor];
    [_alertView addSubview:_huifuButton];
    [_huifuButton setTitle:NSLocalizedString(huFuBtnText , nil) forState:UIControlStateNormal];
    _huifuButton.titleLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(13)] : [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(12)];
    [_huifuButton setTitleColor:NC_PNCColorWithHex(0x222222) forState:UIControlStateNormal];
    [_huifuButton addTarget:self action:@selector(huFuBtnCLick) forControlEvents:UIControlEventTouchUpInside];

    _huFuIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(NC_kAUTOWIDTH(35)- NC_kAUTOWIDTH(20),0,NC_kAUTOWIDTH(40),NC_kAUTOWIDTH(30))];
    _huFuIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    [self.huifuButton addSubview:_huFuIndicator];
    _huFuIndicator.transform = CGAffineTransformMakeScale(0.7,0.7);

    [self dealDaojiShi];
}

- (void)dealDaojiShi{
    // 倒计时的时间 测试数据
    NSString *deadlineStr = @"2020-05-01 12:00:00";
    // 当前时间的时间戳
    NSString *nowStr = [self getCurrentTimeyyyymmdd];
    // 计算时间差值
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];

    __weak __typeof(self) weakSelf = self;

    if (_timer == nil) {
        __block NSInteger timeout = secondsCountDown; // 倒计时时间

        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.showDaoJiShiLabel.text = @"";
                    });
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    NSString *strTime = [NSString stringWithFormat:@"限时优惠 %02ld : %02ld : %02ld", hours, minute, second];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days == 0) {
                            weakSelf.showDaoJiShiLabel.text = strTime;
                        } else {
                            weakSelf.showDaoJiShiLabel.text = [NSString stringWithFormat:@"限时优惠 %ld天 %02ld : %02ld : %02ld", days, hours, minute, second];
                        }

                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {

    NSInteger timeDifference = 0;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;

    return timeDifference;
}

- (NSString *)getCurrentTimeyyyymmdd {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
       
        if (PNCisIPAD) {
            layout.itemSize = CGSizeMake((SuperVIPAlert_IPADWidth - 120)/2  - (2.5), (SuperVIPAlert_IPADWidth - (140))/4);
        }else{
            layout.itemSize = CGSizeMake((ScreenWidth - NC_kAUTOWIDTH(90))/2 - NC_kAUTOWIDTH(2.5), (ScreenWidth - NC_kAUTOWIDTH(90))/3);
        }
        
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 2.5;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        if (@available(iOS 13.0, *)) {
            _collectionView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _collectionView.backgroundColor = [UIColor whiteColor];
        }
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[NcSuperVipCollectionViewCell class] forCellWithReuseIdentifier:@"GBGuessYouLikeCell"];
    }
    return _collectionView;
}

#pragma mark- 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageNameArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NcSuperVipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBGuessYouLikeCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
//    GBSimilarGoodsModel *model = self.guessYouLikeArray[indexPath.row];
//    [cell setCellWithModel:model];
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"NCAlertViewBundle.bundle/%@",_imageNameArr[indexPath.row]]];
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.priceLabel.text = _contentArr[indexPath.row];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
// return  CGSizeMake((ScreenWidth - NC_kAUTOWIDTH(40))/2 - NC_kAUTOWIDTH(20), (ScreenWidth - NC_kAUTOWIDTH(40))/2);
//
//}

//// 设置整个组的缩进量是多少
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

//// 设置最小行间距，也就是前一行与后一行的中间最小间隔
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return NC_kAUTOWIDTH(0);
//}


//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.cellBlock) {
//        self.cellBlock(indexPath.row);
//        [GBEventHelper eventId:kGBEvent_xs_c];
//    }
}

- (void)knowBtnClick{
    [self showJuHua];
    if (self.woZhiDaoLeBlock) {
        self.woZhiDaoLeBlock();
    }
}

- (void)LookADClick{
 
    if (self.lookADBlock) {
        self.lookADBlock();
    }
}

- (void)showJuHua{
    [self.knowButton setTitle:@"" forState:UIControlStateNormal];
    [_knowIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}



- (void)knowNianBtnClick{
    [self showNianJuHua];
    if (self.huiYuanNianBlock) {
        self.huiYuanNianBlock();
    }
}

- (void)showNianJuHua{
    [self.knowNianButton setTitle:@"" forState:UIControlStateNormal];
    [_knowNianIndicator startAnimating];
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
    [self huiFuShowJuHua];
    if (self.huFuBlock) {
        self.huFuBlock();
    }
}

- (void)yinSiZhengCeClick{
    if (self.openYinSiZhengCeBlock) {
        self.openYinSiZhengCeBlock();
    }
}

- (void)fuWuXieYiClick{
    if (self.openFuWuXieYiBlock) {
        self.openFuWuXieYiBlock();
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


@end
