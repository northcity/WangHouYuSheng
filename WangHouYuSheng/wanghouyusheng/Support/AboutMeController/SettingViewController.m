//
//  MEEEEViewController.m
//  leisure
//
//  Created by qianfeng0 on 16/3/3.
//  Copyright © 2016年 陈希. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"
#import "BCAboutMeViewController.h"

#import "BCMiMaYuJieSuoViewController.h"
#import "LZBaseNavigationController.h"
#import "LZiCloudViewController.h"

#import "ZhuTiViewController.h"

#import "ListWangShengViewController.h"
#import "ListYiWanChengViewController.h"
#import "ListILikeViewController.h"

#import "ZJViewShow.h"
#import <StoreKit/StoreKit.h>
#import "SecondViewController.h"
#import "NewSecondViewController.h"
#import "WHBianJiViewController.h"
#import "WHTongBuViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "SettingTableViewCell.h"

const CGFloat kNavigationBarHeight = 44;
const CGFloat kStatusBarHeight = 20;

@interface SettingViewController ()<UITableViewDataSource,SKStoreProductViewControllerDelegate, UITableViewDelegate,MFMailComposeViewControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString *selectProductID;
    UIActivityIndicatorView *_indicator;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat scale;

@property(nonatomic,strong)UIAlertController *alert;
@property(nonatomic,strong)UIImageView * backGroundImage;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property(nonatomic,strong)UILabel *desginLabel;

@property(nonatomic,strong)UILabel *zhuTiDetailLabel;
@property(nonatomic,strong)UISwitch *zhuTiKaiGuanButon;

@property (nonatomic, strong) UIView *neiGouView;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *huiFuButton;

//@property(nonatomic,strong)APAdBanner * banner;

@end


@implementation SettingViewController

- (void)createAD{
    
//    self.banner = [[APAdBanner alloc] initWithSlot:@"qGJeNNyw" withSize:APAdBannerSize320x50 delegate:self currentController:self];
//    [self.view addSubview:self.banner];
//    [self.banner setInterval:2];
//    [self.banner load];
//    [self.banner setPosition:CGPointMake(ScreenWidth/2, ScreenHeight - kAUTOWIDTH(50) + kAUTOWIDTH(25))];

}


- (void)initOtherUI{
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(5), kAUTOWIDTH(150), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"个人中心";
    _navTitleLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:(16)] :  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(15)];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    [_titleView addSubview:_backBtn];
    
    
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];
        
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *pin = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 60, 30)];
    pin.image = [UIImage imageNamed:@"pin"];
    
    [self.navigationController.navigationBar addSubview:pin];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    image.image = [UIImage imageNamed:@"titlebar_shadow"];
    
    //信息内容
    [self createUI];
    [self.view insertSubview:image aboveSubview:self.tableView];
    [self initOtherUI];

    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
      
    }else{
        [self createAD];

    }
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)createUI{
    
  
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    if (PNCisIPHONEX) {
        //        self.tableView.sectionHeaderHeight = 24;
        self.tableView.sectionFooterHeight = 0;
    }
//    tableView!.cellLayoutMarginsFollowReadableWidth = false
    if (PNCisIPAD) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = false;
    }
    UIImageView * backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //    [self.view addSubview:backimage];
    backimage.image = [[UIImage imageNamed:@"QQ20180311-1.jpg"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    backimage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.tableView aboveSubview:backimage];
    
    UIButton * backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 32, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    
    [backBtn setImage:[UIImage imageNamed:@"返回 (3).png"] forState:UIControlStateNormal];
//    [self.view addSubview:backBtn];
    
    UILabel * label = [Factory createLabelWithTitle: NSLocalizedString(@"关于", nil)  frame:CGRectMake(60, 25, 100, 40) fontSize:14.f];
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
//    [self.view addSubview:label];
    
    if (PNCisIPHONEX) {
        backBtn.frame = CGRectMake(20, 48, 25, 25);
        label.frame = CGRectMake(60, 40, 60, 40);
    }
    
    UIView *label111 = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-80)/2, ScreenHeight-150, 80, 80)];
    label111.backgroundColor = [UIColor whiteColor];
    label111.layer.cornerRadius=12;
    label111.layer.shadowColor=[UIColor grayColor].CGColor;
    label111.layer.shadowOffset=CGSizeMake(0.5, 0.5);
    label111.layer.shadowOpacity=0.8;
    label111.layer.shadowRadius=1.2;
    //    [self.view addSubview:label111];
    
    self.desginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - kAUTOHEIGHT(60), ScreenWidth - 40, 44)];
    self.desginLabel.text = @"- - Create By NorthCity - -";
    self.desginLabel.textColor = PNCColorWithHex(0xdcdcdc);
    self.desginLabel.textAlignment = NSTextAlignmentCenter;
    self.desginLabel.font = [UIFont fontWithName:@"HeiTi SC" size:9];
    self.desginLabel.alpha = 0.9;
    [self.view addSubview:self.desginLabel];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {

        return @"往后余生";
    }else if (section == 1){
        return @"高级功能设置";
    }
    else {
        
        return @"更多设置";
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 10;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kAUTOWIDTH(120))];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake( kAUTOWIDTH(20), kAUTOWIDTH(15), kAUTOWIDTH(60), kAUTOWIDTH(60))];
        [headView addSubview:iconImage];
        
        if (PNCisIPAD) {
            headView.frame = CGRectMake(0, 0, ScreenWidth, 120);
            iconImage.frame = CGRectMake((20), (15), (60), (60));

        }
        
        NSString *isSuperVip = [[NSUserDefaults standardUserDefaults] objectForKey:ISBUYVIP];
            if (@available(iOS 13.0, *)) {
                BOOL isDark = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
                if (isDark) {
                    if ([isSuperVip isEqualToString:@"0"]) {
                        iconImage.image = [UIImage imageNamed:@"iconNew1024.png"];
                    }else{
                        iconImage.image = [UIImage imageNamed:@"iconvip1024"];
                    }
                }else{
                    if ([isSuperVip isEqualToString:@"0"]) {
                        iconImage.image = [UIImage imageNamed:@"iconNew1024.png"];
                    }else{
                        iconImage.image = [UIImage imageNamed:@"iconvip1024"];
                    }
                }
                } else {
                if([isSuperVip isEqualToString:@"0"]){
                        iconImage.image = [UIImage imageNamed:@"iconNew1024.png"];
                    }else{
                        iconImage.image = [UIImage imageNamed:@"iconvip1024"];
                    }
                }
        
            iconImage.layer.cornerRadius = PNCisIPAD ? 8 : kAUTOWIDTH(8);
            iconImage.layer.masksToBounds = YES;
            CALayer *subLayer=[CALayer layer];
            CGRect fixframe=iconImage.layer.frame;
            subLayer.frame = fixframe;
            subLayer.cornerRadius = PNCisIPAD ? 8 : kAUTOWIDTH(8);
            subLayer.backgroundColor=[[UIColor systemGrayColor] colorWithAlphaComponent:0.8].CGColor;
            subLayer.masksToBounds=NO;
            subLayer.shadowColor=[UIColor systemGrayColor].CGColor;
            subLayer.shadowOffset=CGSizeMake(0,2);
            subLayer.shadowOpacity=0.7f;
            subLayer.shadowRadius= 8;
        if([isSuperVip isEqualToString:@"0"]){
                        [headView.layer insertSublayer:subLayer below:iconImage.layer];
            }else{
//                iconImage.image = [UIImage imageNamed:@"iconvip1024"];
            }
        

            
            if (@available(iOS 13.0, *)) {
                     UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                         if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                             return PNCColorWithHexA(0xdcdcdc, 1);;
                         }else {
                             return PNCColorWithHexA(0xffffff, 0.8);
                         }
                     }];
                     
                subLayer.backgroundColor=backViewColor.CGColor;
                subLayer.shadowColor=backViewColor.CGColor;
                headView.backgroundColor = [UIColor systemBackgroundColor];
                 } else {
                     subLayer.backgroundColor=[[UIColor systemGrayColor] colorWithAlphaComponent:0.5].CGColor;
                     subLayer.shadowColor=[UIColor systemGrayColor].CGColor;
                    headView.backgroundColor = [UIColor whiteColor];
                 }
             
            UILabel * label = [Factory createLabelWithTitle:@"往后余生" frame:CGRectMake(CGRectGetMaxX(iconImage.frame) + kAUTOWIDTH(15),  kAUTOWIDTH(20), ScreenWidth - 60, kAUTOWIDTH(30))];
            [headView addSubview:label];
            label.textColor = PNCColorWithHex(0x1e1e1e);
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
            [label sizeToFit];
        
        if (PNCisIPAD) {
            label.frame = CGRectMake(CGRectGetMaxX(iconImage.frame) + (15),  (20), ScreenWidth - 60, (30));
            label.font = [UIFont boldSystemFontOfSize:(15)];
            [label sizeToFit];
        }
        
        if (@available(iOS 13.0, *)) {
            UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                        return PNCColorWithHexA(0x1e1e1e, 1);;
                    }else {
                        return PNCColorWithHexA(0xffffff, 0.8);
                    }
        }];
            
            label.textColor = backViewColor;
        } else {
            label.textColor = PNCColorWithHex(0x1e1e1e);
        }
          
        
        UIView *adLabelView = [[UIView alloc]init];
        adLabelView.frame = CGRectMake(CGRectGetMaxX(label.frame) + kAUTOWIDTH(5),kAUTOWIDTH(22), kAUTOWIDTH(65), kAUTOWIDTH(15));
        [headView addSubview:adLabelView];
        
        if (PNCisIPAD) {
        adLabelView.frame = CGRectMake(CGRectGetMaxX(label.frame) + (10),(20), (65), (15));
        }
               
        
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = PNCisIPAD ? CGRectMake(0, 0, (65), (15)) : CGRectMake(0, 0, kAUTOWIDTH(65), kAUTOWIDTH(15));
        gradientLayer.colors = @[(id)PNCColorWithHex(0xff5a71).CGColor, (id)PNCColorWithHex(0xff3554).CGColor];
        gradientLayer.locations = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.cornerRadius = PNCisIPAD ? 3 : kAUTOWIDTH(3);
        [adLabelView.layer addSublayer:gradientLayer];

        UILabel *adLabel = [[UILabel alloc]init];
        adLabel.frame =  PNCisIPAD ?  CGRectMake(0, 0, (65), (15)) : CGRectMake(0,0, kAUTOWIDTH(65), kAUTOWIDTH(15));
        if (@available(iOS 13.0, *)) {
            adLabel.textColor = [UIColor whiteColor];
        } else {
            adLabel.textColor = [UIColor whiteColor];
        }
        adLabel.font = PNCisIPAD ?  [UIFont boldSystemFontOfSize:(7)] : [UIFont boldSystemFontOfSize:kAUTOWIDTH(7)];
            adLabel.numberOfLines = 0;
            adLabel.text = @"The rest of life";
            adLabel.textAlignment = NSTextAlignmentCenter;
            [adLabelView addSubview:adLabel];
            adLabel.layer.cornerRadius = kAUTOWIDTH(3);
                    
                    
        
        
        UILabel * detailLabel = [Factory createLabelWithTitle:@"情侣必做的100件小事" frame:CGRectMake(CGRectGetMaxX(iconImage.frame) + kAUTOWIDTH(15), CGRectGetMaxY(label.frame) + kAUTOWIDTH(2), ScreenWidth - 60, kAUTOWIDTH(18))];
        
       
        
        [headView addSubview:detailLabel];
        detailLabel.textColor = [UIColor systemGrayColor];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:kAUTOWIDTH(10)];
        if (PNCisIPAD) {
            detailLabel.frame = CGRectMake(CGRectGetMaxX(iconImage.frame) + (15), CGRectGetMaxY(label.frame) + (2), ScreenWidth - 60, (18));
            detailLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:(10)];

        }
        UILabel * detailELabel = [Factory createLabelWithTitle:@"100 small things lovers must do." frame:CGRectMake(CGRectGetMaxX(iconImage.frame) + kAUTOWIDTH(15), CGRectGetMaxY(detailLabel.frame), ScreenWidth - 60, kAUTOWIDTH(18))];
      
        [headView addSubview:detailELabel];
        detailELabel.textColor = [UIColor systemGrayColor];
        detailELabel.textAlignment = NSTextAlignmentLeft;
        detailELabel.font = [UIFont fontWithName:@"Avenir-Medium" size:kAUTOWIDTH(10)];
        if (PNCisIPAD) {
            detailELabel.frame = CGRectMake(CGRectGetMaxX(iconImage.frame) + (15), CGRectGetMaxY(detailLabel.frame), ScreenWidth - 60, (18));
            detailELabel.font = [UIFont fontWithName:@"Avenir-Medium" size:(10)];

        }
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(iconImage.frame) + kAUTOWIDTH(7), kAUTOWIDTH(80), kAUTOWIDTH(18))];
        
        if (PNCisIPAD) {
            versionLabel.frame = CGRectMake((15), CGRectGetMaxY(iconImage.frame) + (7), (80), (18));
        }
        versionLabel.textAlignment = NSTextAlignmentCenter;
        versionLabel.textColor = PNCColorWithHexA(0xdcdcdc, 1);
        versionLabel.font = [UIFont boldSystemFontOfSize:10];

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"version: %@",app_Version];

        [headView addSubview:versionLabel];
        return  headView;
    }
    return nil;
    
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        if (section == 0) {
            return PNCisIPAD ? (110) : kAUTOWIDTH(110);
        } else {
            return 35;
        }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 5;
    }else if(section == 2){
        return 3;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
    NSLog(@"现在的状态%@",statusString);
    if (indexPath.row == 3 && indexPath.section == 2) {
        if ([statusString isEqualToString:@"关"]) {
            return 1;
        }else if ([statusString isEqualToString:@"开"]){
            return 1;
//            return PNCisIPAD ? 60 : kAUTOWIDTH(60);
        }else{
            return 1;
        }
    }else{
        return  PNCisIPAD ? 60 : kAUTOWIDTH(60);
    }

    return  PNCisIPAD ? 60 : kAUTOWIDTH(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],[indexPath row]];//以indexPath来唯一确定cell
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
       if (cell == nil) {
           cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       }
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
   cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:kAUTOWIDTH(12)];
    cell.textLabel.textColor = PNCColorWithHex(0x333333);
    if (PNCisIPAD) {
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:15];
    }

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"心动"];
        cell.textLabel.text = @"余生 | 所有";
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"时间 (1)"];
        cell.textLabel.text = @"余生 | 完成";
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"喜欢"];
        cell.textLabel.text = @"余生 | 收藏";
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"主题前.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"主题设置";
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"云盘"];
        cell.textLabel.text = @"恋人同步";
        
        cell.vipImageView.hidden = YES;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"密码"];
        cell.textLabel.text = @"密码与保护";
        cell.vipImageView.hidden = NO;

    }
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.textLabel.text = @"添加一条往后 | 余生";
        cell.vipImageView.hidden = NO;

    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"切换icon"];
        cell.textLabel.text = @"切换往后余生分类图标";
        cell.vipImageView.hidden = NO;

    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"状态"];
        cell.textLabel.text = @"是否打开声音震动反馈";

                if (!_zhuTiKaiGuanButon) {
                    _zhuTiKaiGuanButon = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth*0.75 - kAUTOWIDTH(70), CGRectGetMinY(cell.label.frame) + 10, kAUTOWIDTH(50), 50)];
                    if (PNCisIPAD) {
                        _zhuTiKaiGuanButon.frame = CGRectMake(ScreenWidth - 70, CGRectGetMinY(cell.label.frame) + 10, 50, 50);
                    }
                }
                [cell.contentView addSubview:_zhuTiKaiGuanButon];
                [_zhuTiKaiGuanButon addTarget:self action:@selector(qieHuanZhuTiAction:) forControlEvents:UIControlEventTouchUpInside];
                _zhuTiKaiGuanButon.transform = CGAffineTransformMakeScale(0.8,0.8);
                _zhuTiKaiGuanButon.tintColor = [UIColor blackColor];
                _zhuTiKaiGuanButon.onTintColor = [UIColor blackColor];
        
                if ([[BCUserDeafaults objectForKey:current_XIANSHILIEBIAO] isEqualToString:@"1"]) {
                    _zhuTiKaiGuanButon.on = YES;
                    cell.textLabel.text = NSLocalizedString(@"已经打开余生钟表声音", nil) ;
                    cell.imageView.image = [UIImage imageNamed:@"状态"];

                }else if([[BCUserDeafaults objectForKey:current_XIANSHILIEBIAO] isEqualToString:@"0"]){
                    _zhuTiKaiGuanButon.on = NO;
                    cell.textLabel.text = NSLocalizedString(@"已经关闭余生钟表声音", nil) ;
                    cell.imageView.image = [UIImage imageNamed:@"状态hui"];

                }else{
                    _zhuTiKaiGuanButon.on = YES;
                    cell.textLabel.text = NSLocalizedString(@"已经打开余生钟表声音", nil) ;
                    cell.imageView.image = [UIImage imageNamed:@"状态"];

                }
        
                if (!_zhuTiDetailLabel) {
                    _zhuTiDetailLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(cell.bounds.size.width - kAUTOWIDTH(195), 5, kAUTOWIDTH(120), 50)];
                    if (PNCisIPAD) {
                        _zhuTiDetailLabel.frame = CGRectMake(cell.bounds.size.width - 215, 5, 140, 50);
                    }
        //            _zhuTiDetailLabel.text =  NSLocalizedString(@"切换后需重启App生效", nil) ;
                    _zhuTiDetailLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
                    _zhuTiDetailLabel.textAlignment = NSTextAlignmentRight;
        
                    if (ScreenWidth < 375) {
                        _zhuTiDetailLabel.font = [UIFont fontWithName:@"Heiti SC" size:8];
                    }
                }
                [cell.contentView addSubview:_zhuTiDetailLabel];
        
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"记事"];
        cell.textLabel.text = @"发送意见";
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"分享"];
        cell.textLabel.text = @"分享给朋友";
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"评价"];
        cell.textLabel.text = @"给个小花花";
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
        
//        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
//        if ([statusString isEqualToString:@"开"]) {
//            cell.contentView.hidden = NO;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }else if ([statusString isEqualToString:@"关"]){
//            cell.contentView.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }else{
//            cell.contentView.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//
//        cell.imageView.image = [UIImage imageNamed:@"商店"];
//        cell.textLabel.text = @"北城的App";
    }
    
    return  cell;
}

- (void)qieHuanZhuTiAction:(UISwitch *)kaiGuanBtn{
    
    NSIndexPath *path=[NSIndexPath indexPathForRow:2 inSection:1];
    SettingTableViewCell *cell = (SettingTableViewCell *)[_tableView cellForRowAtIndexPath:path];
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.duration = 0.4;
    baseAnimation.repeatCount = 1;
    baseAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI]; // 终止角度
//    [cell.imageView.layer addAnimation:baseAnimation forKey:@"rotate-layer"];
    
    
    if (kaiGuanBtn.on == YES) {
        [BCUserDeafaults setObject:@"1" forKey:current_XIANSHILIEBIAO];
        [BCUserDeafaults synchronize];
        cell.textLabel.text =  NSLocalizedString(@"已经打开余生钟表声音", nil) ;
//        [[NSNotificationCenter defaultCenter ] postNotificationName:@"CHANGEZHUTIDEFAULT" object:self];
        cell.imageView.image = [UIImage imageNamed:@"状态"];
    }else{
        [BCUserDeafaults setObject:@"0" forKey:current_XIANSHILIEBIAO];
        [BCUserDeafaults synchronize];
        cell.imageView.image = [UIImage imageNamed:@"状态hui"];
        cell.textLabel.text = NSLocalizedString(@"已经关闭余生钟表声音", nil) ;
//        [[NSNotificationCenter defaultCenter ] postNotificationName:@"CHANGEZHUTI" object:nil];

    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ListWangShengViewController *svc = [[ListWangShengViewController alloc]init];
        [self cw_pushViewController:svc];

    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        ListYiWanChengViewController *svc = [[ListYiWanChengViewController alloc]init];
//        [self presentViewController:svc animated:YES completion:nil];

        [self cw_pushViewController:svc];

    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        ListILikeViewController *svc = [[ListILikeViewController alloc]init];
//        [self presentViewController:svc animated:YES completion:nil];
        [self cw_pushViewController:svc];

    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        ZhuTiViewController * zVc = [[ZhuTiViewController alloc]init];
//        [self presentViewController:zVc animated:YES completion:nil];
        [self cw_pushViewController:zVc];

    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
//            [self initNeiGouView3];

            
            WHTongBuViewController *tVC = [[WHTongBuViewController alloc]init];
            self.navigationController.delegate = nil;
//            [self.navigationController pushViewController:tVC animated:YES];
            [self cw_pushViewController:tVC];

        }else if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]){
//                LZiCloudViewController *bvc = [[LZiCloudViewController alloc]init];
////                LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
////                [self presentViewController:nav animated:YES completion:nil];
//            [self.navigationController pushViewController:bvc animated:YES];

            WHTongBuViewController *tVC = [[WHTongBuViewController alloc]init];
              self.navigationController.delegate = nil;
//              [self.navigationController pushViewController:tVC animated:YES];
            [self cw_pushViewController:tVC];

            
        }else{
//            [self initNeiGouView3];
//
//            LZiCloudViewController *bvc = [[LZiCloudViewController alloc]init];
//            LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
//            [self presentViewController:nav animated:YES completion:nil];

        }
//        SouSuoSheZhiViewController *bvc = [[SouSuoSheZhiViewController alloc]init];
//        LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
//        [self presentViewController:nav animated:YES completion:nil];
    }
    if (indexPath.section == 1&& indexPath.row == 1) {
      
        self.nowLookADType = @"mima";
        
        if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
            [self initNeiGouView3];
            
        }else if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]){
            BCMiMaYuJieSuoViewController *bvc = [[BCMiMaYuJieSuoViewController alloc]init];
//            [self.navigationController pushViewController:bvc animated:YES];
            [self cw_pushViewController:bvc];

        }else{
            [self initNeiGouView3];
        }
        
      
    }
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        self.nowLookADType = @"bianji";
        
        
        if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
//            WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
//            sVc.pushFlag = @"0";
//            [self.navigationController pushViewController:sVc animated:YES];

            [self initNeiGouView3];
            
        }else if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]){
            WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
            sVc.pushFlag = @"0";

            [self cw_pushViewController:sVc];

        }else{
            [self initNeiGouView3];
        }
      
    }

    if (indexPath.section == 1 && indexPath.row == 4) {
        self.nowLookADType = @"zhuti";

        if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
                   [self initNeiGouView3];
                   
               }else if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]){
                  [self showAlertWithTitle:@"" scheme:@""];
               }else{
                   [self initNeiGouView3];

               }
        
        
        
      
          
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self pushEmail];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self shareImage];
    }
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1419939043?mt=8&action=write-review";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }
    
    if (indexPath.section == 2 && indexPath.row == 3){
        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
        if ([statusString isEqualToString:@"开"]) {
//            BCAboutMeViewController * ab = [[BCAboutMeViewController alloc]init];
//            [self presentViewController:ab animated:YES completion:nil];
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title scheme:(NSString *)scheme {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换『往后余生』分类图标" message:@"多套主题图标选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
   
    
    UIAlertAction *gaojingdu = [UIAlertAction actionWithTitle:@"旅行主题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"xiantiao" forKey:@"pagecontrolicon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
    UIAlertAction *dijingdu = [UIAlertAction actionWithTitle:@"美食主题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"meishi" forKey:@"pagecontrolicon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    


    [alertController addAction:cancelAction];
    [alertController addAction:gaojingdu];
    [alertController addAction:dijingdu];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = self.view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareImage{
    
    NSString *text = @"往后余生";
   
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1419939043?mt=8"];
    NSArray *activityItems = @[text,urlToShare];
    

    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    // 分享类型
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        // 显示选中的分享类型
        NSLog(@"当前选择分享平台 %@",activityType);
        if (completed) {
            [SVProgressHUD showInfoWithStatus:@"分享成功"];
            NSLog(@"分享成功");
        }else {
            [SVProgressHUD showInfoWithStatus:@"分享失败"];
            
            NSLog(@"分享失败");
        }
        
    }];
    
}

-(void)pushEmail{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (!controller) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        NSLog(@"设备还没有添加邮件账户");
    }else{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

        controller.mailComposeDelegate = self;
        [controller setSubject:@"往后余生(iOS版)反馈"];
        NSString * device = [[UIDevice currentDevice] model];
        NSString * ios = [[UIDevice currentDevice] systemVersion];
        NSString *body = [NSString stringWithFormat:@"请留下您的宝贵建议和意见：\n\n\n以下信息有助于我们确认您的问题，建议保留。\nDevice: %@\nOS Version: %@\n inVersion: %@", device, ios,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
        [controller setMessageBody:body isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:@"506343891@qq.com"];
        [controller setToRecipients:toRecipients];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的反馈发送成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNeiGouView{
    self.neiGouView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    self.neiGouView.backgroundColor = PNCColorWithHexA(0x000000, 0.3);

    self.blurImageView = [[UIImageView alloc]initWithFrame:self.neiGouView.bounds];
    self.blurImageView.userInteractionEnabled = YES;
    UIImage *screenImage = [self imageWithScreenshot];
        self.blurImageView.image = [self blur:screenImage];
        [self.neiGouView addSubview:self.blurImageView];
        self.blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.blurImageView.clipsToBounds = YES;
        self.blurImageView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.blurImageView.alpha = 1;
    }];
    
    UIView *mohuView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), 0, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - kAUTOHEIGHT(200))];
    
    if ([UIScreen mainScreen].bounds.size.height > 812.0f) {
        mohuView.frame = CGRectMake(kAUTOWIDTH(30), 0, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - kAUTOHEIGHT(400));

    }
    if ([UIScreen mainScreen].bounds.size.height == 812.0f) {
        mohuView.frame = CGRectMake(kAUTOWIDTH(30), 0, ScreenWidth - kAUTOWIDTH(60), ScreenHeight - 350);
        
    }
    
    mohuView.layer.cornerRadius = 10;
    mohuView.layer.masksToBounds = YES;
    mohuView.center = self.neiGouView.center;
    [self.blurImageView addSubview:mohuView];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = mohuView.bounds;
    effectView.userInteractionEnabled = YES;
    [mohuView addSubview:effectView];
    self.effectView.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        self.effectView.alpha = 0.5f;

    }];
    [self.view addSubview:self.neiGouView];
    
    UIImageView *VipImageView = [[UIImageView alloc]init];
    VipImageView.frame = CGRectMake(mohuView.frame.size.width/2 - kAUTOWIDTH(25), kAUTOHEIGHT(40), kAUTOWIDTH(50), kAUTOHEIGHT(50));
    VipImageView.image = [UIImage imageNamed:@"奖励"];
    [mohuView addSubview:VipImageView];
    VipImageView.layer.shadowOffset = CGSizeMake(1, 1);
    VipImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
    VipImageView.layer.shadowRadius = 9;
    VipImageView.layer.shadowOpacity = 0.5;
    
    UIButton *guanBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guanBiButton.frame = CGRectMake(ScreenWidth/2 - 12.5, CGRectGetMaxY(mohuView.frame)+kAUTOHEIGHT(10), 30, 30);
    [guanBiButton setImage:[UIImage imageNamed:@"关闭123"] forState:UIControlStateNormal];
    [guanBiButton addTarget:self action:@selector(removeNeiGouView) forControlEvents:UIControlEventTouchUpInside];
    [self.blurImageView addSubview:guanBiButton];
    
    UIView *listView1 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(VipImageView.frame) + kAUTOHEIGHT(25), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(60))];
    listView1.layer.cornerRadius = 8;
    listView1.layer.masksToBounds = YES;
    listView1.layer.borderColor = [UIColor redColor].CGColor;
    listView1.layer.borderWidth = 1;
//    [mohuView addSubview:listView1];
    
    UILabel *label0 =  [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(VipImageView.frame) + kAUTOHEIGHT(5), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(40))];
    label0.numberOfLines = 0;
    label0.textColor = [UIColor blackColor];
    label0.text = @"往后余生-高级功能购买服务";
    label0.font =  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:15];
    label0.textAlignment = NSTextAlignmentCenter;
    [mohuView addSubview:label0];
    
    UILabel *label1 =  [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(40), CGRectGetMaxY(label0.frame) + kAUTOHEIGHT(0), mohuView.frame.size.width - kAUTOWIDTH(80), kAUTOHEIGHT(180))];
    label1.numberOfLines = 0;
    label1.textColor = [UIColor redColor];
    label1.text = @"一：开启苹果云服务自动同步\n\n二：添加密码保护支持TouchID和FaceID\n\n三：无限添加 |往后余生| \n\n四：永久去除广告\n\n五：新功能永久免费使用。";
    label1.font =  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:13];
    label1.textAlignment = NSTextAlignmentCenter;
    [mohuView addSubview:label1];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake(kAUTOWIDTH(50), mohuView.frame.size.height - kAUTOHEIGHT(60), mohuView.frame.size.width - kAUTOWIDTH(100), kAUTOHEIGHT(38));
    NSString *jiaGeString = [BCUserDeafaults objectForKey:@"NEI_GOU_JIA_QIAN"];
    
    [_buyButton setTitle: [NSString stringWithFormat:@"立即购买VIP ¥ %@",jiaGeString] forState:UIControlStateNormal];
    _buyButton.layer.cornerRadius = 8;
    _buyButton.layer.masksToBounds = YES;
    _buyButton.layer.borderColor = [UIColor redColor].CGColor;
    _buyButton.layer.borderWidth = 0.5;
    _buyButton.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:11];
    [_buyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_buyButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [mohuView addSubview:_buyButton];
    
    _huiFuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _huiFuButton.frame = CGRectMake(kAUTOWIDTH(50), mohuView.frame.size.height - kAUTOHEIGHT(110), mohuView.frame.size.width - kAUTOWIDTH(100), kAUTOHEIGHT(38));
    [_huiFuButton setTitle:@"恢复购买" forState:UIControlStateNormal];
    _huiFuButton.layer.cornerRadius = 8;
    _huiFuButton.layer.masksToBounds = YES;
    _huiFuButton.layer.borderColor = [UIColor redColor].CGColor;
    _huiFuButton.layer.borderWidth = 0.5;
    _huiFuButton.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:11];
    [_huiFuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_huiFuButton addTarget:self action:@selector(replyToBuy) forControlEvents:UIControlEventTouchUpInside];

    [mohuView addSubview:_huiFuButton];
    
    
    UIButton * pingJiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pingJiaBtn.frame = CGRectMake(kAUTOWIDTH(50), mohuView.frame.size.height - kAUTOHEIGHT(165), mohuView.frame.size.width - kAUTOWIDTH(100), kAUTOHEIGHT(38));
    pingJiaBtn.backgroundColor = [UIColor blackColor];
    [pingJiaBtn setTitle: @"您也可以点个赞获取高级功能" forState:UIControlStateNormal];
    pingJiaBtn.layer.cornerRadius = 8;
    pingJiaBtn.layer.masksToBounds = YES;
    pingJiaBtn.layer.borderColor = [UIColor redColor].CGColor;
    pingJiaBtn.layer.borderWidth = 0.5;
    pingJiaBtn.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:11];
    [pingJiaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pingJiaBtn addTarget:self action:@selector(showAppStoreReView) forControlEvents:UIControlEventTouchUpInside];
    [mohuView addSubview:pingJiaBtn];
}

//弹出星星评论
- (void)showAppStoreReView{
    [self removeNeiGouView];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISBUYVIP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SVProgressHUD showSuccessWithStatus:@"感谢您的评价!"];
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    if ([systemVersion doubleValue] > 10.3) {
        if (@available(iOS 10.3, *)) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                //防止键盘遮挡
                //                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [BCUserDeafaults setObject:@"1" forKey:ISBUYVIP];
                    [SVProgressHUD showSuccessWithStatus:@"您已获取高级功能！"];
                });
            }
        }
    }
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}


//生成一张毛玻璃图片
- (UIImage*)blur:(UIImage*)theImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:18.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

//- (void)removeNeiGouView{
//    [self.neiGouView removeFromSuperview];
//    self.neiGouView = nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark 恢复购买(主要是针对非消耗产品)
-(void)replyToBuy{
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_buyButton.frame.size.width/2 - 22,0, 44, 44)];
    //设置显示位置
    _indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    //    _indicator.center = CGPointMake(22, kAUTOWIDTH(110));
    //将这个控件加到父容器中。
    [self.huiFuButton addSubview:_indicator];
    [self.huiFuButton setTitle:@"" forState:UIControlStateNormal];
    [_indicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
#pragma mark 测试内购
-(void)test{
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_buyButton.frame.size.width/2 - 22,0, 44, 44)];
    //设置显示位置
    _indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleGray;
    //    _indicator.center = CGPointMake(22, kAUTOWIDTH(110));
    //将这个控件加到父容器中。
    [self.buyButton addSubview:_indicator];
    [self.buyButton setTitle:@"" forState:UIControlStateNormal];
    [_indicator startAnimating];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if([SKPaymentQueue canMakePayments]){
        
        // productID就是你在创建购买项目时所填写的产品ID
        selectProductID = [NSString stringWithFormat:@"%@",@"com.chenxi.wanghouyusheng.VIP"];
        [self requestProductID:selectProductID];
        
    }else{
        
        // NSLog(@"不允许程序内付费");
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"请先开启应用内付费购买功能。"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles: nil];
        [alertError show];
    }
}

#pragma mark 1.请求所有的商品ID
-(void)requestProductID:(NSString *)productID{
    
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc]initWithArray:productIDArray];
    
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
    
}
#pragma mark 2.苹果那边的内购监听
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"可卖商品的数量=%ld",response.products.count);
    
    NSArray *product = response.products;
    if([product count] == 0){
        
        NSLog(@"没有商品");
        return;
    }
    
    for (SKProduct *sKProduct in product) {
        
        NSLog(@"pro info");
        NSLog(@"SKProduct 描述信息：%@", sKProduct.description);
        NSLog(@"localizedTitle 产品标题：%@", sKProduct.localizedTitle);
        NSLog(@"localizedDescription 产品描述信息：%@",sKProduct.localizedDescription);
        NSLog(@"price 价格：%@",sKProduct.price);
        NSLog(@"productIdentifier Product id：%@",sKProduct.productIdentifier);
        
        if([sKProduct.productIdentifier isEqualToString: selectProductID]){
            
            [self buyProduct:sKProduct];
            
            break;
            
        }else{
            
            //NSLog(@"不不不相同");
        }
        
    }
    
}

#pragma mark 内购的代码调用
-(void)buyProduct:(SKProduct *)product{
    
    // 1.创建票据
    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
    
    // 3.添加观察者，监听用户是否付钱成功(不在此处添加观察者)
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

#pragma mark 4.实现观察者监听付钱的代理方法,只要交易发生变化就会走下面的方法
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    /*
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买
     SKPaymentTransactionStateFailed,        购买失败
     SKPaymentTransactionStateRestored,      回复购买中
     SKPaymentTransactionStateDeferred       交易还在队列里面，但最终状态还没有决定
     */
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:{
                
                NSLog(@"正在购买");
            }break;
            case SKPaymentTransactionStatePurchased:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                NSLog(@"购买成功");
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISBUYVIP];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.tableView reloadData];
                    
                });
                
                // 购买后告诉交易队列，把这个成功的交易移除掉
                [queue finishTransaction:transaction];
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:transaction];
                [SVProgressHUD showSuccessWithStatus:@"购买成功"];
                [self.ncview dismissAlertView];
                if (self.buySuccessBlock) {
                    self.buySuccessBlock(YES);
                }
                if ([self.kaiguanFlag isEqualToString:@"1"]) {
                                   [self.navigationController popViewControllerAnimated:NO];
                               }
            }break;
            case SKPaymentTransactionStateFailed:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
               [SVProgressHUD showErrorWithStatus:@"购买失败"];

                if ([self.kaiguanFlag isEqualToString:@"1"]) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                
                NSLog(@"购买失败");
                [queue finishTransaction:transaction];
                [self.ncview dismissAlertView];
              if (self.buySuccessBlock) {
                self.buySuccessBlock(NO);
                }
            }break;
            case SKPaymentTransactionStateRestored:{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                NSLog(@"回复购买中,也叫做已经购买");
                [SVProgressHUD showSuccessWithStatus:@"恢复购买成功"];
                [self.ncview dismissAlertView];
                if ([self.kaiguanFlag isEqualToString:@"1"]) {
                                   [self.navigationController popViewControllerAnimated:NO];
                               }
                if (self.buySuccessBlock) {
                    self.buySuccessBlock(YES);
                    }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISBUYVIP];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                });
                // 回复购买中也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateDeferred:{
                
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
            }break;
            default:
                break;
        }
    }
}


// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)paymentTransactionp {
    
    NSString * productIdentifier = paymentTransactionp.payment.productIdentifier;
    // NSLog(@"productIdentifier Product id：%@", productIdentifier);
    NSString *transactionReceiptString= nil;
    
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    NSString *version = [UIDevice currentDevice].systemVersion;
    if([version intValue] >= 7.0){
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        NSURLRequest * appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }else{
        
        NSData * receiptData = paymentTransactionp.transactionReceipt;
        //  transactionReceiptString = [receiptData base64EncodedString];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    // 去验证是否真正的支付成功了
    [self checkAppStorePayResultWithBase64String:transactionReceiptString];
    
}

- (void)checkAppStorePayResultWithBase64String:(NSString *)base64String {
    
    /* 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明 */
    /*
     注意：
     自己测试的时候使用的是沙盒购买(测试环境)
     App Store审核的时候也使用的是沙盒购买(测试环境)
     上线以后就不是用的沙盒购买了(正式环境)
     所以此时应该先验证正式环境，在验证测试环境
     
     正式环境验证成功，说明是线上用户在使用
     正式环境验证不成功返回21007，说明是自己测试或者审核人员在测试
     */
    /*
     苹果AppStore线上的购买凭证地址是： https://buy.itunes.apple.com/verifyReceipt
     测试地址是：https://sandbox.itunes.apple.com/verifyReceipt
     */
    //    NSNumber *sandbox;
    NSString *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    //sandbox = @(0);
    sandbox = @"0";
#else
    //sandbox = @(1);
    sandbox = @"1";
#endif
    
    NSMutableDictionary *prgam = [[NSMutableDictionary alloc] init];;
    [prgam setValue:sandbox forKey:@"sandbox"];
    [prgam setValue:base64String forKey:@"reciept"];
    /*
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     0 代表沙盒  1代表 正式的内购
     最后最验证后的
     */
    /*
     内购验证凭据返回结果状态码说明
     21000 App Store无法读取你提供的JSON数据
     21002 收据数据不符合格式
     21003 收据无法被验证
     21004 你提供的共享密钥和账户的共享密钥不一致
     21005 收据服务器当前不可用
     21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
     21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
     21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
     */
    
    NSLog(@"字典==%@",prgam);
    
}

#pragma mark 客户端验证购买凭据
- (void)verifyTransactionResult
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSError *error;
    // 转换为 JSON 格式
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    // 不存在
    if (!requestData) { /* ... Handle error ... */ }
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    // 国内访问苹果服务器比较慢，timeoutInterval 需要长一点
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    // 在后台对列中提交验证请求，并获得官方的验证JSON结果
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"链接失败");
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       NSLog(@"验证失败");
                                   }
                                   
                                   // 比对 jsonResponse 中以下信息基本上可以保证数据安全
                                   /*
                                    bundle_id
                                    application_version
                                    product_id
                                    transaction_id
                                    */
                                   
                                   NSLog(@"验证成功");
                               }
                           }];
    
}


- (void)initNeiGouView3{
    NSString *nowStatus = @"限时优惠￥18";
    NSString *jiaGeString = [BCUserDeafaults objectForKey:@"NEI_GOU_JIA_QIAN"];

    self.ncview = [[NCSuperVipAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];

    NSString *isSuperVip = [[NSUserDefaults standardUserDefaults] objectForKey:ISBUYVIP];

    if ([isSuperVip isEqualToString:@"1"]) {
        [self.ncview showSuperVipAlertViewWithTitle:@"往后余生-高级服务" content:@"" redText:@"" knowButton:[NSString stringWithFormat:@"感谢您的支持",nowStatus] huiFuButton:@"恢复资格" imageName:@""];
    }else{
        [self.ncview showSuperVipAlertViewWithTitle:@"往后余生-高级服务" content:@"" redText:@"" knowButton:[NSString stringWithFormat:@"%@ 永久获取",jiaGeString] huiFuButton:@"恢复资格" imageName:@""];
    }
    LZWeakSelf(weakSelf);
    self.ncview.openYinSiZhengCeBlock = ^{
        [weakSelf openYinSiZhengCe];
    };
    self.ncview.openFuWuXieYiBlock = ^{
        [weakSelf openFuWuXieYi];
    };

    self.ncview.woZhiDaoLeBlock = ^{
        [weakSelf test];
    };
    self.ncview.huFuBlock = ^{
        [weakSelf replyToBuy];
    };
    
    self.ncview.lookADBlock = ^{
     
        if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
            [SVProgressHUD showWithStatus:@"您已经是高级用户"];
        }else{
            [weakSelf showAppStoreReView];

        }
    };
    
    self.ncview.guanBiBlock = ^{
        if ([weakSelf.kaiguanFlag isEqualToString:@"1"]) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    };
    
//    self.ncview.huiYuanNianBlock = ^{
//         [weakSelf testNianWith:nil];
//     };
}

- (void)openYinSiZhengCe{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.jianshu.com/p/cb9d65bdf683"]];

}

- (void)openFuWuXieYi{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.northcity.top/"]];

}


- (void) removeNeiGouView{
    [self.neiGouView removeFromSuperview];
    self.neiGouView = nil;
}

- (void)createShiPinAD{
//    BOOL ready = [APAdIncentivized isReady];
//    if (ready) {
//        [APAdIncentivized presentFromRootViewController:self];
//        [APAdIncentivized setDelegate:self];
//    }else{
//        [SVProgressHUD showInfoWithStatus:@"视频加载中..."];
//    }
   
}

// Incentvized video Ad has failed to present
- (void) incentivizedAdPresentDidFailWithError:(NSError *)error{
    
}

// Incentivized video Ad has presented successful
- (void) incentivizedAdPresentDidSuccess{
    
}

// Incentivized video Ad has complete without skip
- (void) incentivizedAdPresentDidComplete{
    [SVProgressHUD showSuccessWithStatus:@"非常感谢！"];
    if ([self.nowLookADType isEqualToString:@"mima"]) {
        BCMiMaYuJieSuoViewController *bvc = [[BCMiMaYuJieSuoViewController alloc]init];
        [self.navigationController pushViewController:bvc animated:YES];
    }
    
    if ([self.nowLookADType isEqualToString:@"bianji"]) {
        WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
        sVc.pushFlag = @"0";
        [self.navigationController pushViewController:sVc animated:YES];
    }
    
    if ([self.nowLookADType isEqualToString:@"zhuti"]) {
        [self showAlertWithTitle:@"" scheme:@""];
    }
    
    if ([self.nowLookADType isEqualToString:@"tongbu"]) {
        if (self.buySuccessBlock) {
            self.buySuccessBlock(YES);
        }
        
    }
}

// Incentivized video Ad has complete with skip
- (void) incentivizedAdPresentDidSkip{
    [SVProgressHUD showSuccessWithStatus:@"非常感谢！"];
    if ([self.nowLookADType isEqualToString:@"mima"]) {
        BCMiMaYuJieSuoViewController *bvc = [[BCMiMaYuJieSuoViewController alloc]init];
        [self.navigationController pushViewController:bvc animated:YES];
        [self.ncview dismissAlertView];

    }
    
    if ([self.nowLookADType isEqualToString:@"bianji"]) {
        WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
        sVc.pushFlag = @"0";
        [self.navigationController pushViewController:sVc animated:YES];
        [self.ncview dismissAlertView];

    }
    
    if ([self.nowLookADType isEqualToString:@"zhuti"]) {
        [self showAlertWithTitle:@"" scheme:@""];
        [self.ncview dismissAlertView];

    }
    
    if ([self.nowLookADType isEqualToString:@"tongbu"]) {
        if (self.buySuccessBlock) {
            self.buySuccessBlock(YES);
        }
        [self.ncview dismissAlertView];

        
    }
}



@end


