//
//  ImageViewController.m
//  shijianjiaonang
//
//  Created by 北城 on 2018/8/9.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ImageViewController.h"
#import "ChuLiImageManager.h"
#import "FilterImageView.h"
#import "UIImage+Filter.h"

@interface ImageViewController ()
@property(nonatomic,strong) FilterImageView *imageView;
@property(nonatomic,strong)CIFilter *filter;
@property(nonatomic,strong)CIContext *ciContext;
@property(nonatomic,strong)UIImage *image;

@property(nonatomic,strong)UIImageView *pailideImageView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOtherUI];
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:self.model.pcmData];
    self.image = image;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self initImagePailideView];
 
 

    
    UIButton *BUTTON = [UIButton buttonWithType:UIButtonTypeCustom];
    BUTTON.frame =CGRectMake(10, 10, 50, 50);
    [BUTTON addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BUTTON];
    
    UILabel *datelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.pailideImageView.frame.size.height - kAUTOHEIGHT(58), self.pailideImageView.frame.size.width - 70, kAUTOHEIGHT(25))];
    datelabel.text = self.model.colorString;
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.alpha = 0.6;
    datelabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:12];
    [self.pailideImageView addSubview:datelabel];
    
    
//    self.sta = YES;
}

- (void)initImagePailideView{
    self.pailideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), PCTopBarHeight + kAUTOHEIGHT(30), ScreenWidth - kAUTOWIDTH(0), ScreenHeight - PCTopBarHeight - kAUTOHEIGHT(30))];
    [self.view addSubview:self.pailideImageView];
//    self.pailideImageView.backgroundColor = [UIColor whiteColor];
    self.pailideImageView.image = [UIImage imageNamed:@"pailide1234"];
    self.pailideImageView.contentMode = UIViewContentModeScaleToFill;
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        self.pailideImageView.frame = CGRectMake(kAUTOWIDTH(0), PCTopBarHeight + kAUTOHEIGHT(20), ScreenWidth - kAUTOWIDTH(0), ScreenHeight - PCTopBarHeight - 60);

    }
}

- (FilterImageView *)imageView
{
    if (nil == _imageView) {
        _imageView = [[FilterImageView alloc] initWithFrame:CGRectMake(0,  PCTopBarHeight + kAUTOHEIGHT(40),ScreenWidth - kAUTOWIDTH(20), ScreenHeight - PCTopBarHeight - kAUTOHEIGHT(40))];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.image = self.image;
      
        
        if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
            _imageView.frame = CGRectMake(20,  PCTopBarHeight + kAUTOHEIGHT(20),ScreenWidth - 40, ScreenHeight - PCTopBarHeight - kAUTOHEIGHT(70));
            
        }
        
        __weak typeof(self)weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *image = [UIImage filterImage:weakSelf.image filterName:@"CIPhotoEffectProcess"];
            dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.imageView.image = image;
//                weakSelf.imageView.filter = filter;
            });
        });
        
    }
    return _imageView;
}




- (BOOL)prefersStatusBarHidden {
    return YES;
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
    _navTitleLabel.text = @"MY MEMORY";
    _navTitleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:18];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
        
    }
    
    if (PNCisIPAD) {
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, 5, kAUTOWIDTH(150), 66);

    }
    [_titleView addSubview:_backBtn];
    
//    _doneBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - 45, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(saveToDb)];
//    [_doneBtn setImage:[UIImage imageNamed:@"dkw_完成"] forState:UIControlStateNormal];
//    if (PNCisIPHONEX) {
//        _doneBtn.frame = CGRectMake(ScreenWidth - 45, 48, 25, 25);
//    }
    //    [_titleView addSubview:_doneBtn];
    
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

//- (void)backAction{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
