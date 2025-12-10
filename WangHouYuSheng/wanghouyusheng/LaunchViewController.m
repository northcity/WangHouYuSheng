//
//  LaunchViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "LaunchViewController.h"
#import "WSYSMainViewController.h"
#import "LZiCloud.h"
#import "WHNewViewController.h"

@interface LaunchViewController ()
@property(nonatomic,strong) UIImageView *iconImage;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createImageView];
  
    
    
    NSString *isVip = [BCUserDeafaults objectForKey:ISBUYVIP];
    if ([isVip isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WHNewViewController *wVc = [[WHNewViewController alloc]init];
                self.navigationController.delegate = nil;
                [self.navigationController pushViewController:wVc animated:NO];
            });
        });
    }else{
//        [self createAD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WHNewViewController *wVc = [[WHNewViewController alloc]init];
            self.navigationController.delegate = nil;
            [self.navigationController pushViewController:wVc animated:NO];
        });
    }
   
}

//- (void)createAD{
////    APAdSplash *splash = [[APAdSplash alloc] initWithSlot:@"lGqezOGv" delegate:self];
////    [splash loadAndPresentWithViewController:self];
//}
//
//// Ad present has failed
//- (void) splashAdPresentDidFail:(nonnull NSString *)splashAdSlot
//                      withError:(nonnull NSError *)error{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        WHNewViewController *wVc = [[WHNewViewController alloc]init];
//        self.navigationController.delegate = nil;
//        [self.navigationController pushViewController:wVc animated:NO];
//    });
//}
//
//- (void) splashAdWillDismiss:(nonnull APAdSplash *)splashAd{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        WHNewViewController *wVc = [[WHNewViewController alloc]init];
//        self.navigationController.delegate = nil;
//        [self.navigationController pushViewController:wVc animated:NO];
//    });
//}



- (void)createImageView{
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - (50),ScreenHeight - 150, (100), (100))];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
//    _iconImage.layer.cornerRadius = 13;
    [self.view addSubview:_iconImage];
    _iconImage.center = self.view.center;
    _iconImage.image = [UIImage imageNamed:@"iconqidong1024.png"];
    UILabel * label = [Factory createLabelWithTitle:@"你的一生，我只借一程，这一程，是余生。" frame:CGRectMake(30, ScreenHeight - (74), ScreenWidth - 60, 44)];
//    [self.view addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:(9)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
