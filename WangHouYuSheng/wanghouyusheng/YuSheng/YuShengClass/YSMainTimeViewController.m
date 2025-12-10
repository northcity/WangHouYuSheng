//
//  YSMainTimeViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "YSMainTimeViewController.h"
#import "XLClock.h"
#import "DatePickerView.h"
#import "MSNumberScrollAnimatedView.h"
#import "LZiCloud.h"
#import "SettingViewController.h"
#import <SKGuideView.h>
#import <AVFoundation/AVFoundation.h>
#import <StoreKit/StoreKit.h>

@interface YSMainTimeViewController ()<AVAudioPlayerDelegate,DatePickerViewDelegate,UIScrollViewDelegate>{
    XLClock *_clock;
    UIView * _backWindowView;
}
@property (nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic,strong) DatePickerView * pikerView;
@property (nonatomic, strong) UIButton * xuanZeRiQiBtn;
@property (nonatomic, strong) UIButton * xuanZeShengRiBtn;

@property(nonatomic,copy)NSString * selectValue;
@property(nonatomic,copy)NSString * selectShengRiValue;

@property (nonatomic, strong) MSNumberScrollAnimatedView *nianView;

@property (nonatomic, strong) UILabel *wangHouLabl;
@property (nonatomic, strong) UILabel *YuShengLabl;
@property (nonatomic, strong) UIView *cutView;
@property (nonatomic,strong) UILabel *shengYuShiJianLabel;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation YSMainTimeViewController

- (void)tongBuiCloud{
    
    NSString *path = [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    NSLog(@"我是路径 === %@",path);
    [LZiCloud uploadToiCloud:path resultBlock:^(NSError *error) {
        if (error == nil) {
            //                        [SVProgressHUD showInfoWithStatus:@"同步成功"];
            
        } else {
            
            //                        [SVProgressHUD showErrorWithStatus:@"同步出错"];
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *selectedString = [BCUserDeafaults objectForKey:@"ISCLOCK"];
    NSString *isHaveVoice = [BCUserDeafaults objectForKey:current_XIANSHILIEBIAO];

    self.shareBtn = [UIButton buttonWithType: UIButtonTypeCustom];
           self.shareBtn.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(15),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(30), kAUTOWIDTH(30), kAUTOHEIGHT(30));
           [self.shareBtn setImage:[UIImage imageNamed:@"分享图片"] forState:UIControlStateNormal];
           [self.view addSubview:self.shareBtn];
           [self.shareBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    
    if (selectedString.length > 0) {
        [self ShowClock];
        [_clock showStartAnimation];
        if ([isHaveVoice isEqualToString:@"1"]) {
            [self playbackAudio];
        }else if([isHaveVoice isEqualToString:@"0"]){
        
        }else{
            [self playbackAudio];
        }
        self.selectValue = selectedString;
        [self dateAllReadySelect];
        
       
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstguide"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstguide"];
//            [self guide];
        }
//        [self guide];

        
    }else{
        if ([isHaveVoice isEqualToString:@"1"]) {
            [self playbackAudio];
        }else if([isHaveVoice isEqualToString:@"0"]){
        
        }else{
            [self playbackAudio];
        }
        [self ShowClock];
        [_clock showStartAnimation];
        [self createUI];
    }
    [self initOtherUI];
    
    
}

-(void)guide{
    [SKGuideView share].dataArr = @[@[self.nianView],
                                    @[@"点击重新选择日期"]];
}


- (void)shareImage{
    
    NSString *text = @"往后余生";
    UIImageView * shareImageView = [[UIImageView alloc]init];
    
    self.rightBtn.hidden = YES;
    self.backBtn.hidden = YES;
    self.shareBtn.hidden = YES;
    
    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(40),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(95), kAUTOWIDTH(80), kAUTOWIDTH(80))];
    codeImageView.image = [UIImage imageNamed:@"二维码图片_3月25日22时29分41秒"];
    [self.view addSubview:codeImageView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(codeImageView.frame) + kAUTOWIDTH(5), ScreenWidth, kAUTOWIDTH(30))];
    nameLabel.text = @"往后余生";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(18)];
    [self.view addSubview:nameLabel];
    
    
    
    shareImageView.image = [self convertImageViewToImage:self.view];
    
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
        
        self.rightBtn.hidden = NO;
        self.backBtn.hidden = NO;
        self.shareBtn.hidden = NO;
        [nameLabel removeFromSuperview];
        [codeImageView removeFromSuperview];
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


- (void)ShowClock{
    if (PNCisIPAD) {
        _clock = [[XLClock alloc] initWithFrame:CGRectMake(0, 0, (180), (180))];
    }else{
        _clock = [[XLClock alloc] initWithFrame:CGRectMake(0, 0, kAUTOWIDTH(180), kAUTOWIDTH(180))];

    }
    _clock.center = self.view.center;
    [self.view addSubview:_clock];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleView.backgroundColor = PNCColorWithHex(0xF75E73);;
    self.view.backgroundColor = PNCColorWithHex(0xF75E73);
    self.navTitleLabel.text = @"余生";
    self.navTitleLabel.font = PNCisIPAD ? [UIFont fontWithName:@"TpldKhangXiDictTrial" size:(16)] : [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(16)];
    self.navTitleLabel.textColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"关闭bai"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"首页 蓝2"] forState:UIControlStateNormal];
    
     if (PNCisIPAD) {
           self.rightBtn.frame = CGRectMake(ScreenWidth - (40), (47), (30),  (30));
           self.backBtn.frame = CGRectMake((15), (47), (30),  (30));
           self.navTitleLabel.frame = CGRectMake(ScreenWidth/2 - (75), (43), (150), (30));

       }
//    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.hidden = YES;
    [self audioPlay];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self audioStop];
}

- (void)rightBtnClick:(UIButton *)sender{
//        [BCShanNianKaPianManager maDaQingZhenDong];
//        sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
//        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
//        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
//            sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
//        } completion:nil];
//        SettingViewController *svc = [[SettingViewController alloc]init];
////        svc.modalPresentationStyle = UIModalPresentationFullScreen;
////        [self presentViewController:svc animated:YES completion:nil];
////    self.navigationController
////    [self.navigationController pushViewController:svc animated:YES];
//
//    [self presentViewController:svc animated:YES completion:nil];
}

- (void)showAppStoreReView{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    
    if ([systemVersion doubleValue] > 10.3) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
}

- (void)backAction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showAppStoreReView];
    });
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playbackAudio{
    NSError *err;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"10010" withExtension:@"mp3"];
    //    初始化播放器
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
//    self.volum.value = 0.5;
    //    设置播放器声音
    _player.volume = 1;
    //    设置代理
    _player.delegate = self;
    //    设置播放速率
    _player.rate = 1.0;
    //    设置播放次数 负数代表无限循环
    _player.numberOfLoops = -1;
    //    准备播放
    [_player prepareToPlay];
//    self.progress.progress = 0;
//    self.progressSlide.value = 0;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
//
}

- (void)audioPlay{
    [_player play];
}
-(void)audioStop{
    if (_player.isPlaying) {
        [_player pause];
    }
}

- (void)createUI{
    
    self.xuanZeRiQiBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.xuanZeRiQiBtn.frame = CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_clock.frame) + kAUTOHEIGHT(50), ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(44));
    [self.xuanZeRiQiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.xuanZeRiQiBtn setTitle:@"和您的Ta开始在一起的日子" forState:UIControlStateNormal];
    self.xuanZeRiQiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
    [self.view addSubview:self.xuanZeRiQiBtn];
    [self.xuanZeRiQiBtn addTarget:self action:@selector(datePickShow) forControlEvents:UIControlEventTouchUpInside];
    
    self.xuanZeShengRiBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.xuanZeShengRiBtn.frame = CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(self.xuanZeRiQiBtn.frame) + kAUTOHEIGHT(50), ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(44));
    [self.xuanZeShengRiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.xuanZeShengRiBtn setTitle:@"您的生日" forState:UIControlStateNormal];
    self.xuanZeShengRiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
//    [self.view addSubview:self.xuanZeShengRiBtn];
    [self.xuanZeShengRiBtn addTarget:self action:@selector(datePickShow) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)datePickShow{
    [BCShanNianKaPianManager maDaQingZhenDong];
    if(_pikerView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [[UIApplication sharedApplication].keyWindow addSubview:_backWindowView];
        _backWindowView.backgroundColor = [UIColor blackColor];
        
        _pikerView = [DatePickerView datePickerView];
        _pikerView.frame= CGRectMake(0, ScreenHeight, ScreenWidth, 257);
        _backWindowView.alpha = 0.5;
        _pikerView.delegate = self;
        _pikerView.type = 1;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
       
        NSDateComponents *comps1 = [[NSDateComponents alloc] init];
        [comps1 setDay:0];//设置最大时间为：当前时间推后十年
        NSDate *maxDate = [calendar dateByAddingComponents:comps1 toDate:currentDate options:0];
       
        NSDateComponents *comps2 = [[NSDateComponents alloc] init];
        [comps2 setYear:-100];//设置最大时间为：当前时间推后十年
        NSDate *minDate = [calendar dateByAddingComponents:comps2 toDate:currentDate options:0];
        _pikerView.datePickerView.minimumDate = minDate;
        _pikerView.datePickerView.maximumDate = maxDate;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pikerView];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _pikerView.frame = CGRectMake(0, ScreenHeight-257, ScreenWidth, 257);
        } completion:nil];
        
//        if ([button isEqual:self.xuanZeRiQiBtn]) {
            [_pikerView.sureBtn addTarget:self action:@selector(dataPickViewSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];

//        }else{
//            [_pikerView.sureBtn addTarget:self action:@selector(dataPickShengRiViewSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//
//        }
        
        [_pikerView.cannelBtn addTarget:self action:@selector(dataPickViewCancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257);
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
        } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
        }];
        
    }
}

- (void)dataPickViewSureBtnClicked{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _selectValue = [dateFormatter stringFromDate:self.pikerView.datePickerView.date];
    NSLog(@"确定 = %@",_selectValue);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257);
    } completion:^(BOOL finished) {
        [self dateAllReadySelect];
    }];
}

- (void)dataPickShengRiViewSureBtnClicked{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _selectShengRiValue = [dateFormatter stringFromDate:self.pikerView.datePickerView.date];
    NSLog(@"确定 = %@",_selectValue);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257);
    } completion:^(BOOL finished) {
        [self dateAllReadySelect];
    }];
}

-(NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localDate = [now  dateByAddingTimeInterval: interval];
    endTime = [NSString stringWithFormat:@"%@", endTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
    NSDate *end = [endDate dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = ([localDate timeIntervalSinceDate:end]) / 3600 / 24;
    
    NSString *timeStr = [NSString stringWithFormat:@"%lu", (unsigned long)voteCountTime];
    
    return timeStr;
}

- (void)dateAllReadySelect{
    
    [BCUserDeafaults setObject:self.selectValue forKey:@"ISCLOCK"];
    [BCUserDeafaults synchronize];
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:100 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        _clock.frame = PNCisIPAD ? CGRectMake(ScreenWidth/2 - 90, PCTopBarHeight + kAUTOHEIGHT(50), (180), (180)) : CGRectMake(ScreenWidth/2 - kAUTOWIDTH(90), PCTopBarHeight + kAUTOHEIGHT(50), kAUTOWIDTH(180), kAUTOWIDTH(180));
        _xuanZeRiQiBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [_xuanZeRiQiBtn removeFromSuperview];
    }];
    
    UILabel *yuShenglabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_clock.frame) + kAUTOHEIGHT(30), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(44))];
    if (PNCisIPAD) {
        yuShenglabel.frame = CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_clock.frame) + kAUTOWIDTH(30), ScreenWidth - kAUTOWIDTH(60), (44));

    }
    yuShenglabel.textColor = [UIColor whiteColor];
    yuShenglabel.font = PNCisIPAD ?  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:(17)] : [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(17)];
    yuShenglabel.textAlignment = NSTextAlignmentCenter;
    yuShenglabel.text =  @"我们已经在一起了";
    [self.view addSubview:yuShenglabel];
    
    if (!_nianView) {
        _nianView = [[MSNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(60), CGRectGetMaxY(yuShenglabel.frame) + kAUTOHEIGHT(5), kAUTOWIDTH(120), 44)];
        
        if (PNCisIPAD) {
            _nianView.frame =CGRectMake(ScreenWidth/2 - kAUTOWIDTH(60), CGRectGetMaxY(yuShenglabel.frame) + kAUTOHEIGHT(5), kAUTOWIDTH(120), 44);

        }
        
        [self.view addSubview:_nianView];
    }
    _nianView.font = PNCisIPAD ?  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(38)] : [UIFont fontWithName:@"HelveticaNeue-Bold" size:kAUTOWIDTH(28)];
    _nianView.textColor =[UIColor whiteColor];
    _nianView.minLength = 1;
    _nianView.density = 200;
    NSLog(@"=============%@",[self getCountDownStringWithEndTime:_selectValue]);
    _nianView.number = [NSNumber numberWithInteger:[[self getCountDownStringWithEndTime:_selectValue] integerValue]];
    [_nianView startAnimation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickShow)];
    [_nianView addGestureRecognizer:tap];
    
    UILabel *tianLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_nianView.frame) + kAUTOHEIGHT(5), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(44))];
    
    if (PNCisIPAD) {
        tianLabel.frame = CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_nianView.frame) + kAUTOHEIGHT(5), ScreenWidth - kAUTOWIDTH(60), (44));

    }
    
    tianLabel.textColor = [UIColor whiteColor];
    tianLabel.font =  PNCisIPAD ?  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:(17)] : [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(17)];
    tianLabel.textAlignment = NSTextAlignmentCenter;
    tianLabel.text =  @"天";
    [self.view addSubview:tianLabel];
    
    if (!_shengYuShiJianLabel) {
        _shengYuShiJianLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(tianLabel.frame) + kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(120))];
        
        if (PNCisIPAD) {
            _shengYuShiJianLabel.frame = CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(tianLabel.frame) + kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(60), kAUTOWIDTH(120));
                   
        }
    }
    _shengYuShiJianLabel.textColor = [UIColor whiteColor];
    _shengYuShiJianLabel.font = PNCisIPAD ? [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:(15)] : [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(14)];
    _shengYuShiJianLabel.textAlignment = NSTextAlignmentCenter;
   
    
    NSString *chaString = [self dealTime];
    
    NSInteger nianInteger = [[[chaString componentsSeparatedByString:@"-"] firstObject] integerValue];
    NSInteger yueInteger = [[[chaString componentsSeparatedByString:@"-"] lastObject] integerValue];

    NSInteger luoRi= 365 * nianInteger/2  + yueInteger *30;
    NSInteger youXi = nianInteger * 12;
    NSInteger paoBu = nianInteger * 2 + yueInteger*1;
    _shengYuShiJianLabel.numberOfLines = 0;
    _shengYuShiJianLabel.text =  [NSString stringWithFormat:@"余生大概还能\n\n一起看%ld次夕阳\n\n一起看%lu场电影\n\n一起去%lu次远行",luoRi,youXi,paoBu];
//    [shengYuShiJianLabel sizeToFit];
    CGPoint center = self.view.center;
    [self.view addSubview:_shengYuShiJianLabel];
    
    
}

- (NSString *)dealTime{
    NSString *endTimeString = [NSString stringWithFormat:@"%ld",[[self.selectValue substringToIndex:4] integerValue] + 62];
    NSString *endTime = [NSString stringWithFormat:@"%@%@",endTimeString,[self.selectValue substringFromIndex:4]];
    NSString *chaString = [self pleaseInsertStarTimeo:[self getCurrentTimes] andInsertEndTime:endTime];
    
    return chaString;
}

- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString = %@",currentTimeString);
    return currentTimeString;
}


- (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
// 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
// 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
// 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
// 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    NSString *returnString = [NSString stringWithFormat:@"%ld-%ld",(long)cmps.year,(long)cmps.month];
    
    return returnString;
}


-(void)dataPickViewCancleBtnClicked{
    [_backWindowView removeFromSuperview];
    [self.pikerView removeFromSuperview];
    self.pikerView = nil;
    NSLog(@"取消");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
