//
//  ListWangShengViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/6.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ListWangShengViewController.h"
#import "ListTableViewCell.h"
#import "LZDataModel.h"
#import "ImageViewController.h"


#define PNCisIOS11Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))


@interface ListWangShengViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) XRDragTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation ListWangShengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOtherUI];
    [self createUI];
    [self initData];

    self.navTitleLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:(16)] : [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(15)];
    self.navTitleLabel.text = NSLocalizedString(@"往后余生", nil);
    [self.leftBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadTable];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"RELOAD" object:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    
    WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
    manager.isreload = YES;
                   
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadTable{
      self.dataSource = [NSMutableArray array];
       self.dataSource =[[NSMutableArray alloc]init];
       NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
       self.dataSource= array.mutableCopy;
    self.tableView.dataArray = self.dataSource;

    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)initData{
    self.dataSource = [NSMutableArray array];
    self.dataSource =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSource= array.mutableCopy;
    self.tableView.dataArray = self.dataSource;
    [self.tableView reloadData];
    
}

- (void)createUI{
    self.tableView = [[XRDragTableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOHEIGHT(8), ScreenWidth, ScreenHeight - kAUTOHEIGHT(8) - PCTopBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [UIColor clearColor];
    if (PNCisIPAD) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = false;
    }
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
//
//    LZDataModel *model = self.dataSource[indexPath.row];
//
//    NSString *newString = [model.contentString stringByAppendingString:@"    "];
//    CGSize size = [model.contentString sizeWithFont: [UIFont fontWithName:@"TpldKhangXiDictTrial" size:13] constrainedToSize:CGSizeMake(ScreenWidth - kAUTOWIDTH(60), 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
//
//    return size.height + kAUTOHEIGHT(200) + kAUTOHEIGHT(40) + kAUTOHEIGHT(105) + kAUTOHEIGHT(20);
    return PNCisIPAD ? 150 : kAUTOWIDTH(150);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"listcell";
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
    iVc.currentIndex = indexPath.row;
    self.currentIndex = indexPath.row;
    iVc.pushFlag = @"0";
    self.navigationController.delegate = nil;

    [self.navigationController pushViewController:iVc animated:YES];
}
//必须把编辑模式改成None，默认的是delete

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{

    return UITableViewCellEditingStyleNone;

}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark 排序当移动了某一行时候会调用

//编辑状态下，只要实现这个方法，就能实现拖动排序---右侧会出现三条杠，点击三条杠就能拖动

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath

{

    // 取出要拖动的模型数据

    id goods = self.dataSource[sourceIndexPath.row];

    //删除之前行的数据

    [self.dataSource removeObject:goods];

    // 插入数据到新的位置

    [self.dataSource insertObject:goods atIndex:destinationIndexPath.row];


    for (int i = 0; i < self.dataSource.count; i ++) {
        LZDataModel *model = self.dataSource[i];
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
