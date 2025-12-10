//
//  YSBaseViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSBaseViewController ()

@end

@implementation YSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOtherUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
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
    
    _navTitleLabel = [[RQShineLabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(5), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"";
    _navTitleLabel.font =  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(15)];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(kAUTOWIDTH(15), 28, kAUTOWIDTH(25), kAUTOWIDTH(25)) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    
    _rightBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - kAUTOWIDTH(40), 28, kAUTOWIDTH(25), kAUTOWIDTH(25)) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(rightBtnClick:)];

    
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(kAUTOWIDTH(15), 48, kAUTOWIDTH(25), kAUTOWIDTH(25));
        _rightBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40), 48, kAUTOWIDTH(25), kAUTOWIDTH(25));

        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    [_titleView addSubview:_backBtn];
    [_titleView addSubview:_rightBtn];
//    _backBtn.backgroundColor = [UIColor blackColor];
//    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
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
