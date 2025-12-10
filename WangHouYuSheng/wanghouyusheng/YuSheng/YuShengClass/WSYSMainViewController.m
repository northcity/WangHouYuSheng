//
//  WSYSMainViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "WSYSMainViewController.h"
#import "CardAnimationCell.h"
#import "SettingViewController.h"
#import "IATConfig.h"

@interface WSYSMainViewController ()<UIScrollViewDelegate,CardScrollDelegate, UINavigationControllerDelegate,WSMainViewDelegate>

@property (nonatomic, strong) UILabel *wangHouLabl;
@property (nonatomic, strong) UILabel *YuShengLabl;
@property (nonatomic, strong) UIView *cutView;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation WSYSMainViewController

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_ysVC audioStop];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    IATConfig *config = [IATConfig sharedInstance];
    config.icoloudShiJianChuo = [WSYSMainViewController getNowTimeTimestamp];
    
    [self createMainScrollView];
    [self createNav];

    
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setBtn setImage:[UIImage imageNamed:@"设置.png"] forState:UIControlStateNormal];
    [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.setBtn.frame = CGRectMake(15, 25, 30, 30);
//    self.setBtn.layer.masksToBounds = YES;
//    self.setBtn.layer.cornerRadius = 25;
    [self.view addSubview:self.setBtn];
    [self.setBtn addTarget:self action:@selector(pushSettingViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:_setBtn];
    _setBtn.alpha = 0;
    if (PNCisIPHONEX) {
        self.setBtn.frame = CGRectMake(15, 47, 30, 30);
    }
//    _setBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setImage:[UIImage imageNamed:@"分享图片"] forState:UIControlStateNormal];
//    [self.shareBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.shareBtn.frame = CGRectMake(ScreenWidth - 40, 25, 25, 25);
//    self.shareBtn.layer.masksToBounds = YES;
//    self.shareBtn.layer.cornerRadius = 25;
    [self.view addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:_shareBtn];
    _shareBtn.alpha = 0;
    if (PNCisIPHONEX) {
        self.shareBtn.frame = CGRectMake(ScreenWidth -40, 47, 25, 25);
    }
//    _shareBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NSNotificationCenter) name:@"RELOAD" object:nil];
}

- (void)NSNotificationCenter{
//    [_wsVC.cardScrollViewer removeFromSuperview];
//    _wsVC.cardScrollViewer = nil;
//    [_wsVC initData];
//    [_wsVC buildUI];
//    [_wsVC.view addSubview:_wsVC.cardScrollViewer];
    
    [_whNewVc loadDate];
    [_wsVC.cardScrollViewer loadData];
    [UIView transitionWithView:_wsVC.cardScrollViewer.collectionView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        [_wsVC.cardScrollViewer.collectionView reloadData];
    }  completion: ^(BOOL isFinished) {
        
    }];
}
- (void)pushSettingViewController:(UIButton *)sender{
    [BCShanNianKaPianManager maDaQingZhenDong];
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
    } completion:nil];
    SettingViewController *svc = [[SettingViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
    //    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [_wsVC.cardScrollViewer.collectionView reloadData];
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_wsVC.currentIndex inSection:0];
//    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
//
//    
//    CardAnimationCell *swipeCell = (CardAnimationCell *)[self.wsVC.cardScrollViewer.collectionView cellForItemAtIndexPath:indexPath];
//
//    [_wsVC.cardScrollViewer.collectionView reloadItemsAtIndexPaths:indexPathArray];
//    [_wsVC.cardScrollViewer swipeDown: nil];
    
    if (self.mainScrollView.contentOffset.x == ScreenWidth) {
        NSString *isHaveVoice = [BCUserDeafaults objectForKey:current_XIANSHILIEBIAO];
        if ([isHaveVoice isEqualToString:@"1"]) {
            [_ysVC audioPlay];
        }else if([isHaveVoice isEqualToString:@"0"]){
            [_ysVC audioStop];
        }else{
            [_ysVC audioPlay];
        }
    }else{
        [_ysVC audioStop];
    }
}

- (void)createMainScrollView{
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(2 * ScreenWidth, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mainScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
//    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.view insertSubview:self.mainScrollView atIndex:0];
    
    _ysVC = [[YSMainTimeViewController alloc]init];
    _ysVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [self.mainScrollView addSubview:_ysVC.view];
    
    
    _whNewVc = [[WHNewViewController alloc]init];
    _whNewVc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
       [self.mainScrollView addSubview:_whNewVc.view];
//    _wsVC = [[WSMainViewController alloc]init];
//    _wsVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [self.mainScrollView addSubview:_wsVC.view];
   
//    _wsVC.delegate = self;
    
    
    LZWeakSelf(weakSelf);


    _wsVC.pushBlock = ^(NSInteger currentIndex) {

        SecondViewController *secondVC = [[SecondViewController alloc] init];
            secondVC.pushFlag = @"1";
            secondVC.index = currentIndex;
            self.navigationController.delegate = secondVC;
        
        secondVC.backBlock = ^(NSInteger index) {
            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            NSLog(@"向上滑动了第%ld个item", indexPath.row);
//
//
//            CardAnimationCell *swipeCell = (CardAnimationCell *)[weakSelf.wsVC.cardScrollViewer.collectionView cellForItemAtIndexPath:indexPath];
//
//            NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
//            LZDataModel *model = array[index];
//            [swipeCell loadDateWithModel :model];
//
//            NSArray *array = [NSArray arrayWithObject:indexPath];
            [weakSelf.wsVC.cardScrollViewer loadData];
            [weakSelf.wsVC.cardScrollViewer removeFromSuperview];
            weakSelf.wsVC.cardScrollViewer = nil;
            [weakSelf.wsVC buildUI];

//            [self layoutIfNeeded];
            [weakSelf.wsVC.cardScrollViewer.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

            weakSelf.wsVC.cardScrollViewer.currentIndex = index;
            
            [weakSelf.wsVC.cardScrollViewer setCollViewBackImageViewImage]; 
//            [swipeCell removeGestureRecognizer:weakSelf.wsVC.cardScrollViewer.down];
//            [weakSelf.wsVC.cardScrollViewer.collectionView addGestureRecognizer:weakSelf.wsVC.cardScrollViewer.up];
//            [swipeCell reloadInputViews];
          
        };
            [weakSelf.navigationController pushViewController:secondVC animated:NO];
    };
}

//- (void)CardScrollViewerDidSelectAtIndex:(NSInteger)index{
//        NSLog(@"点击了 %ld", index);
//        SecondViewController * secondVC = [[SecondViewController alloc] init];
//        secondVC.index = index;
//
////        UINavigationController *newNav = [[UINavigationController alloc]initWithRootViewController:self.wsVC];
////        newNav.delegate = self;
////        [newNav pushViewController:secondVC animated:YES];
//
//        self.navigationController.delegate = self;
//        [self.navigationController pushViewController:secondVC animated:YES];
//}
- (void)createNav{
    _YuShengLabl = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + kAUTOWIDTH(15) , kAUTOHEIGHT(5), kAUTOWIDTH(80), kAUTOHEIGHT(66))];
    _YuShengLabl.text = @"余生";
    _YuShengLabl.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:18];
    _YuShengLabl.textColor = [UIColor blackColor];
    _YuShengLabl.textAlignment = NSTextAlignmentLeft;
    [self.titleView addSubview:_YuShengLabl];
    
    _wangHouLabl = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(95), kAUTOHEIGHT(5), kAUTOWIDTH(80), kAUTOHEIGHT(66))];
    _wangHouLabl.text = @"往后";
    _wangHouLabl.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:18];
    _wangHouLabl.textColor = [UIColor blackColor];
    _wangHouLabl.textAlignment = NSTextAlignmentRight;
    [self.titleView addSubview:_wangHouLabl];
    
    
    
    _cutView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 0.25, self.titleView.frame.size.height/2 - 7.5 + 10, 0.5,15)];
    _cutView.backgroundColor = PNCColor(132,133,135);
    [self.titleView addSubview:_cutView];
    
    if (PNCisIPHONEX) {
        _wangHouLabl.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(95), 29, kAUTOWIDTH(80), kAUTOHEIGHT(66));
        _YuShengLabl.frame = CGRectMake(ScreenWidth/2 + kAUTOWIDTH(15) , 29, kAUTOWIDTH(80), kAUTOHEIGHT(66));
        _cutView.frame = CGRectMake(ScreenWidth/2 - 0.25, self.titleView.frame.size.height/2 - 7.5 + 18, 0.5,15);

    }
    UITapGestureRecognizer *tapWangHou = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wangHouSelected)];
    [_wangHouLabl addGestureRecognizer:tapWangHou];
    
    _wangHouLabl.userInteractionEnabled = YES;
    _YuShengLabl.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapYuSheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yuShengSelected)];
    [_YuShengLabl addGestureRecognizer:tapYuSheng];
    
    _wangHouLabl.transform = CGAffineTransformMakeScale(1.2, 1.2);

}

- (void)wangHouSelected{
    
    [UIView animateWithDuration:0.3 animations:^{
//        _setBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
        _setBtn.alpha = 0;
        _shareBtn.alpha = 0;
    }];
    
    [self.mainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    

    [UIView animateWithDuration:0.3 animations:^{
//        _wangHouLabl.transform = CGAffineTransformMakeScale(1.2, 1.2);
//        _YuShengLabl.transform = CGAffineTransformMakeScale(1, 1);
        
    }];
    
}
- (void)yuShengSelected{
    
    [UIView animateWithDuration:0.3 animations:^{
//        _setBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
        _setBtn.alpha = 1;
        _shareBtn.alpha = 1;
    }];
    
    [self.mainScrollView setContentOffset:CGPointMake(ScreenWidth,0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
//        _wangHouLabl.transform = CGAffineTransformMakeScale(1, 1);
//        _YuShengLabl.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSLog(@"%f",offsetX);
    
    if (offsetX >= 0 && offsetX <= ScreenWidth) {
        CGFloat progress = 0.2 * (offsetX/ScreenWidth);
        CGFloat scaleGold = 1- progress *(1.2 - 1);
        
        _wangHouLabl.transform = CGAffineTransformMakeScale(1.2 - progress, 1.2 - progress);
        _YuShengLabl.transform = CGAffineTransformMakeScale(1+ progress, 1 + progress);
   
        _setBtn.alpha = offsetX/ScreenWidth;
    _shareBtn.alpha = offsetX/ScreenWidth;
        
    }else{
    }
    
    if (offsetX == ScreenWidth) {
        NSString *isHaveVoice = [BCUserDeafaults objectForKey:current_XIANSHILIEBIAO];
        if ([isHaveVoice isEqualToString:@"1"]) {
            [_ysVC audioPlay];
        }else if([isHaveVoice isEqualToString:@"0"]){
            [_ysVC audioStop];
        }else{
            [_ysVC audioPlay];
        }
    }else{
        [_ysVC audioStop];
    }
}


//#pragma mark -CardScrollViewerDelegate
//- (void)CardScrollViewerDidSelectAtIndex:(NSInteger)index {
//    NSLog(@"点击了 %ld", index);
//    self.wsVC.currentIndex = index;
//
//    SecondViewController *secondVC = [[SecondViewController alloc] init];
//    secondVC.index = index;
//    self.navigationController.delegate = secondVC;
//    [self.navigationController pushViewController:secondVC animated:YES];
//}

- (void)shareImage{
    
    NSString *text = @"分享内容";
    NSString *imageName = @"QQ20180311-1.jpg";

    UIImageView * shareImageView = [[UIImageView alloc]init];
    shareImageView.image = [self convertImageViewToImage:self.view];
    
    
    
    
    
    
    //    UIImageView *imageView2 = [[UIImageView alloc]init];
    //    imageView2.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //    [imageView2 addSubview:imageView1];
    //
    //    UIImageView  *iconImage3 = [[UIImageView alloc]init];
    //    iconImage3.frame = CGRectMake(20, ScreenHeight - 100, 60, 60);
    //    iconImage3.image = [UIImage imageNamed:@"shareicon.jpeg"];
    //    [imageView2 addSubview:iconImage3];
    //
    //
    //    UILabel *label = [Factory createLabelWithTitle:@"时间胶囊" frame:CGRectMake(20, ScreenHeight - 40, 60, 20)];
    //    label.font = [UIFont fontWithName:@"Heiti SC" size:9];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    [imageView2 addSubview:label];
    //
    //    imageView2.backgroundColor = [UIColor whiteColor];
    //    UIImage *zuihouImage = [self convertImageViewToImage:imageView2];
    
    
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

- (void)backAction{
    
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
