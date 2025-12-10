//
//  WHTongBuViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/4/3.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHTongBuViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AFNetworking.h>
#import <CoreImage/CoreImage.h>
#import "QrCodeReaderViewController.h"
#import "SettingViewController.h"

@interface WHTongBuViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDownloadTask *task;

@property (nonatomic,strong) NSDate *resumeData;
@property (nonatomic,strong) UILabel *qingLvMaLabel;
@property (nonatomic,strong) CALayer *subLayer;

@property (nonatomic,strong) UILabel *jieshiLabel;
@property (nonatomic,strong) UITextField *qingvmatextField;

@property (nonatomic,strong) UIView *cardFatherView;
@property (nonatomic,strong) UIView *cardViewUp;
@property (nonatomic,strong) CALayer *cardViewUpLayer;

@property (nonatomic,strong) UIImageView *erWeiMaImageView;
@property (nonatomic,strong) CALayer *erWeiMaImageViewLayer;
@property (nonatomic,strong) UIView *erWeiMaBackView;

@property (nonatomic,assign) NSInteger dianJiNumber;

@property (nonatomic,assign) NSInteger querySkip;

@end

@implementation WHTongBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOtherUI];
    self.navTitleLabel.text = @"恋人同步";
    [self.leftBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
//    [self.rightBtn setImage:[UIImage imageNamed:@"上传"] forState:UIControlStateNormal];

    CGFloat shiPeiH = 0;
    if (kIsFullScreen) {
        shiPeiH = 8;
    }
    
    [self.rightBtn setTitle:@"手动上传" forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(ScreenWidth - 20 - 60, 22 + shiPeiH + (PCTopBarHeight - 22)/2 - 12.5, 60, 25);
    self.rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [self.rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self createSubViews];
    [self getBenDiLength];
    self.querySkip = 0;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
       if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
           [self uploadWangHouYuShengWithAlert:YES];

       }else{
           

//           [self chuLiRiQi];

        SettingViewController *settingVc = [[SettingViewController alloc]init];
               self.navigationController.delegate = nil;
               [self.navigationController pushViewController:settingVc animated:YES];
               LZWeakSelf(weakSelf);
               settingVc.kaiguanFlag = @"1";
               settingVc.nowLookADType = @"tongbu";
               settingVc.buySuccessBlock = ^(BOOL isSuccess) {
                   if (isSuccess) {
                    [weakSelf uploadWangHouYuShengWithAlert:YES];
                   }
               };


               [settingVc initNeiGouView3];

       }
}




//- (void)chuLiRiQi{
//    [self uploadWangHouYuSheng];
//}

//- (void)leichuLiRiQi{
//
//    [self leiFangFaUpLoad];
//
//    return;
    
//
//    NSString *upTime = [BCUserDeafaults objectForKey:@"upTime"];
//
//    if (!upTime) {
//        [BCUserDeafaults setObject:[BCShanNianKaPianManager getCurrentTimes] forKey:@"upTime"];
//        [self leiFangFaUpLoad];
//    }else{
//        if ([[BCUserDeafaults objectForKey:@"upTime"] isEqualToString:[BCShanNianKaPianManager getCurrentTimes]]) {
//
//            NSString *today = [BCUserDeafaults objectForKey:@"todayIsUp"];
//            if (!today) {
//                [BCUserDeafaults setObject:@"0" forKey:@"todayIsUp"];
//                [self leiFangFaUpLoad];
//
//            }else{
//                if ([today integerValue] <= 3) {
//                    [self leiFangFaUpLoad];
//                }else{
////                    [SVProgressHUD showErrorWithStatus:@"今日更新次数已用尽！"];
//                }
//            }
//        }else{
//            [BCUserDeafaults setObject:[BCShanNianKaPianManager getCurrentTimes] forKey:@"upTime"];
//
//            [self leiFangFaUpLoad];
//
//        }
//    }
//}


- (void)isWoDeTongBu{
    [BCUserDeafaults setObject:@"1" forKey:ISBUYVIP];
}
//    LZWeakSelf(weakSelf);
//
//    NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];
//
//    BmobQuery *query = [BmobQuery queryWithClassName:@"WHYSQingLvMa"];
//                                 [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                                     for (BmobObject * fileObj in array) {
//                                         NSString *UUID = [fileObj objectForKey:@"USERUUID"];
//                                         NSString *objID = [fileObj objectForKey:@"objectId"];
//                                         NSString *lianairi = [fileObj objectForKey:@"lianairi"];
//
//                                         if ([UUID isEqualToString:self.qingvmatextField.text]) {
//                                             [BCUserDeafaults setObject:objID forKey:@"bendiOBJ"];
//                                             [BCUserDeafaults setObject:lianairi forKey:@"ISCLOCK"];
//                                             [BCUserDeafaults synchronize];
//
//                                          [WHTongBuViewController URLFileSizeWidthURL:[fileObj objectForKey:@"filetypeurl"] fileSize:^(NSString * _Nonnull size) {
//                                              NSString *urlSize = size;
//                                             __block NSString *benDiSize = @"";
//
//                                              NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//                                                 NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
//                                                 [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
//                                                     CGFloat length = fileSize;// Content-Length单位是byte，除以1024后是KB
//                                                                   NSString *size;
//                                                                   if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//                                                                       size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//                                                                   }else{
//                                                                       size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//                                                                   }
//
//                                                     NSLog(@"=本地文件大小=======%@",size);
//                                                     benDiSize = size;
//                                                     [weakSelf startWithUrl:[fileObj objectForKey:@"filetypeurl"]];
//
////                                                     if ([urlSize isEqualToString: benDiSize]) {
//////                                                         [SVProgressHUD showSuccessWithStatus:@""];
////                                                     }else if ([urlSize integerValue] > [benDiSize integerValue]){
////                                                     } else{
////                                                         [self leichuLiRiQi];
////                                                     }
//
//                                                 }];
//                                          }];
//                                      }
//                                     }
//                                  }];
//}

//5E27EC47F663E058B99F80A9AC5AD2C4
- (void)dianJiPingMu{
    
    self.dianJiNumber ++ ;
    if (self.dianJiNumber == 8) {
        
           UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           downBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(80), CGRectGetMaxX(self.cardFatherView.frame) + kAUTOWIDTH(50), kAUTOWIDTH(50), kAUTOWIDTH(50));
           [self.view addSubview:downBtn];
           downBtn.backgroundColor = [UIColor blackColor];
           [downBtn setImage:[UIImage imageNamed:@"时间3"] forState:UIControlStateNormal];
           [downBtn addTarget:self action:@selector(isWoDeTongBu) forControlEvents:UIControlEventTouchUpInside];
    }
   
          
}

- (void)createSubViews {
    
    self.dianJiNumber = 0;
        
    UIButton *resumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resumBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(120), PCTopBarHeight + kAUTOHEIGHT(50), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [self.view addSubview:resumBtn];
    [resumBtn setImage:[UIImage imageNamed:@"时间3"] forState:UIControlStateNormal];
    [resumBtn addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
       
    NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];

    
    
    
    self.cardFatherView = [[UIView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOWIDTH(10), ScreenWidth, ScreenWidth)];
    self.cardFatherView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cardFatherView];
    
    self.cardViewUp = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(40), kAUTOWIDTH(210))];
    self.cardViewUp.layer.cornerRadius = kAUTOWIDTH(6);
    self.cardViewUp.backgroundColor = [UIColor whiteColor];
    self.cardViewUp.layer.masksToBounds = YES;
    [self.cardFatherView addSubview:self.cardViewUp];
        
    
       
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianJiPingMu)];
    gesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:gesture];
   
    
    _cardViewUpLayer = [CALayer layer];
    CGRect fixCardframe= self.cardViewUp.frame;
    _cardViewUpLayer.frame = fixCardframe;
    _cardViewUpLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
    _cardViewUpLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _cardViewUpLayer.masksToBounds=NO;
    _cardViewUpLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
    _cardViewUpLayer.shadowOffset=CGSizeMake(0,0);
    _cardViewUpLayer.shadowOpacity=0.2f;
    _cardViewUpLayer.shadowRadius= PNCisIPAD ? 12 : kAUTOWIDTH(12);
    [self.cardFatherView.layer insertSublayer:_cardViewUpLayer below:self.cardViewUp.layer];

    
     UIButton *saoMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     saoMaBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(45), kAUTOWIDTH(175), kAUTOWIDTH(25), kAUTOWIDTH(25));
     [self.cardViewUp addSubview:saoMaBtn];
     [saoMaBtn setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
     [saoMaBtn addTarget:self action:@selector(saoMa) forControlEvents:UIControlEventTouchUpInside];
          
    UIButton *fenXiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fenXiangBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(80), kAUTOWIDTH(175), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [self.cardViewUp addSubview:fenXiangBtn];
    [fenXiangBtn setImage:[UIImage imageNamed:@"分享1"] forState:UIControlStateNormal];
    [fenXiangBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
                  
    UIButton *gengXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gengXinBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(115), kAUTOWIDTH(175), kAUTOWIDTH(30), kAUTOWIDTH(25));
    [self.cardViewUp addSubview:gengXinBtn];
//    [gengXinBtn setImage:[UIImage imageNamed:@"更新"] forState:UIControlStateNormal];
    [gengXinBtn addTarget:self action:@selector(shouDongGengXin) forControlEvents:UIControlEventTouchUpInside];
    [gengXinBtn setTitle:@"同步" forState:UIControlStateNormal];
//    self.rightBtn.frame = CGRectMake(ScreenWidth - 20 - 60, 22 + shiPeiH + (PCTopBarHeight - 22)/2 - 12.5, 60, 25);
    gengXinBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    gengXinBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [gengXinBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.erWeiMaBackView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(25), kAUTOWIDTH(65), kAUTOWIDTH(80), kAUTOWIDTH(80))];
    [self.cardViewUp addSubview:self.erWeiMaBackView];
    self.erWeiMaBackView.backgroundColor = PNCColorWithHexA(0xFA566E, 0.8);
    //    self.erWeiMaBackView.layer.borderColor = PNCColorWithHexA(0xFA566E, 0.8).CGColor;
    //    self.erWeiMaBackView.layer.borderWidth = kAUTOWIDTH(5);
        self.erWeiMaBackView.layer.cornerRadius = kAUTOWIDTH(0);
        self.erWeiMaBackView.layer.masksToBounds = YES;
        
    
    self.erWeiMaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), kAUTOWIDTH(70), kAUTOWIDTH(70), kAUTOWIDTH(70))];
    [self.cardViewUp addSubview:self.erWeiMaImageView];
   
    
    self.erWeiMaImageViewLayer = [CALayer layer];
       CGRect erWeiMaframe= self.erWeiMaBackView.frame;
       self.erWeiMaImageViewLayer.frame = erWeiMaframe;
       self.erWeiMaImageViewLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
       self.erWeiMaImageViewLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
       self.erWeiMaImageViewLayer.masksToBounds=NO;
       self.erWeiMaImageViewLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
       self.erWeiMaImageViewLayer.shadowOffset=CGSizeMake(0,3);
       self.erWeiMaImageViewLayer.shadowOpacity=0.6f;
       self.erWeiMaImageViewLayer.shadowRadius= PNCisIPAD ? 6 : kAUTOWIDTH(6);
       [self.cardViewUp.layer insertSublayer:self.erWeiMaImageViewLayer below:self.erWeiMaBackView.layer];
              
    
   
    _qingvmatextField = [[UITextField alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(70), kAUTOWIDTH(30))];
    [self.cardViewUp addSubview:_qingvmatextField];
    self.qingvmatextField.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:kAUTOWIDTH(14)];
    self.qingvmatextField.textColor = PNCColorWithHex(0xffffff);
    self.qingvmatextField.backgroundColor = PNCColorWithHex(0xFA566E);
    self.qingvmatextField.layer.cornerRadius = kAUTOWIDTH(6);
    self.qingvmatextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入情侣码进行恋人同步..."attributes:@{NSForegroundColorAttributeName:PNCColorWithHexA(0xffffff, 0.7),NSFontAttributeName:[UIFont boldSystemFontOfSize:kAUTOWIDTH(13)]}];
    self.qingvmatextField.layer.masksToBounds = YES;
    self.qingvmatextField.textAlignment = NSTextAlignmentCenter;
    self.qingvmatextField.returnKeyType = UIReturnKeyDone;
    self.qingvmatextField.adjustsFontSizeToFitWidth = YES;
    self.qingvmatextField.delegate = self;
    
       if (userQingLvMa.length == 0) {
           self.qingvmatextField.clearButtonMode = UITextFieldViewModeAlways;

       }else{
           self.qingvmatextField.text = userQingLvMa;

       }

    if (![BCUserDeafaults objectForKey:user_qinglvma]) {
           self.erWeiMaImageView.hidden = YES;
        self.erWeiMaImageViewLayer.hidden = YES;
        self.erWeiMaBackView.hidden = YES;
       }else{
           [self generatorOnClick];
       }
       
    
    //
//    self.qingLvMaLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(70), kAUTOWIDTH(30))];
//    self.qingLvMaLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:kAUTOWIDTH(15)];
//    self.qingLvMaLabel.textColor = PNCColorWithHex(0xffffff);
//    self.qingLvMaLabel.backgroundColor = PNCColorWithHex(0xFA566E);
//    self.qingLvMaLabel.layer.cornerRadius = kAUTOWIDTH(6);
//    self.qingLvMaLabel.layer.masksToBounds = YES;
//    self.qingLvMaLabel.textAlignment = NSTextAlignmentCenter;
//    [self.cardViewUp addSubview: self.qingLvMaLabel];
//    self.qingLvMaLabel.numberOfLines = 0;
//    self.qingLvMaLabel.text = @"";
//
//    if ([BCUserDeafaults objectForKey:user_qinglvma]) {
//
//        self.qingLvMaLabel.text = [BCUserDeafaults objectForKey:user_qinglvma];
//
//    }else{
//        self.qingLvMaLabel.text = @"****************";
//        self.qingLvMaLabel.textAlignment = NSTextAlignmentLeft;
//    }

    self.subLayer = [CALayer layer];
    CGRect qingLvMafixCardframe= self.qingvmatextField.frame;
    self.subLayer.frame = qingLvMafixCardframe;
    self.subLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
    self.subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    self.subLayer.masksToBounds=NO;
    self.subLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
    self.subLayer.shadowOffset=CGSizeMake(0,3);
    self.subLayer.shadowOpacity=0.3f;
    self.subLayer.shadowRadius= PNCisIPAD ? 6 : kAUTOWIDTH(3);
    [self.cardViewUp.layer insertSublayer:self.subLayer below:self.qingvmatextField.layer];
           
    

    self.jieshiLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOWIDTH(165), ScreenWidth - kAUTOWIDTH(100), kAUTOWIDTH(40))];
    //    Avenir Next
        self.jieshiLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
        self.jieshiLabel.textColor = PNCColorWithHex(0x333333);
        self.jieshiLabel.textAlignment = NSTextAlignmentLeft;
        self.jieshiLabel.numberOfLines = 2;
        self.jieshiLabel.text = @"";
    [self.cardViewUp addSubview: self.jieshiLabel];

    
    UILabel * shiYonShuoMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20),CGRectGetMaxY(self.cardViewUp.frame) + kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(40), kAUTOWIDTH(135))];
       //    Avenir Next
    shiYonShuoMingLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kAUTOWIDTH(13)];
           shiYonShuoMingLabel.textColor = PNCColorWithHex(0x333333);
           shiYonShuoMingLabel.textAlignment = NSTextAlignmentLeft;
           [self.cardFatherView addSubview: shiYonShuoMingLabel];
          shiYonShuoMingLabel.numberOfLines = 0;
           shiYonShuoMingLabel.text = @"1.首次上传生成情侣码，扫描情侣码或者输入情侣码后点击同步即可同步「往后余生」。\n2.对方无需付费也可通过您分享的情侣码进行同步「往后余生」。\n3.生成情侣码后您可复制，或者直接分享图片进行恋人共享。";

    
    
        
    
    
    UIButton *fuZhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fuZhiBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(80), kAUTOWIDTH(90), kAUTOWIDTH(60), kAUTOWIDTH(20));
    [self.cardViewUp addSubview:fuZhiBtn];
    [fuZhiBtn setTitle:@"复制情侣码" forState:UIControlStateNormal];
    fuZhiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
    fuZhiBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    fuZhiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [fuZhiBtn setTitleColor:PNCColorWithHex(0xffffff) forState:UIControlStateNormal];
//    fuZhiBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    fuZhiBtn.layer.borderWidth = 2;
    fuZhiBtn.backgroundColor = PNCColorWithHex(0xFA566E);
    fuZhiBtn.layer.cornerRadius = kAUTOWIDTH(4);
    fuZhiBtn.layer.masksToBounds = YES;
    [fuZhiBtn addTarget:self action:@selector(fuZhiqinglvma) forControlEvents:UIControlEventTouchUpInside];
             
          CALayer *fuZhiSubLayer = [CALayer layer];
             CGRect fuZhifixCardframe= fuZhiBtn.frame;
             fuZhiSubLayer.frame = fuZhifixCardframe;
             fuZhiSubLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
             fuZhiSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            fuZhiSubLayer.masksToBounds=NO;
             fuZhiSubLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
             fuZhiSubLayer.shadowOffset=CGSizeMake(0,3);
             fuZhiSubLayer.shadowOpacity=0.3f;
             fuZhiSubLayer.shadowRadius= PNCisIPAD ? 6 : kAUTOWIDTH(3);
             [self.cardViewUp.layer insertSublayer:fuZhiSubLayer below:fuZhiBtn.layer];
                    
    
    
        
    
    

//
//        UIButton *gengXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        gengXinBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(80), kAUTOWIDTH(90), kAUTOWIDTH(60), kAUTOWIDTH(20));
//        [gengXinBtn setTitle:@"更新" forState:UIControlStateNormal];
//        gengXinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
//        gengXinBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        gengXinBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [gengXinBtn setTitleColor:PNCColorWithHex(0xffffff) forState:UIControlStateNormal];
//        gengXinBtn.backgroundColor = PNCColorWithHex(0xFA566E);
//        gengXinBtn.layer.cornerRadius = kAUTOWIDTH(4);
//        gengXinBtn.layer.masksToBounds = YES;
//        [gengXinBtn addTarget:self action:@selector(tongBu) forControlEvents:UIControlEventTouchUpInside];
//
//
//        if (userQingLvMa.length == 0) {
//            [gengXinBtn setTitle:@"恋人同步" forState:UIControlStateNormal];
//
//        }else{
//            [gengXinBtn setTitle:@"恋人更新" forState:UIControlStateNormal];
//
//        }
//
//        CALayer * gengxinSubLayer = [CALayer layer];
//        CGRect gengXinfixCardframe= gengXinBtn.frame;
//        gengxinSubLayer.frame = gengXinfixCardframe;
//        gengxinSubLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
//        gengxinSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
//        gengxinSubLayer.masksToBounds=NO;
//        gengxinSubLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
//        gengxinSubLayer.shadowOffset=CGSizeMake(0,3);
//        gengxinSubLayer.shadowOpacity=0.3f;
//        gengxinSubLayer.shadowRadius= PNCisIPAD ? 6 : kAUTOWIDTH(3);
////        [self.cardViewDownLoad.layer insertSublayer:gengxinSubLayer below:gengXinBtn.layer];
                            

}

- (void)shouDongGengXin{
    [self tongBuVcAutoTongBuIsAlert:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length == 32) {
        [BCUserDeafaults setObject:textField.text forKey:user_qinglvma];
        [BCUserDeafaults synchronize];
        [self tongBuVcAutoTongBuIsAlert:YES];
        return YES;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的情侣码"];
    }
    return NO;
}

- (void)saoMa{
    QrCodeReaderViewController *readerVc = [[QrCodeReaderViewController alloc] init];
      readerVc.qrcodeValueBlock = ^(NSString * _Nonnull codeString) {
         
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"识别成功" message:@"已经识别到情侣码，是否同步" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
                            
                            
                            
                            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                
                              self.qingvmatextField.text = codeString;
                                [BCUserDeafaults setObject:self.qingvmatextField.text forKey:user_qinglvma];
                                [BCUserDeafaults synchronize];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self tongBuVcAutoTongBuIsAlert:YES];
                                });
                                        
                                
                                [self dismissViewControllerAnimated:YES completion:nil];
                               
                            }];
                            
                            [alertController addAction:cancelAction];
                            [alertController addAction:otherAction];
                            [self presentViewController:alertController animated:YES completion:nil];

                   
          });
       
      };
      [self.navigationController pushViewController:readerVc animated:YES];
}


//19EDEACCE67D7ACE40EAB4F44D997EC9
- (void)tongBuVcAutoTongBuIsAlert:(BOOL)isAlert{
    
    NSString *qingLvma = [BCUserDeafaults objectForKey:user_qinglvma];

    if (self.qingvmatextField.text.length == 32) {
        [BCUserDeafaults setObject:self.qingvmatextField.text forKey:user_qinglvma];
        [BCUserDeafaults synchronize];
    }


    if (qingLvma.length == 0) {
        return;
    }
    LZWeakSelf(weakSelf);
    if (isAlert) {
            [SVProgressHUD showWithStatus:@"处理中..."];
    }
    BmobQuery *query = [BmobQuery queryWithClassName:@"WHYSQingLvMa"];
    query.limit = 500;
    query.skip = self.querySkip;
   __block BOOL hadQueryDate = NO;

                               [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                   for (BmobObject * fileObj in array) {
                                       NSString *UUID = [fileObj objectForKey:@"USERUUID"];
                                       NSString *objID = [fileObj objectForKey:@"objectId"];
                                      NSString *lianairi = [fileObj objectForKey:@"lianairi"];

                                       
                                       if (qingLvma.length > 0) {
                                           
                                       
                                       
                                       if ([qingLvma isEqualToString:UUID] ) {
                                           hadQueryDate = YES;
                                           [BCUserDeafaults setObject:objID forKey:@"bendiOBJ"];
                                           [BCUserDeafaults setObject:lianairi forKey:@"ISCLOCK"];

                                           [BCUserDeafaults synchronize];
                                        [WHTongBuViewController URLFileSizeWidthURL:[fileObj objectForKey:@"filetypeurl"] fileSize:^(NSString * _Nonnull size) {
                                            NSString *urlSize = size;
                                           __block NSString *benDiSize = @"";
                                            
                                            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                                               NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
                                               [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
                                                   CGFloat benDiFileLength = fileSize;// Content-Length单位是byte，除以1024后是KB
                                                    
//                                                   NSString *size;
//                                                                 if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//                                                                     size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//                                                                 }else{
//                                                                     size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//                                                                 }

                                                   NSLog(@"=本地文件大小=======%@ ==== %f",urlSize,benDiFileLength);
                                                   
                                                   if (urlSize.floatValue < benDiFileLength) {
                                                       [self uploadWangHouYuShengWithAlert:NO];

                                                   }else{
                                                       [weakSelf startWithUrl:[fileObj objectForKey:@"filetypeurl"]];

                                                   }
                                                   
                                                   WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
                                                   manager.isreload = YES;
                                                   [self generatorOnClick];
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self];
                                                   if (isAlert) {
                                                        [SVProgressHUD showSuccessWithStatus:@"数据已经与云端同步"];
                                                   }
                                                   
                                                
                                                   
                                               }];
                                        }];
                                       }else{
                                       }
                                       }else{
                                           [SVProgressHUD showErrorWithStatus:@"请输入情侣码"];
                                       }
                                   }
                                   
                                   if (!hadQueryDate) {
                                       self.querySkip = self.querySkip + 500;
                                       query.skip = self.querySkip;
                                       query.limit = 500;
                                       [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                           for (BmobObject * fileObj in array) {
                                               NSString *UUID = [fileObj objectForKey:@"USERUUID"];
                                               NSString *objID = [fileObj objectForKey:@"objectId"];
                                              NSString *lianairi = [fileObj objectForKey:@"lianairi"];

                                               
                                               if (qingLvma.length > 0) {
                                                   
                                               
                                               
                                               if ([qingLvma isEqualToString:UUID] ) {
                                                   hadQueryDate = YES;
                                                   [BCUserDeafaults setObject:objID forKey:@"bendiOBJ"];
                                                   [BCUserDeafaults setObject:lianairi forKey:@"ISCLOCK"];

                                                   [BCUserDeafaults synchronize];
                                                [WHTongBuViewController URLFileSizeWidthURL:[fileObj objectForKey:@"filetypeurl"] fileSize:^(NSString * _Nonnull size) {
                                                    NSString *urlSize = size;
                                                   __block NSString *benDiSize = @"";
                                                    
                                                    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                                                       NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
                                                       [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
                                                           CGFloat benDiFileLength = fileSize;// Content-Length单位是byte，除以1024后是KB
                                                            
        //                                                   NSString *size;
        //                                                                 if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
        //                                                                     size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
        //                                                                 }else{
        //                                                                     size = [NSString stringWithFormat:@"%.1fKB",length/1024];
        //                                                                 }

                                                           NSLog(@"=本地文件大小=======%@ ==== %f",urlSize,benDiFileLength);
                                                           
                                                           if (urlSize.floatValue < benDiFileLength) {
                                                               [self uploadWangHouYuShengWithAlert:NO];

                                                           }else{
                                                               [weakSelf startWithUrl:[fileObj objectForKey:@"filetypeurl"]];

                                                           }
                                                           
                                                           
                                                           WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
                                                           manager.isreload = YES;
                                                           [self generatorOnClick];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self];
//                                                           [SVProgressHUD showSuccessWithStatus:@"数据已经与云端同步"];
                                                           
                                                        
                                                       }];
                                                }];
                                               }else{
                                               }
                                               }else{
                                                   [SVProgressHUD showErrorWithStatus:@"请输入情侣码"];
                                               }
                                           }
                                           if (!hadQueryDate) {
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self tongBuVcAutoTongBuIsAlert:isAlert];
                                               });
                                           }
                                        }];
                                   }
                                   
                                }];
    
   
}


- (void)fuZhiqinglvma{
    if (![BCUserDeafaults objectForKey:user_qinglvma]) {
        [SVProgressHUD showErrorWithStatus:@"情侣码为空,首次上传自动生成情侣码"];
    }else{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [BCUserDeafaults objectForKey:user_qinglvma];
    [SVProgressHUD showSuccessWithStatus:@"情侣码已复制"];
    }
}

+ (nullable NSString *)md5:(nullable NSString *)str {
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}
+ (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmm"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString = %@",currentTimeString);
    return currentTimeString;
}

//上传往后余生
- (void)uploadWangHouYuShengWithAlert:(BOOL)isAlert{
    
   NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];
   LZWeakSelf(weakSelf);

    if (userQingLvMa.length == 0) {
        NSString *UUID =[[WHTongBuViewController md5: [WHTongBuViewController getCurrentTimes]] uppercaseString];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
        
        BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
        BmobObject *obj = [[BmobObject alloc] initWithClassName:@"WHYSQingLvMa"];
        [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
              //如果文件保存成功，则把文件添加到filetype列
              if (isSuccessful) {
              //上传文件的URL地址
                  
            NSString *jiNianTime = [BCUserDeafaults objectForKey:@"ISCLOCK"];
              [obj setObject:file.url  forKey:@"filetypeurl"];
              [obj setObject:UUID forKey:@"USERUUID"];
              [obj setObject:jiNianTime forKey:@"lianairi"];
              //此处相当于新建一条记录,         //关联至已有的记录请使用 [obj updateInBackground];
              [obj saveInBackground];
              
              }else{
                  NSLog(@"==========%@",error);
              }
            }withProgressBlock:^(CGFloat progress) {
                if (isAlert) {
                    [SVProgressHUD showProgress:progress status:@"正在上传数据..."];
                }
                if (progress>=1) {
                    if (isAlert) {
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    }
                dispatch_sync(dispatch_get_main_queue(), ^{
                   
                    if (UUID.length > 0) {
                        [BCUserDeafaults setObject:UUID forKey:user_qinglvma];
                        weakSelf.qingvmatextField.text = UUID;
                        [weakSelf generatorOnClick];
                        [weakSelf.view setNeedsDisplay];
                        [BCUserDeafaults synchronize];

                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self tongBuVcAutoTongBuIsAlert:NO];
                    });
                    });
                      
                  }
              }];
    }else{
        self.qingLvMaLabel.text = [BCUserDeafaults objectForKey:user_qinglvma];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
        BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
        BmobObject *obj = [[BmobObject alloc] initWithClassName:@"WHYSQingLvMa"];
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    //如果文件保存成功，则把文件添加到filetype列
                    if (isSuccessful) {
                    //上传文件的URL地址
                        NSString *jiNianTime = [BCUserDeafaults objectForKey:@"ISCLOCK"];
                        NSLog(@"ID===============%@",[BCUserDeafaults objectForKey:@"bendiOBJ"]);
                    [obj setObjectId:[BCUserDeafaults objectForKey:@"bendiOBJ"]];
                    [obj setObject:file.url  forKey:@"filetypeurl"];
                    [obj setObject:userQingLvMa forKey:@"USERUUID"];
                    [obj setObject:jiNianTime forKey:@"lianairi"];
                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                if (isAlert) {
                                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                }

                            }else{
                                if (isAlert) {
                                    [SVProgressHUD showSuccessWithStatus:@"上传失败"];
                                }
                            }
                        }];
                    }else{
                        NSLog(@"==========%@",error);
                    //进行处理
                    }
                    }withProgressBlock:^(CGFloat progress) {
                        NSLog(@"===================上传进度%.2f",progress);
//                        [SVProgressHUD showProgress:progress status:@"正在上传数据..."];
                        if (progress>=1) {
//                          [SVProgressHUD showSuccessWithStatus:@"同步成功"];
                        }
                        
                    }];
    }
  
}


//- (void)isShouYeTongBu{
//    LZWeakSelf(weakSelf);
//
//    NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];
//
//    if (userQingLvMa.length == 0) {
//        return;
//    }
//    BmobQuery *query = [BmobQuery queryWithClassName:@"WHYSQingLvMa"];
//    query.limit = 500;
//    __block BOOL hadQueryData = NO;
//                                 [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                                     for (BmobObject * fileObj in array) {
//                                         NSString *UUID = [fileObj objectForKey:@"USERUUID"];
//                                         NSString *objID = [fileObj objectForKey:@"objectId"];
//                                         NSString *lianairi = [fileObj objectForKey:@"lianairi"];
//
//                                         if ([UUID isEqualToString:userQingLvMa]) {
//                                             hadQueryData = YES;
//                                             [BCUserDeafaults setObject:objID forKey:@"bendiOBJ"];
//                                             [BCUserDeafaults setObject:lianairi forKey:@"ISCLOCK"];
//                                             [BCUserDeafaults synchronize];
//
//                                          [WHTongBuViewController URLFileSizeWidthURL:[fileObj objectForKey:@"filetypeurl"] fileSize:^(NSString * _Nonnull size) {
//                                              NSString *urlSize = size;
//                                             __block NSString *benDiSize = @"";
//
//                                              NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//                                                 NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
//                                                 [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
//                                                     CGFloat length = fileSize;// Content-Length单位是byte，除以1024后是KB
//                                                                   NSString *size;
//                                                                   if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//                                                                       size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//                                                                   }else{
//                                                                       size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//                                                                   }
//
//                                                     NSLog(@"=本地文件大小=======%@",size);
//                                                     benDiSize = size;
//
//                                                     if ([urlSize isEqualToString: benDiSize]) {
////                                                         [SVProgressHUD showSuccessWithStatus:@""];
//                                                     }else if ([urlSize integerValue] > [benDiSize integerValue]){
//                                                        [weakSelf startWithUrl:[fileObj objectForKey:@"filetypeurl"]];
//                                                     } else{
//                                                         [self uploadWangHouYuShengWithAlert:YES];
//                                                     }
//
//                                                 }];
//                                          }];
//                                         }
//                                     }
//                                  }];
//
//    if (!hadQueryData) {
//        query.skip = 500;
//        query.limit = 500;
//        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//            for (BmobObject * fileObj in array) {
//                NSString *UUID = [fileObj objectForKey:@"USERUUID"];
//                NSString *objID = [fileObj objectForKey:@"objectId"];
//                NSString *lianairi = [fileObj objectForKey:@"lianairi"];
//
//                if ([UUID isEqualToString:userQingLvMa]) {
//                    hadQueryData = YES;
//                    [BCUserDeafaults setObject:objID forKey:@"bendiOBJ"];
//                    [BCUserDeafaults setObject:lianairi forKey:@"ISCLOCK"];
//                    [BCUserDeafaults synchronize];
//
//                 [WHTongBuViewController URLFileSizeWidthURL:[fileObj objectForKey:@"filetypeurl"] fileSize:^(NSString * _Nonnull size) {
//                     NSString *urlSize = size;
//                    __block NSString *benDiSize = @"";
//
//                     NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//                        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
//                        [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
//                            CGFloat length = fileSize;// Content-Length单位是byte，除以1024后是KB
//                                          NSString *size;
//                                          if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//                                              size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//                                          }else{
//                                              size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//                                          }
//
//                            NSLog(@"=本地文件大小=======%@",size);
//                            benDiSize = size;
//
//                            if ([urlSize isEqualToString: benDiSize]) {
////                                                         [SVProgressHUD showSuccessWithStatus:@""];
//                            }else if ([urlSize integerValue] > [benDiSize integerValue]){
//                               [weakSelf startWithUrl:[fileObj objectForKey:@"filetypeurl"]];
//                            } else{
//                                [self leichuLiRiQi];
//                            }
//
//                        }];
//                 }];
//                }
//            }
//         }];
//    }
//}

//- (void)leiFangFaUpLoad{
//       NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];
//       LZWeakSelf(weakSelf);
//
//        if (userQingLvMa.length == 0) {
//            NSString *UUID =[[WHTongBuViewController md5: [WHTongBuViewController getCurrentTimes]] uppercaseString];
//            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
//
//            BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
//            BmobObject *obj = [[BmobObject alloc] initWithClassName:@"WHYSQingLvMa"];
//            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
//                  //如果文件保存成功，则把文件添加到filetype列
//                  if (isSuccessful) {
//                  //上传文件的URL地址
//                  [obj setObject:file.url  forKey:@"filetypeurl"];
//                  [obj setObject:UUID forKey:@"USERUUID"];
//                  //此处相当于新建一条记录,         //关联至已有的记录请使用 [obj updateInBackground];
//                  [obj saveInBackground];
//
//                  }else{
//                      NSLog(@"==========%@",error);
//                  }
//                }withProgressBlock:^(CGFloat progress) {}];
//        }else{
//            NSString *userQingLvMa = [BCUserDeafaults objectForKey:user_qinglvma];
//            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
//            BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
//            BmobObject *obj = [[BmobObject alloc] initWithClassName:@"WHYSQingLvMa"];
//            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
//                        //如果文件保存成功，则把文件添加到filetype列
//                        if (isSuccessful) {
//                        //上传文件的URL地址
//                            NSLog(@"ID===============%@",[BCUserDeafaults objectForKey:@"bendiOBJ"]);
//                        [obj setObjectId:[BCUserDeafaults objectForKey:@"bendiOBJ"]];
//                        [obj setObject:file.url  forKey:@"filetypeurl"];
//                        [obj setObject:userQingLvMa forKey:@"USERUUID"];
//                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                            if (isSuccessful) {
//
//                                NSString *today = [BCUserDeafaults objectForKey:@"todayIsUp"];
//                                if (!today) {
//                                    [BCUserDeafaults setObject:@"0" forKey:@"todayIsUp"];
//                                }else{
//
//                                [BCUserDeafaults setObject:[NSString stringWithFormat:@"%ld",[today integerValue] + 1] forKey:@"todayIsUp"];
//                                }
//                                [BCUserDeafaults setObject:[BCShanNianKaPianManager getCurrentTimes] forKey:@"upTime"];
//
////                                [SVProgressHUD showSuccessWithStatus:@""];
//                            }else{
////                                [SVProgressHUD showErrorWithStatus:@""];
//                            }
//                            }];
//                        }else{
//                            NSLog(@"==========%@",error);
//                        }
//                        }withProgressBlock:^(CGFloat progress) {
//                            NSLog(@"===================上传进度%.2f",progress);
////                            [SVProgressHUD showProgress:progress status:@""];
//                            if (progress>=1) {
////                              [SVProgressHUD showSuccessWithStatus:@""];
//                            }
//                        }];
//        }
//}


//1.获取NSURLSession
- (NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

//2.开始下载任务
- (void)startWithUrl:(NSString *)string{
    NSURL *url = [NSURL URLWithString:string];
    self.task = [self.session downloadTaskWithURL:url];
    [self.task resume];
}

//3.暂停
- (void)pause{
    __weak typeof(self) weakSelf = self;
    //resumeData包含下载的路径和继续下载的位置
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.resumeData = resumeData;
        weakSelf.task = nil;
    }];
}

//4。恢复下载
- (void)resume{
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.task resume];
    self.resumeData = nil;
}

#pragma mark -- NSURLSessionDownloadDelegate
/**
 下载数据写入本地（可能会调用多次）

 @param bytesWritten 本次写入数据大小
 @param totalBytesWritten 已经写入数据大小
 @param totalBytesExpectedToWrite 总共需要写入数据大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //获取下载进度
    double pregress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"============%f",pregress);

//    [SVProgressHUD showProgress:pregress status:@"文件同步中，请勿退出"];
    
    if (pregress>=1) {
//                       [SVProgressHUD showSuccessWithStatus:@"同步成功"];
    }
    
}

/**
 恢复下载
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

/**
 下载完成调用

 @param location 写入本地临时路经（temp文件夹里面）
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    //获取服务器的文件名
//    NSString *fileName = downloadTask.response.suggestedFilename;
//    //创建需要保存在本地的文件路径
//    NSString *filePath = [caches stringByAppendingPathComponent:fileName];
//    //将下载的文件剪切到上面的路径
//    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    
    NSString *yuanLaiPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
          if ([WHTongBuViewController fileExistsAtPath:yuanLaiPath isDirectory:NO]) {
              [WHTongBuViewController removeItemAtPath:yuanLaiPath];
              
              
               
                  NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                  NSString *docPath = [pathArr firstObject];
           
              
                    //获取服务器的文件名
                    NSString *fileName = @"userData/userData.db";
                    //创建需要保存在本地的文件路径
                    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
                    //将下载的文件剪切到上面的路径
                    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
              
//              [BCUserDeafaults setObject:self.qingvmatextField.text forKey:user_qinglvma];
//              [BCUserDeafaults synchronize];
              WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
              manager.isreload = YES;
              [self generatorOnClick];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self];
}

}

// 删除 文件or文件夹
+ (void)removeItemAtPath:(NSString *)path {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL result = [fileManager removeItemAtPath:path error:&error];
        if (!result && error) {
            NSLog(@"removeItem Err : %@", error.description);
        }
    }

    // 检查文件、文件夹是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(nullable BOOL *)isDir {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL exist = [fileManager fileExistsAtPath:path isDirectory:isDir];
        return exist;
    }


+ (void)URLFileSizeWidthURL:(NSString *)URL fileSize:(SizeBlock)fileSize{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL parameters:@{} headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = [(NSHTTPURLResponse *)task.response allHeaderFields];
               CGFloat length = [[dic objectForKey:@"Content-Length"] floatValue];// Content-Length单位是byte，除以1024后是KB
               NSString *size;
//               if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//                   size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//               }else{
//                   size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//               }
        size = [NSString stringWithFormat:@"%f",length];

               if (fileSize) {
                   fileSize(size);
               }
    }];
    
//    [manager GET:URL parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSDictionary *dic = [(NSHTTPURLResponse *)task.response allHeaderFields];
//        CGFloat length = [[dic objectForKey:@"Content-Length"] floatValue];// Content-Length单位是byte，除以1024后是KB
//        NSString *size;
//        if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
//            size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
//        }else{
//            size = [NSString stringWithFormat:@"%.1fKB",length/1024];
//        }
//        if (fileSize) {
//            fileSize(size);
//        }
//    }];
}



- (NSString *)getBenDiLength{
    // 判断是否已经离线下载了
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userData/userData.db"];
    [self getFileInfoByFilePath:filePath WithBlock:^(long long fileSize, NSDate *modificationtime, NSError *error) {
        CGFloat length = fileSize;// Content-Length单位是byte，除以1024后是KB
                      NSString *size;
                      if (length >= 1048576) {//1048576bt = 1M  小于1m的显示KB 大于1m显示M
                          size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
                      }else{
                          size = [NSString stringWithFormat:@"%.1fKB",length/1024];
                      }

        NSLog(@"=本地文件大小=======%@",size);
    }];
    
    return nil;
}

+ (void)getFileInfoByFilePath:(NSString *)filePath WithBlock:(void(^)(long long fileSize, NSDate *modificationtime, NSError *error))block
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate]; // 最近一次的修改时间

        if (block) {
            block([fileSize unsignedLongLongValue], fileModDate, nil);
        }
    } else {
        if (block) {
            block(0, nil, [NSError errorWithDomain:@"文件路径出错" code:100 userInfo:nil]);
        }
    }
}

- (void)getFileInfoByFilePath:(NSString *)filePath WithBlock:(void(^)(long long fileSize, NSDate *modificationtime, NSError *error))block
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate]; // 最近一次的修改时间

        if (block) {
            block([fileSize unsignedLongLongValue], fileModDate, nil);
        }
    } else {
        if (block) {
            block(0, nil, [NSError errorWithDomain:@"文件路径出错" code:100 userInfo:nil]);
        }
    }
}


- (void)generatorOnClick {
    // 0.导入头文件
    
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    NSString *dataString = self.qingvmatextField.text;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    //    self.qrcodeImv.image = [UIImage imageWithCIImage:outputImage];
    // 显示放大后清晰的二维码图片
    self.erWeiMaImageView.hidden = NO;
    self.erWeiMaBackView.hidden = NO;
    self.erWeiMaImageViewLayer.hidden = NO;
   self.erWeiMaImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:220];
//    self.qrcodeImv.image = [self qrcode:[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:120] centerLogo:[UIImage imageNamed:@"xingxing_change"]];
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIImage *)qrcode:(UIImage *)qrcode centerLogo:(UIImage *)logo {
    UIGraphicsBeginImageContext(qrcode.size);
    [qrcode drawInRect:CGRectMake(0, 0, qrcode.size.width, qrcode.size.height)];
    [logo drawInRect:CGRectMake((qrcode.size.width - logo.size.width) * 0.5, (qrcode.size.height - logo.size.height) * 0.5, logo.size.width, logo.size.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (void)shareImage{
    
    NSString *text = @"扫描情侣码，分享爱情";
    UIImageView * shareImageView = [[UIImageView alloc]init];
   
    
    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenWidth)];
    UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), kAUTOWIDTH(0), ScreenWidth - kAUTOWIDTH(0), ScreenWidth)];
    cardImageView.image = [self convertImageViewToImage:self.cardFatherView];
    [codeImageView addSubview:cardImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  kAUTOWIDTH(240), ScreenWidth, kAUTOWIDTH(30))];
    nameLabel.text = @"扫码同步爱情";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = PNCColorWithHex(0x1e1e1e);
    nameLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
    [codeImageView addSubview:nameLabel];
    
    shareImageView.image = [self convertImageViewToImage:codeImageView];
    
    NSArray *activityItems = @[text,shareImageView.image];
    
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

-(UIImage*)convertImageViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
