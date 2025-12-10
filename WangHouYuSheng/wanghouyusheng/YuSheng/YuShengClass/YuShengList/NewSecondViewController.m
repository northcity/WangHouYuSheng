//
//  NewSecondViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/8.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "NewSecondViewController.h"
#import "ADCardTransition.h"
#import "ShowStarView.h"
#import<AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "DatePickerView.h"


#define SETVIEW_HEIGHT  kAUTOHEIGHT(142)



@interface NewSecondViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UIView * _backWindowView;
}
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextView *colorTextView;
@property (nonatomic, strong) UITextView *titleTextView;

@property (nonatomic,strong) UIView *setView;
@property (nonatomic,strong) UIView *whiteBackView;

@property(nonatomic,strong) DatePickerView * pikerView;
@property(nonatomic,copy)NSString * selectValue;

@end

@implementation NewSecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self buildUI];
//    self.view.backgroundColor = [UIColor redColor];
}

- (void)initData {
    
    self.dataSourceArray =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSourceArray= array.mutableCopy;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)buildUI {
    
    [self buildTableHeadView];
    
  
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"箭头111"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40), ScreenHeight - kAUTOHEIGHT(40), kAUTOWIDTH(25), kAUTOHEIGHT(25));
    
    UIButton *setBtn = [[UIButton alloc] init];
    [setBtn setImage:[UIImage imageNamed:@"更多111"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(createSetView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
    setBtn.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight - kAUTOHEIGHT(40), kAUTOWIDTH(25), kAUTOHEIGHT(25));
 
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        backBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40), ScreenHeight - kAUTOWIDTH(60), kAUTOWIDTH(20), kAUTOWIDTH(20));
        setBtn.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight - kAUTOWIDTH(60), kAUTOWIDTH(20), kAUTOWIDTH(20));
        
    }
    
}

- (void)removeSetView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:100 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        _whiteBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, SETVIEW_HEIGHT);
        _setView.alpha = 0;
    } completion:^(BOOL finished) {
        [_setView removeFromSuperview];
        _setView = nil;
    }];
}

- (void)createSetView{
    self.setView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.setView.backgroundColor = PNCColorWithHexA(0x000000, 0.2);
    [self.view addSubview:self.setView];
    self.setView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSetView)];
    [self.setView addGestureRecognizer:tap];
    
    _whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - SETVIEW_HEIGHT, ScreenWidth, SETVIEW_HEIGHT)];
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        _whiteBackView.frame = CGRectMake(0, ScreenHeight - SETVIEW_HEIGHT - 20, ScreenWidth, SETVIEW_HEIGHT + 20);
        
    }
    
    
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.setView addSubview:_whiteBackView];
    
    UIView *setView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SETVIEW_HEIGHT/3)];
    UIView *setView2 = [[UIView alloc]initWithFrame:CGRectMake(0, SETVIEW_HEIGHT/3, ScreenWidth, SETVIEW_HEIGHT/3)];
    UIView *setView3 = [[UIView alloc]initWithFrame:CGRectMake(0, SETVIEW_HEIGHT*2/3,ScreenWidth, SETVIEW_HEIGHT/3)];
    //
    //    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
    //       setView3.frame = CGRectMake(0, SETVIEW_HEIGHT*2/3,ScreenWidth, SETVIEW_HEIGHT/3+20);
    //
    //    }
    
    //    setView1.backgroundColor = [UIColor redColor];
    //    setView2.backgroundColor = [UIColor blueColor];
    //    setView3.backgroundColor = [UIColor orangeColor];
    
    [_whiteBackView addSubview:setView1];
    [_whiteBackView addSubview:setView2];
    [_whiteBackView addSubview:setView3];
    
    UIView *cutLineView1 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    UIView *cutLineView2 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 0.5)];
    cutLineView1.backgroundColor = PNCColorWithHex(0xdcdcdc);
    cutLineView2.backgroundColor = PNCColorWithHex(0xdcdcdc);
    [setView2 addSubview:cutLineView1];
    [setView3 addSubview:cutLineView2];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"目录1"]];
    imageView1.frame = CGRectMake(15, SETVIEW_HEIGHT/6 - 12.5, 25, 25);
    [setView1 addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"社交"]];
    imageView2.frame = CGRectMake(15, SETVIEW_HEIGHT/6 - 12.5, 25, 25);
    [setView2 addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"编辑1"]];
    imageView3.frame = CGRectMake(15, SETVIEW_HEIGHT/6 - 12.5, 25, 25);
    [setView3 addSubview:imageView3];
    
    UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(CGRectGetMaxX(imageView1.frame) , 0, 90, SETVIEW_HEIGHT/3);
    
    UIButton *button4 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(CGRectGetMaxX(button1.frame) , 0, 200, SETVIEW_HEIGHT/3);
    
    
    LZDataModel *model = self.dataSourceArray[self.index];
    
    if ([model.dsc isEqualToString:@"isLike"]) {
        button1.selected = YES;
    }else{
        button1.selected = NO;
    }
    
    [button1 setTitle:@"收藏" forState:UIControlStateNormal];
    [button1 setTitle:@"已收藏" forState:UIControlStateSelected];
    button1.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:14];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.titleLabel.textAlignment = NSTextAlignmentLeft;
    [setView1 addSubview:button1];
    [setView1 addSubview:button4];
    
    
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(CGRectGetMaxX(imageView2.frame) , 0, 90, SETVIEW_HEIGHT/3);
    [button2 setTitle:@"分享" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:14];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [setView2 addSubview:button2];
    
    UIButton *button5 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = CGRectMake(CGRectGetMaxX(button2.frame) , 0, 200, SETVIEW_HEIGHT/3);
    [setView2 addSubview:button5];
    
    
    UIButton *button3 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(CGRectGetMaxX(imageView3.frame) , 0, 90, SETVIEW_HEIGHT/3);
    [button3 setTitle:@"编写" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:14];
    [button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button3.titleLabel.textAlignment = NSTextAlignmentLeft;
    [setView3 addSubview:button3];
    
    UIButton *button6 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button6.frame = CGRectMake(CGRectGetMaxX(button3.frame) , 0, 200, SETVIEW_HEIGHT/3);
    [setView3 addSubview:button6];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:100 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        _setView.alpha = 1;
    } completion:nil];
    
    [button1 addTarget:self action:@selector(iLikeItWithSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(editContent) forControlEvents:UIControlEventTouchUpInside];
    
    [button4 addTarget:self action:@selector(iLikeItWithSelectedbutton1:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [button6 addTarget:self action:@selector(editContent) forControlEvents:UIControlEventTouchUpInside];
    
    
    button1.tag = 1002;
    
}

- (void)iLikeItWithSelected:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self saveIsLikeToDbWithString:@"isLike"];
    }else{
        [self saveIsLikeToDbWithString:@"noLike"];
    }
}

- (void)iLikeItWithSelectedbutton1:(UIButton *)button{
    
    UIButton *button1 = [_whiteBackView viewWithTag:1002];
    
    button1.selected = !button1.selected;
    if (button1.selected) {
        [self saveIsLikeToDbWithString:@"isLike"];
    }else{
        [self saveIsLikeToDbWithString:@"noLike"];
    }
}

- (void)saveIsLikeToDbWithString:(NSString *)likeString{
    
    LZDataModel *model = self.dataSourceArray[self.index];
    
    //    NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
    //    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
    //    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
    //
    
    model.dsc = likeString;
    NSLog(@"%@",model);
    
    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    [SVProgressHUD showInfoWithStatus:@"更新成功"];
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSLog(@"array");
}


- (void)shareImage{
    [self removeSetView];
    
    
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

- (void)editContent{
    [self removeSetView];
    [_contentTextView becomeFirstResponder];
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

- (void)buildTableHeadView {
    
    //顶部图片
    LZDataModel *model = self.dataSourceArray[self.index];
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    
    self.topImageView = [[UIImageView alloc] initWithImage:image];
    NSLog(@"===%@",[NSString stringWithFormat:@"%@.JPG",self.imageArray[self.index]]);
    
    self.topImageView.userInteractionEnabled = YES;
    
    self.topImageView.frame = CGRectMake(kAUTOWIDTH(62.5), kAUTOHEIGHT(134) - PCTopBarHeight, kAUTOWIDTH(250), kAUTOHEIGHT(350));
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        self.topImageView.frame = CGRectMake(kAUTOWIDTH(62.5), kAUTOHEIGHT(206) - PCTopBarHeight, kAUTOWIDTH(250), kAUTOHEIGHT(350));
    }
    
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = YES;
    [self.view addSubview:self.topImageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:100 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            self.topImageView.frame =CGRectMake(0, 0, ScreenWidth, [self Suit:300]);
            
            if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
                self.topImageView.frame =CGRectMake(0, 0, ScreenWidth, 400);
                
            }
            
        } completion:nil];
        
        //        [UIView animateWithDuration:0.5 animations:^{
        //            self.topImageView.frame =CGRectMake(0, 0, ScreenWidth, [self Suit:300]);
        //        }];
    });
    
    if ([_pushFlag isEqualToString:@"0"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedXiangCeImage)];
        [self.topImageView addGestureRecognizer:tap];
        
    }
    
    
    
    
    
    self.titleView =  [[UIView alloc] initWithFrame:CGRectMake(kAUTOWIDTH(62.5),kAUTOHEIGHT(134) - PCTopBarHeight + kAUTOHEIGHT(10),ScreenWidth, ScreenHeight - [self Suit:300])];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [UIView animateWithDuration:0.5 animations:^{
    self.titleView.frame = CGRectMake(0, [self Suit:300], ScreenWidth, ScreenHeight - [self Suit:300]);
    
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        self.titleView.frame = CGRectMake(0,400, ScreenWidth, ScreenHeight - 400);
    }
    
    //}];
    //    });
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    self.titleView.alpha=0;
    
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeJianPan)];
    [self.titleView addGestureRecognizer:tapText];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.titleView.alpha = 1;
    }];
    
    UILabel *titleLabel = [UILabel labelWithTitle:@"This is a title, this is a title, this is a title" AndColor:@"515151" AndFont:16 AndAlignment:NSTextAlignmentLeft];
    [self.titleView addSubview:titleLabel];
    
    titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = model.titleString;
    
    titleLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(kAUTOWIDTH(15), kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(30), kAUTOHEIGHT(44));
    //    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.topImageView.mas_bottom).offset([self Suit:15]);
    //        make.left.equalTo(self.view.mas_left).offset([self Suit:15]);
    //        make.centerX.equalTo(self.view.mas_centerX);
    //    }];
    
    self.titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(30), kAUTOHEIGHT(44))];
    self.titleTextView.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:18];
    self.titleTextView.text = @"请编写标题";
    
    self.titleTextView.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.titleTextView];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30),CGRectGetMaxY(titleLabel.frame) + kAUTOHEIGHT(25), ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(180))];
    self.contentTextView.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:14];
    self.contentTextView.text =  @"请编写内容";
    
    self.contentTextView.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.contentTextView];
    //    价格
    UILabel *priceLabel = [UILabel labelWithTitle:@"Price: $1000.00" AndColor:@"8a8a8a" AndFont:15 AndAlignment:NSTextAlignmentLeft];
    //    [self.titleView addSubview:priceLabel];
    
    priceLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:14];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = model.contentString;
    priceLabel.numberOfLines= 0;
    priceLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(50),CGRectGetMaxY(titleLabel.frame) + kAUTOHEIGHT(15), kAUTOWIDTH(100), kAUTOHEIGHT(180));
    
    //    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self).offset([self Suit:5]);
    //        make.right.mas_equalTo(self).offset(kAUTOWIDTH(60));
    //
    //    }];
    
    self.colorTextView = [[UITextView alloc]initWithFrame: CGRectMake(ScreenWidth - kAUTOWIDTH(140), ScreenHeight - [self Suit:300] - kAUTOHEIGHT(100), kAUTOWIDTH(140), kAUTOHEIGHT(60))];
    self.colorTextView.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:12];
    self.colorTextView.textColor= PNCColorWithHex(0x8a8a8a);
    self.colorTextView.text =  @"请编写日期";
    self.colorTextView.textAlignment = NSTextAlignmentRight;
    [self.titleView addSubview:self.colorTextView];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickShow)];
    [self.colorTextView addGestureRecognizer:tap];
    
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        self.colorTextView.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(160), ScreenHeight - 400 - kAUTOWIDTH(100), kAUTOWIDTH(140), kAUTOWIDTH(60));
        self.colorTextView.backgroundColor = [UIColor whiteColor];
    }
    
    
    //    评价
    UILabel *comment = [UILabel labelWithTitle:@"100 comments:" AndColor:@"8a8a8a" AndFont:14 AndAlignment:NSTextAlignmentLeft];
    //    [self.titleView addSubview:comment];
    
    comment.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:12];
    comment.textAlignment = NSTextAlignmentCenter;
    comment.text = model.colorString;
    
    comment.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(50), ScreenHeight - [self Suit:300] - kAUTOHEIGHT(100), kAUTOWIDTH(100), kAUTOHEIGHT(60));
    
    
    //    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(priceLabel.mas_bottom).offset([self Suit:15]);
    //        make.left.equalTo(self.titleView.mas_left).offset([self Suit:15]);
    //        make.height.mas_equalTo([self Suit:20]);
    //    }];
    //
    //星星
    //    ShowStarView *starView = [[ShowStarView alloc] init];
    //    starView.level = 4;
    //    [self.titleView addSubview:starView];
    //    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(comment.mas_centerY);
    //        make.left.equalTo(comment.mas_right).offset([self Suit:10]);
    //        make.width.mas_equalTo([self Suit:70]);
    //        make.height.mas_equalTo([self Suit:20]);
    //    }];
    
}

- (void)datePickShow{
    
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
        [_pikerView.sureBtn addTarget:self action:@selector(dataPickViewSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
        //        [self dateAllReadySelect];
        
        self.colorTextView.text = [self chuLiRiQi];
        
    }];
}

- (NSString *)chuLiRiQi{
    NSString *nian0 = [_selectValue substringWithRange:NSMakeRange(0, 1)];
    NSString *nian1 = [_selectValue substringWithRange:NSMakeRange(1, 2)];
    //    NSString *nian2 = [_selectValue substringWithRange:NSMakeRange(2, 1)];
    NSString *nian3 = [_selectValue substringWithRange:NSMakeRange(3, 1)];
    
    NSString *yue = [_selectValue substringWithRange:NSMakeRange(5, 2)];
    NSString *ri = [_selectValue substringWithRange:NSMakeRange(8, 2)];
    NSString *datestring = [NSString stringWithFormat:@"%@%@%@年%@月%@日",[self transChinese:nian0],[self transChinese:nian1],[self transChinese:nian3],[self transChinese:yue],[self transChinese:ri]];
    
    return datestring;
}

-(NSString*)transChinese:(NSString *)beforeString{
    NSString *str = beforeString;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@ to %@",str,chinese);
    return chinese;
}



-(void)dataPickViewCancleBtnClicked{
    [_backWindowView removeFromSuperview];
    [self.pikerView removeFromSuperview];
    self.pikerView = nil;
    NSLog(@"取消");
}


- (void)removeJianPan{
    [_contentTextView resignFirstResponder];
    [_colorTextView resignFirstResponder];
}

- (void)selectedXiangCeImage{

        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //判断数据来源为相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        //设置代理
        picker.delegate = self;
        //打开相册
        [self presentViewController:picker animated:YES completion:nil];
    
}


//    });


#pragma mark ========== 图片代理回调 ===========
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.topImageView.image = image;

    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)saveToDb{
    
    LZDataModel *model = self.dataSourceArray[self.index];
    
    NSData * imageBackData = UIImageJPEGRepresentation(self.topImageView.image, 0.5);
    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
    
    
    model.pcmData = imageBackDataString;
    NSLog(@"%@",model);
    
    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    [SVProgressHUD showInfoWithStatus:@"更新成功"];
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSLog(@"array");
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    
    
    return cell;
}

- (void)clickBackBtn {
    
    if ([_pushFlag isEqualToString:@"1"]) {
        LZDataModel *model = self.dataSourceArray[self.index];
        
        NSData * imageBackData = UIImageJPEGRepresentation(self.topImageView.image, 0.5);
        NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
        NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
        
        
        model.contentString = self.contentTextView.text;
        model.colorString = self.colorTextView.text;
        model.titleString = self.titleTextView.text;
        
        NSLog(@"%@",model);
        
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"您已经编辑了一条新的往后余生，保存后不可删除，确定要保存吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            LZDataModel *model3 = [[LZDataModel alloc]init];
            model3.userName = @"";
            model3.nickName = @"0";
            model3.password = @"";
            model3.urlString = @"isDone";
            model3.dsc = @"noLike";
            model3.groupName = @"";
            //    model3.groupID = group.identifier;
            model3.titleString = _titleTextView.text;
            model3.contentString =_contentTextView.text;
            model3.colorString =_colorTextView.text;

            
            UIImage *image = self.topImageView.image;
            NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
            NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
            NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
            
            model3.pcmData = imageBackDataString;
            [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
            
            NSLog(@"确定执行");
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self userInfo:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"往后|余生 默认添加到结尾"];
        }];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
//    return [ADCardTransition transitionWithType:operation == UINavigationControllerOperationPush ? ADCardTransitionTypePush : ADCardTransitionTypePop];
//}

/**
 适配 给定4.7寸屏尺寸，适配4和5.5寸屏尺寸
 */
- (float)Suit:(float)MySuit
{
    (IS_IPHONE4INCH||IS_IPHONE35INCH)?(MySuit=MySuit/Suit4Inch):((IS_IPHONE55INCH)?(MySuit=MySuit*Suit55Inch):MySuit);
    return MySuit;
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

