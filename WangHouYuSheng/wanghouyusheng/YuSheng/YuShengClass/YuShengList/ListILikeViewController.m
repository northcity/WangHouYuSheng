//
//  ListILikeViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/7.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ListILikeViewController.h"
#import "ListTableViewCell.h"
#import "LZDataModel.h"

#import "ImageViewController.h"

#define PNCisIOS11Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))


@interface ListILikeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *kongView;

@end

@implementation ListILikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self createKongView];
    [self createUI];

    [self initData];
    [self initOtherUI];
    self.navTitleLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:(16)] : [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(15)];
    self.navTitleLabel.text = @"余生 | 收藏";
    [self.leftBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    
}

- (void)createKongView{
    self.kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    if (@available(iOS 13.0, *)) {
        self.kongView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.kongView.backgroundColor = [UIColor whiteColor];
    }
    self.kongView.center = self.view.center;
    [self.view addSubview:self.kongView];
    self.kongView.hidden = YES;

    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(60), kAUTOWIDTH(30), kAUTOWIDTH(120), kAUTOWIDTH(120))];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.image = [UIImage imageNamed:@"wushuju2"];
    [self.kongView addSubview:iconImageView];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame), ScreenWidth, kAUTOWIDTH(30))];
    label.text = @"空空如也，赶紧去收藏一条回忆吧~";
    label.textColor = [UIColor grayColor];
    label.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(12)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.kongView addSubview:label];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];

//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initData{
    self.dataSource =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
   
    for (int i = 0; i < array.count; i ++) {
        LZDataModel *model = array[i];
        if ([model.dsc isEqualToString:@"isLike"]) {
            [self.dataSource addObject:model];
        }
    }
    
    if (self.dataSource.count == 0) {
             self.tableView.hidden = YES;
             self.kongView.hidden = NO;
         }else{
             self.tableView.hidden = NO;
             self.kongView.hidden = YES;
         }
         
}

- (void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOHEIGHT(8), ScreenWidth, ScreenHeight - kAUTOHEIGHT(8) - PCTopBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    ;
    [self.view addSubview:self.tableView];
    //    [self addRefreshView];
    
    if (PNCisIOS11Later) {
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LZDataModel *model = self.dataSource[indexPath.row];
//
//    NSString *newString = [model.contentString stringByAppendingString:@"    "];
//    CGSize size = [model.contentString sizeWithFont: [UIFont fontWithName:@"TpldKhangXiDictTrial" size:13] constrainedToSize:CGSizeMake(ScreenWidth - kAUTOWIDTH(60), 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
//
//    return size.height + kAUTOHEIGHT(200) + kAUTOHEIGHT(40) + kAUTOHEIGHT(105);
    return PNCisIPAD ? 153 : kAUTOWIDTH(153);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   static NSString *cellIdentifier = @"daojishicell";
       ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       if (!cell) {
           cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
       }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.backgroundColor = [UIColor clearColor];
    
    
    LZDataModel *model = self.dataSource[indexPath.row];
    
    [cell setContentViewWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WHBianJiViewController *iVc = [[WHBianJiViewController alloc]init];
       LZDataModel *model = self.dataSource[indexPath.row];
       iVc.model = model;
       iVc.pushFlag = @"0";
    self.navigationController.delegate = nil;
       [self.navigationController pushViewController:iVc animated:YES];
}


@end

