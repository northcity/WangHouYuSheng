//
//  WSMainViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "WSMainViewController.h"

#import<AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "CardAnimationCell.h"
#import <StoreKit/StoreKit.h>

@interface WSMainViewController () <CardScrollDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger Index;

@property (nonatomic ,strong)  UIView *buttonView;
@end

@implementation WSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self buildUI];
    
    
//    NSLog(@"%@",array);
    [self createTipsView];
}

- (void)createTipsView{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstAlertDanMu"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAlertDanMu"];
        UIView *tipsView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:tipsView];
        tipsView.tag = 105;
        tipsView.backgroundColor = PNCColorRGBA(0, 0, 0, 0.6);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        label.center = tipsView.center;
        label.textAlignment = NSTextAlignmentCenter;
        [tipsView addSubview:label];
        label.text = @"1.点击选择【往后】图片。\n2.或者上滑然后点击图片区域进入编写页面。\n3.首页不可编辑文字。";
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 3;
        label.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:15];
        
        UIImageView *xiaLaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 15, CGRectGetMaxY(label.frame) + 10, 30,30)];
        [tipsView addSubview:xiaLaImageView];
        xiaLaImageView.image = [UIImage imageNamed:@"shanghua"];
        
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTipsView)];
        [tipsView addGestureRecognizer:tap];
    }
}

- (void)removeTipsView{
    UIView *view = [self.view viewWithTag:105];
    [view removeFromSuperview];
}


-(void)initData{
    self.dataSourceArray =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSourceArray= array.mutableCopy;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


- (void)initOtherUI{};
- (void)buildUI {

    self.title = @"卡片";
    if(!self.cardScrollViewer){
    self.cardScrollViewer = [[CardScrollViewer alloc] initWithFrame:CGRectMake(0, 22, ScreenWidth, ScreenHeight +22)];
        if (PNCisIPHONEX) {
            self.cardScrollViewer.frame = CGRectMake(0, 88, ScreenWidth, ScreenHeight -PCTopBarHeight);
        }
    self.cardScrollViewer.delegate = self;
    [self.view addSubview:self.cardScrollViewer];
    }
    LZWeakSelf(weakSelf);
    self.cardScrollViewer.tapBlock = ^(NSInteger currentIndex) {
        NSLog(@"-=======%ld",currentIndex);
        weakSelf.Index = currentIndex;
        [weakSelf selectedXiangCeImage];
    };
}

- (void)selectedXiangCeImage{
    
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //判断数据来源为相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        //设置代理
        picker.delegate = self;
        //打开相册
    
    if (PNCisIPAD) {
        UIPopoverController *pop=[[UIPopoverController alloc]initWithContentViewController:picker];
        //    [self presentViewController:imagePicker animated:YES completion:NULL];
        [pop presentPopoverFromRect:CGRectMake(ScreenWidth/2 - 150, ScreenHeight/2 - 150, 200, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }else{
        [self presentViewController:picker animated:YES completion:nil];

    }
    
}

#pragma mark ========== 图片代理回调 ===========
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    self.topImageView.image = image;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.Index inSection:0];
    CardAnimationCell *swipeCell = (CardAnimationCell *)[self.cardScrollViewer.collectionView cellForItemAtIndexPath:indexPath];
    swipeCell.coverImage.image = image;

    if (PNCisIPAD) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self saveToDbWithImage:image];
//        });
    }else{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveToDbWithImage:image];
        //通知主线程刷新
        [self.cardScrollViewer setCollViewBackImageViewImage];

    });
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

//弹出星星评论
+ (void)showAppStoreReView{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    if ([systemVersion doubleValue] > 10.3) {
        if (@available(iOS 10.3, *)) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                //防止键盘遮挡
//                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
            }
        }
    }
}

- (void)saveToDbWithImage:(UIImage *)image{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstDianZan"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstDianZan"];
//        [WSMainViewController showAppStoreReView];
    }
    
    
    LZDataModel *model = self.dataSourceArray[self.Index];
    
    NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
    
    model.urlString = @"isDone";
    model.pcmData = imageBackDataString;
    NSLog(@"%@",model);
    
    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    [SVProgressHUD showInfoWithStatus:@"更新成功"];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:self.cardScrollViewer.collectionView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
            [self.cardScrollViewer.collectionView reloadData];
        }  completion: ^(BOOL isFinished) {
            
        }];
        [self.cardScrollViewer loadData];
        
    });
   
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSLog(@"array");
}

#pragma mark -CardScrollViewerDelegate
- (void)CardScrollViewerDidSelectAtIndex:(NSInteger)index {
    NSLog(@"点击了 %ld", index);
    self.currentIndex = index;
//    [_cardScrollViewer swipeDown:nil];
    if (_pushBlock) {
        _pushBlock(index);
    }
//    SecondViewController * secondVC = [[SecondViewController alloc] init];
//    secondVC.index = index;

//    UINavigationController *newNav = [[UINavigationController alloc]initWithRootViewController:self];
//    newNav.delegate = self;
//    [newNav pushViewController:secondVC animated:YES];
//
    if ([self.delegate respondsToSelector:@selector(CardScrollViewerDidSelectAtIndex:)]) {
        [self.delegate CardScrollViewerDidSelectAtIndex:self.currentIndex];
    }

    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
