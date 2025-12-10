//
//  WHNewViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/2/7.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHNewViewController.h"
#import "WHBianJiViewController.h"
#import "XHPageControl.h"
#import "YSMainTimeViewController.h"
#import "WSYSMainViewController.h"
#import "RQShineLabel.h"
#import "SettingViewController.h"
#import <SKGuideView.h>
#import "WHCollectionViewCell.h"
#import "WHCollectionHeaderView.h"
#import <StoreKit/StoreKit.h>
#import <HeWeather_Plugin/HeWeather_Plugin.h>
#import <CoreLocation/CoreLocation.h>
#import "LZStringEncode.h"
#import "WHTongBuViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "WHYSManager.h"

#define VIEW_W ScreenWidth - kAUTOWIDTH(50)
#define VIEW_H ScreenWidth

#define cardViewW  VIEW_W - kAUTOWIDTH(20)
#define cardViewH  VIEW_W + kAUTOWIDTH(115)

#define fangKuaiW (ScreenWidth - kAUTOWIDTH(70))/4

@interface WHNewViewController ()<iCarouselDelegate,iCarouselDataSource,UIScrollViewDelegate,XHPageControlDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
@property (nonatomic, strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong) XHPageControl *pageControl1;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UIImageView * bgImageView;

@property (nonatomic,strong) NSMutableArray * btnArray;
@property (nonatomic,strong) NSMutableArray * btnLabelArray;
@property (nonatomic,strong)  UIView *pageControlView;


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectionArray;
@property (nonatomic,strong) WPWaveRippleView *waveRippleView;
@property (nonatomic,strong) UIImageView *addImage;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) YQMotionShadowView *show;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,copy) NSString *cityName;

@property (nonatomic,strong) UIView *numberView;
@property (nonatomic,strong)UILabel *numContent;

//@property(nonatomic,strong)APAdBanner * banner;

@end

@implementation WHNewViewController

- (void)startLocate{

// 判断定位操作是否被允许

if([CLLocationManager locationServicesEnabled]) {

self.locationManager = [[CLLocationManager alloc] init] ;

self.locationManager.delegate = self;

// 开始定位
    [self.locationManager requestWhenInUseAuthorization];


[self.locationManager startUpdatingLocation];

}else {

//提示用户无法进行定位操作

}}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

//此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation

CLLocation *currentLocation = [locations lastObject];

// 获取当前所在的城市名

CLGeocoder *geocoder = [[CLGeocoder alloc] init];

//根据经纬度反向地理编译出地址信息

[geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){

if (array.count > 0){

CLPlacemark *placemark = [array objectAtIndex:0];

//将获得的所有信息显示到label上

NSLog(@"%@",placemark.name);

//获取城市

NSString *city = placemark.locality;
self.cityName = city;

if (!city) {

//四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）

city = placemark.administrativeArea;

self.cityName = city;

}else if (error == nil && [array count] == 0){

NSLog(@"No results were returned.");

}else if (error != nil){

NSLog(@"An error occurred = %@", error);

}else{
    
}
}
    
    
    [self createTianQi];


}];

//系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新

[manager stopUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

if (error.code == kCLErrorDenied) {

// 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在

}}

- (void)createTianQi{
    [self setHeFengPluginViewTypeHorizontal];
    [self setHeFengPluginViewTypeLeftLarge];
    [self setHeFengPluginViewTypeRightLarge];
    [self setHeFengPluginViewTypeVertical];
}

//显示横向单排
-(void)setHeFengPluginViewTypeHorizontal{
[self showViewWithFrame:CGRectMake(0,PCTopBarHeight, self.view.frame.size.width, kAUTOWIDTH(40)) Type:HeFengPluginViewTypeHorizontal typeArray:
@[@(HeFengConfigModelTypeLocation),
@(HeFengConfigModelTypeAlarmIcon),
@(HeFengConfigModelTypeAlarm),
@(HeFengConfigModelTypeTemp),
@(HeFengConfigModelTypeWeatherStateIcon),
@(HeFengConfigModelTypeWeatherState),
@(HeFengConfigModelTypeWindDirIcon),
@(HeFengConfigModelTypeWindSC),
@(HeFengConfigModelTypeAqiTitle),
@(HeFengConfigModelTypeQlty),
@(HeFengConfigModelTypeAqi),
@(HeFengConfigModelTypePcpnIcon),
@(HeFengConfigModelTypePcpn),
]];
}
//显示左侧大布局右侧双布局
-(void)setHeFengPluginViewTypeLeftLarge{
[self showViewWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40) Type:HeFengPluginViewTypeLeftLarge typeArray:
@[
//第一个数组内元素会被放在左边大布局上
@[@(HeFengConfigModelTypeWeatherStateIcon)],
//第二个数组内元素会被放在右边上部分布局上
@[
//    @(HeFengConfigModelTypeTemp),
//@(HeFengConfigModelTypeAlarmIcon),
//@(HeFengConfigModelTypeAlarm),
//@(HeFengConfigModelTypeAqiTitle),
//@(HeFengConfigModelTypeQlty),
//@(HeFengConfigModelTypeAqi),
@(HeFengConfigModelTypeLocation)],
//第三个数组内元素会被放在右边下部分布局上
@[
//    @(HeFengConfigModelTypeWeatherState),
//@(HeFengConfigModelTypeWindDirIcon),
//@(HeFengConfigModelTypeWindSC),
//@(HeFengConfigModelTypePcpnIcon),
//@(HeFengConfigModelTypePcpn)
]]];
}
//显示右侧大布局左侧双布局
-(void)setHeFengPluginViewTypeRightLarge{
[self showViewWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 40) Type:HeFengPluginViewTypeRightLarge typeArray:
@[
//第一个数组内元素会被放在右边大布局上
@[@(HeFengConfigModelTypeTemp)],
//第二个数组内元素会被放在左边上部分布局上
@[
@(HeFengConfigModelTypeLocation),
@(HeFengConfigModelTypeAqiTitle),
@(HeFengConfigModelTypeQlty),
@(HeFengConfigModelTypeAqi),
@(HeFengConfigModelTypeAlarmIcon),
@(HeFengConfigModelTypeAlarm),
@(HeFengConfigModelTypeWeatherStateIcon)],
//第三个数组内元素会被放在左边下部分布局上
@[
@(HeFengConfigModelTypePcpnIcon),
@(HeFengConfigModelTypePcpn),
@(HeFengConfigModelTypeWindDirIcon),
@(HeFengConfigModelTypeWindSC),
@(HeFengConfigModelTypeWeatherState)]
]];
}
//显示竖向单排布局
-(void)setHeFengPluginViewTypeVertical{
[self showViewWithFrame:CGRectMake(0, 400, 50, 300) Type:HeFengPluginViewTypeVertical typeArray:@[@(HeFengConfigModelTypeLocation),
@(HeFengConfigModelTypeTemp),
@(HeFengConfigModelTypeWeatherStateIcon),
@(HeFengConfigModelTypeWeatherState),
@(HeFengConfigModelTypeWindDirIcon),
@(HeFengConfigModelTypeWindSC),
@(HeFengConfigModelTypeAqiTitle),
@(HeFengConfigModelTypeQlty),
@(HeFengConfigModelTypeAqi),
@(HeFengConfigModelTypeAlarmIcon),
@(HeFengConfigModelTypeAlarm),
@(HeFengConfigModelTypePcpnIcon),
@(HeFengConfigModelTypePcpn),
]];

}
-(void)showViewWithFrame:(CGRect)frame Type:(HeFengPluginViewType)type typeArray:(NSArray *)typeArray{

//初始化视图
HeFengPluginView *view = [[HeFengPluginView alloc] initWithFrame:frame ViewType:type UserKey:@"7bb8f138c69c49c3b46f9f914d6a351f" Location:self.cityName];

//视图属性设置
NSMutableArray *configarray = [NSMutableArray array];
[typeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
NSMutableArray *modelarray = [NSMutableArray array];
if ([obj isKindOfClass:[NSArray class]]) {
[obj enumerateObjectsUsingBlock:^(id _Nonnull arrayobj, NSUInteger idx, BOOL * _Nonnull stop) {
HeFengConfigModel *model = [HeFengConfigModel new];
if (idx==0&&[arrayobj integerValue]==HeFengConfigModelTypeTemp&&[(NSArray *)obj count]==1) {
model.textFont = [UIFont systemFontOfSize:40];
}
if (idx==0&&[arrayobj integerValue]==HeFengConfigModelTypeWeatherStateIcon&&[(NSArray *)obj count]==1) {
model.iconSize = 32;
}
model.type = [arrayobj integerValue];
model.padding =type==HeFengPluginViewTypeVertical? UIEdgeInsetsMake(8, 4, 8, 4):UIEdgeInsetsMake(4, 8, 4, 8);
[modelarray addObject:model];
}];
[configarray addObject:modelarray];
}else{
HeFengConfigModel *model = [HeFengConfigModel new];
model.type = [obj integerValue];
model.padding =type==HeFengPluginViewTypeVertical? UIEdgeInsetsMake(8, 4, 8, 4):UIEdgeInsetsMake(4, 8, 4, 8);
[configarray addObject:model];
}
}];
//配置子元素排列顺序和属性
view.configArray = configarray;
view.contentViewAlignmen = HeFengContentViewAlignmentCenter;
//配置主题样式
view.themType = HeFengPluginViewThemeTypeLight;
//配置视图内间距
view.padding = UIEdgeInsetsZero;
//配置视图背景颜色
view.backgroundColor = [UIColor clearColor];
//自定义视图背景图片
view.backgroundImageTitle = @"";
//配置边框颜色
view.borderColor = [UIColor whiteColor];
//配置边框宽度
view.borderWidth =0;
//配置圆角
view.cornerRadius = 0;
//是否显示边框
view.isShowBorder = NO;
//是否显示圆角
view.isShowConer = NO;
//拖拽设置
view.dragEnable = YES;
//拖拽范围
view.freeRect = self.view.frame;
//拖拽方向
view.dragDirection = HeFengPluginViewDragDirectionAny;
//是否粘边
view.isKeepBounds = YES;
//设置导航栏背景色
view.navigationBarBackgroundColor = [UIColor redColor];
//设置导航栏进度条背景色
view.progressColor = [UIColor blueColor];
//设置导航栏返回按钮图片
view.navBarBackImage = [UIImage imageNamed:@""];
//设置导航栏关闭图片
view.navBarCloseImage = [UIImage imageNamed:@""];
//添加视图到view上
[self.view addSubview:view];
}






















- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 50);
    
    
    self.numberView = [[UIView alloc]initWithFrame:CGRectMake(0,PCTopBarHeight + kAUTOWIDTH(5), ScreenWidth, kAUTOWIDTH(40))];
    [self.view addSubview:self.numberView];
    
    
    UILabel *numTitle = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(80), 0, kAUTOWIDTH(200), kAUTOWIDTH(15))];
    numTitle.text = @"3月,19/2020";
    numTitle.text = @"我们已经完成了";
    numTitle.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(12)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(10)];
    numTitle.textColor = PNCColorWithHex(0x515151);
    numTitle.textAlignment = NSTextAlignmentCenter;
    [self.numberView addSubview:numTitle];
      
   
    
    self.numContent = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(80), CGRectGetMaxY(numTitle.frame), kAUTOWIDTH(200), kAUTOHEIGHT(25))];
    self.numContent.text = @"3月,19/2020";
    self.numContent.text = @"99件往后余生";
    self.numContent.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(16)] : [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
    self.numContent.textColor = PNCColorWithHex(0x1e1e1e);
    self.numContent.textAlignment = NSTextAlignmentCenter;
    [self.numberView addSubview:self.numContent];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(70), kAUTOWIDTH(5), kAUTOWIDTH(25), kAUTOWIDTH(25))];
    imageView.image = [UIImage imageNamed:@"爱心4"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.numberView addSubview:imageView];
    
    if (PNCisIPAD) {
        self.numberView.frame = CGRectMake(0,PCTopBarHeight + (10), ScreenWidth, (40));
        numTitle.frame = CGRectMake(ScreenWidth/2 - (80), 0, (200), (15));
        self.numContent.frame = CGRectMake(ScreenWidth/2 - (80), CGRectGetMaxY(numTitle.frame), (200), (25));
        imageView.frame =CGRectMake(ScreenWidth/2 - (70), (10), (25), (25));
    }
    
       //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOWIDTH(10) + kAUTOWIDTH(40), ScreenWidth, ScreenHeight - PCTopBarHeight - kAUTOWIDTH(10)) collectionViewLayout:flowLayout];
    if (PNCisIPAD) {
            self.collectionView.frame = CGRectMake(0, PCTopBarHeight + (10) + (40), ScreenWidth, ScreenHeight - PCTopBarHeight - (10));
    }
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.hidden = YES;
    self.numberView.hidden = YES;
    [self.view addSubview:self.collectionView];
       //注册Cell
    [self.collectionView registerClass:[WHCollectionViewCell class] forCellWithReuseIdentifier:@"WHCollectionViewCell"];
    [self.collectionView registerClass:[WHCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(startAnimation)
                                                    name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.waveRippleView = [[WPWaveRippleView alloc] initWithTintColor:[UIColor redColor] minRadius:10 waveCount:6 timeInterval:0.6 duration:3];
    self.waveRippleView.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(100),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(70), kAUTOWIDTH(70), kAUTOWIDTH(70));
    [self.waveRippleView startAnimating];
    [self.view addSubview:self.waveRippleView];
    
    self.addImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.addImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    [self.view addSubview:self.addImage];
    self.addImage.center = self.waveRippleView.center;
    self.addImage.image = [UIImage imageNamed:@"写信"];
    self.addImage.alpha = 0;
    [UIView animateWithDuration:1.5f delay:1.f options:UIViewAnimationOptionCurveLinear animations:^{
           self.addImage.alpha = 1;
           self.addImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:nil];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = self.addImage.frame;
    [self.addButton addTarget:self action:@selector(pushNextMainText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}

- (void)startAnimation{
    [self.waveRippleView startAnimating];
}

- (void)pushNextMainText{
    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
        SettingViewController *settingVc = [[SettingViewController alloc]init];
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:settingVc animated:YES];
        LZWeakSelf(weakSelf);
        settingVc.kaiguanFlag = @"1";

        settingVc.buySuccessBlock = ^(BOOL isSuccess) {
            if (isSuccess) {
                WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
                             sVc.pushFlag = @"0";
                             weakSelf.navigationController.delegate = nil;
                             [weakSelf.navigationController pushViewController:sVc animated:YES];
                       
            }
        };
       
        
        [settingVc initNeiGouView3];
    }else{
    WHBianJiViewController *sVc = [[WHBianJiViewController alloc]init];
    sVc.pushFlag = @"0";
    self.navigationController.delegate = nil;
    [self.navigationController pushViewController:sVc animated:YES];
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return CGSizeMake(ScreenWidth, kAUTOWIDTH(80));
//    }else{
        return CGSizeMake(ScreenWidth, 50);
        
//    }
//    return  CGSizeMake(0, 0);;

}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WHCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV" forIndexPath:indexPath];
    // if (self.dataArr.count == 0) return view; 这里之前没有注意，直接return view 的话 刷新会看到这个view，通过下面处理就行了。
    if (self.collectionArray.count == 0){
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    view.backgroundColor = [UIColor clearColor];
    // 这里就随便你怎么写了。我这个很简单只是一个日期的展示。。OK ，headerView 重复添加的问题搞定，数据错乱的问题搞定。
//    NSString *timeStr =  ((LZDataModel*)self.dataArr[indexPath.section][indexPath.row]).title
    
    NSArray *imageNameArray = [NSArray array];
    NSString *tag =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pagecontrolicon"];
    if ([tag isEqualToString:@"xiantiao"]) {
            imageNameArray = @[@"树木",@"鸡尾酒",@"拍立得",@"泡澡",@"日光浴",@"行旅箱",@"_冲浪",@"地图",@"长椅"];
        }else if ([tag isEqualToString:@"meishi"]) {
            imageNameArray = @[@"虾仁",@"波板糖",@"杯子蛋糕",@"香肠",@"柠檬干",@"开心果",@"瓜子",@"布丁"];
        }else{
            imageNameArray = @[@"树木",@"鸡尾酒",@"拍立得",@"泡澡",@"行旅箱",@"_冲浪",@"地图",@"长椅"];
        }
    NSArray *nameArray = @[@"恋爱",@"时光",@"经历",@"享受",@"旅行",@"挑战",@"分享",@"温暖"];
    view.headerImageView.image = [UIImage imageNamed:imageNameArray[indexPath.section]];
    view.headerLab.text = nameArray[indexPath.section];
    return view;
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionArray.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.collectionArray[section];
    return array.count;
    
}


#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"WHCollectionViewCell";
    WHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    LZDataModel *p = self.collectionArray[indexPath.section][indexPath.row];
    [cell setContentViewWithModel:p];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(fangKuaiW,fangKuaiW);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kAUTOWIDTH(10), kAUTOWIDTH(10),kAUTOWIDTH(10), kAUTOWIDTH(10));//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kAUTOWIDTH(10);
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kAUTOWIDTH(10);
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    NSInteger currentIndex = 0;
    for (int i = 0; i < indexPath.section; i++) {
        NSArray *array = self.collectionArray[i];
        for (int j = 0; j < array.count; j++) {
            currentIndex ++;
        }
    }
    currentIndex = currentIndex + indexPath.row;
    self.collectionView.hidden = YES;
    self.numberView.hidden = YES;
    self.myCarousel.hidden = NO;
    [_myCarousel scrollToItemAtIndex:currentIndex animated:YES];
    self.qieHuanButton.selected = NO;
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}





-(void)guide{
    [SKGuideView share].dataArr = @[@[self.leftButton,self.rightBtn,self.pageControlView],
                                    @[@"点击更多高级功能",@"点击进入余生时光",@"快速定位往后余生"]];
}

- (void)uploadWenJian{
    
    
    WHTongBuViewController *tVC = [[WHTongBuViewController alloc]init];
    self.navigationController.delegate = nil;
    [self.navigationController pushViewController:tVC animated:YES];
   
    
    return;
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
    NSData *data =  [NSData dataWithContentsOfFile:path];

    BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"WHYSQingLvMa"];
    
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
    //如果文件保存成功，则把文件添加到filetype列
    if (isSuccessful) {
    //上传文件的URL地址
    [obj setObject:file.url  forKey:@"filetypeurl"];
    [obj setObject:@"123456" forKey:@"lianaima"];
    //此处相当于新建一条记录,         //关联至已有的记录请使用 [obj updateInBackground];
    [obj saveInBackground];
    }else{

        NSLog(@"==========%@",error);
    //进行处理
    }
    }withProgressBlock:^(CGFloat progress) {
        NSLog(@"上传进度%.2f",progress);

    }];
    
    
    
//    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"iconlanunch.png"]);
//    BmobFile *file = [[BmobFile alloc]initWithFileName:@"test.png" withFileData:data];
//    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"GameScore"];
//    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
//    //如果文件保存成功，则把文件添加到filetype列
//    if (isSuccessful) {
//    //上传文件的URL地址
//    [obj setObject:file.url  forKey:@"filetypeurl"];
//    //此处相当于新建一条记录,         //关联至已有的记录请使用 [obj updateInBackground];
//    [obj saveInBackground];
//
//    }else{
//    //进行处理
//        NSLog(@"==========%@",error);
//    }
//    }withProgressBlock:^(CGFloat progress) {
//        NSLog(@"上传进度==========%.2f",progress);
//    } ];
}


- (void)downLoadFile{
    BmobQuery *query = [BmobQuery queryWithClassName:@"WHYSQingLvMa"];
    
    query.limit = 2;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"===================%@",array);
        BmobObject *fileObj  = array.firstObject;
        NSString *url = [fileObj objectForKey:@"filetypeurl"];
        
        NSLog(@"url ============= %@",url);
        [self saveFileWithUrl:@"http://file.northcity.top/2020/04/03/6d29a38f89124affb79e2d32c045964c.db"];
    
    }];
    
//    [query getObjectInBackgroundWithId:@"1783521c59" block:^(BmobObject *object, NSError *error) {
//    if (error) {
//    NSLog(@"%@",error);
//    } else {
//    NSLog(@"%@",object);
//    BmobFile *file = (BmobFile *)[object objectForKey:@"filetype"];
//    NSLog(@"%@",file.url);
//    }
//    }];
    
}

- (void)saveFileWithUrl:(NSString *)urlString{
   NSURL *url = [NSURL URLWithString:@"http://file.northcity.top/2020/04/03/6d29a38f89124affb79e2d32c045964c.db"];
   //1.获取session
   NSURLSession *session = [NSURLSession sharedSession];
   //使用session创建一个下载任务
   NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     //当所有数据下载完成后会调用此block
     //location为下载完成后文件保存的硬盘的临时路径（Temp文件夹下面），如果不处理就会马上删除，一般是将下载好的文件剪切到caches路径下面保存起来
     //此下载方法是边下边写，不会占用太多内存，缺点是只有当所有数据都下载下来后才能调用此block，所有没法知道下载进度
       
       NSString *yuanLaiPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData/userData.db"];
       if ([WHNewViewController fileExistsAtPath:yuanLaiPath isDirectory:NO]) {
           [WHNewViewController removeItemAtPath:yuanLaiPath];
           
           
            
               NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
               NSString *docPath = [pathArr firstObject];
        
           
                 //获取服务器的文件名
                 NSString *fileName = @"userData/userData.db";
                 //创建需要保存在本地的文件路径
                 NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
                 //将下载的文件剪切到上面的路径
                 [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
//           [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
           
       }
       
       
       
      
   }];
   //开始任务
   [downLoadTask resume];


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


/**
 下载完成调用

 @param location 写入本地临时路经（temp文件夹里面）
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //获取服务器的文件名
    NSString *fileName = downloadTask.response.suggestedFilename;
    //创建需要保存在本地的文件路径
    NSString *filePath = [caches stringByAppendingPathComponent:fileName];
    //将下载的文件剪切到上面的路径
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
}


- (void)createAD{
    
//    self.banner = [[APAdBanner alloc] initWithSlot:@"qGJeNNyw" withSize:APAdBannerSize320x50 delegate:self currentController:self];
//    [self.view addSubview:self.banner];
//    [self.banner setInterval:2];
//    [self.banner load];
//    [self.banner setPosition:CGPointMake(ScreenWidth/2, ScreenHeight - kAUTOWIDTH(50) + kAUTOWIDTH(25))];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCollectionView];
    [self.view addSubview:self.myCarousel];
    
    self.myCarousel.transform = CGAffineTransformMakeScale(0.9, 0.9);    // 先缩小
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
        self.myCarousel.transform = CGAffineTransformMakeScale(1, 1);
  // 放大
    } completion:^(BOOL finished) {
    }];
    
    self.view.clipsToBounds = YES;
    [self loadDate];
    self.navTitleLabel.text = NSLocalizedString(@"往后余生", nil);
    self.navTitleLabel.textColor = PNCColorWithHex(0x1e1e1e);
    
    NSString *strText = NSLocalizedString(@"往后余生", nil);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(15)] forKey:NSFontAttributeName];
    CGSize size = [strText boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.navTitleLabel.frame = CGRectMake(ScreenWidth/2 - size.width/2, kAUTOHEIGHT(5), size.width, kAUTOHEIGHT(66));

     
    
    if (PNCisIPAD) {
    }
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navTitleLabel shine];
    
    CALayer * titViewLayer=[CALayer layer];
    titViewLayer.frame = CGRectMake(kAUTOWIDTH(15),PCTopBarHeight - kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(10));
    titViewLayer.cornerRadius = kAUTOWIDTH(35);
    titViewLayer.backgroundColor = PNCColorWithHexA(0xffffff, 1).CGColor;
    titViewLayer.masksToBounds = NO;
    titViewLayer.shadowColor = PNCColorWithHex(0xdcdcdc).CGColor;
    titViewLayer.shadowOffset = CGSizeMake(0,0);
    titViewLayer.shadowOpacity = .1f;
    titViewLayer.shadowRadius = 8;
    [self.view.layer insertSublayer:titViewLayer below:self.titleView.layer];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(115), PCTopBarHeight
                                                                  + kAUTOWIDTH(10), kAUTOWIDTH(100), kAUTOHEIGHT(66))];
    dateLabel.text = @"3月,19/2020";
    NSString * currentTime = [BCShanNianKaPianManager getCurrentTimes];
//    2020-01-01
    NSString *timeString = [NSString stringWithFormat:@"%@月,%@/%@",[currentTime substringWithRange:NSMakeRange(5, 2)],[currentTime substringWithRange:NSMakeRange(8, 2)],[currentTime substringToIndex:4]];
    dateLabel.text = timeString;

    dateLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
    dateLabel.textColor = PNCColorWithHex(0x515151);
    dateLabel.textAlignment = NSTextAlignmentRight;
//    [self.view addSubview:dateLabel];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(ScreenWidth- kAUTOWIDTH(40), kAUTOHEIGHT(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [self.titleView addSubview:self.rightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"时间3"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(pushYuSheng:) forControlEvents:UIControlEventTouchUpInside];
   
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(kAUTOWIDTH(15), kAUTOHEIGHT(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [self.titleView addSubview:self.leftButton];
    [self.leftButton setImage:[UIImage imageNamed:@"首页 蓝"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:kAUTOWIDTH(18)];
    [self.leftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    self.qieHuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
      self.qieHuanButton.frame = CGRectMake(CGRectGetMaxX(self.navTitleLabel.frame) + 15, kAUTOHEIGHT(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
      [self.titleView addSubview:self.qieHuanButton];
      [self.qieHuanButton setImage:[UIImage imageNamed:@"lunbo"] forState:UIControlStateNormal];
    [self.qieHuanButton setImage:[UIImage imageNamed:@"pubu"] forState:UIControlStateSelected];

    [self.qieHuanButton addTarget:self action:@selector(showCollectionView:) forControlEvents:UIControlEventTouchUpInside];
     
    
    
    if (kIsFullScreen) {
        self.rightButton.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(47), kAUTOWIDTH(25),  kAUTOWIDTH(25));
        self.navTitleLabel.frame = CGRectMake(ScreenWidth/2 - size.width/2, kAUTOHEIGHT(27), size.width, kAUTOHEIGHT(66));
        self.leftButton.frame = CGRectMake(kAUTOWIDTH(15), kAUTOHEIGHT(47), kAUTOWIDTH(25),  kAUTOWIDTH(25));
        self.qieHuanButton.frame = CGRectMake(CGRectGetMaxX(self.navTitleLabel.frame) + 15, kAUTOHEIGHT(47), kAUTOWIDTH(25), kAUTOWIDTH(25));

    }
    
    if (PNCisIPAD) {
        self.navTitleLabel.font =  [UIFont fontWithName:@"TpldKhangXiDictTrial" size:(20)];
        self.rightButton.frame = CGRectMake(ScreenWidth - (40), (47), (30),  (30));
        self.leftButton.frame = CGRectMake((15), (47), (30),  (30));
        self.qieHuanButton.frame = CGRectMake(ScreenWidth/2 + (60), (47), (25), (25));
        self.navTitleLabel.frame = CGRectMake(ScreenWidth/2 - (75), (43), (150), (30));

    }
    self.btnArray = [[NSMutableArray alloc]init];
    self.btnLabelArray = [[NSMutableArray alloc]init];

    NSArray *nameArray = @[@"恋爱",@"时光",@"经历",@"享受",@"半生",@"旅行",@"挑战",@"分享",@"温暖"];
    
    self.pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, kIsFullScreen ? ScreenHeight - kAUTOWIDTH(200) :  ScreenHeight - kAUTOWIDTH(150), ScreenWidth, kAUTOWIDTH(50))];
    self.pageControlView.backgroundColor = [UIColor whiteColor];
    [_myCarousel addSubview:self.pageControlView];
    
    
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOWIDTH(10) + cardViewH, ScreenWidth, kAUTOWIDTH(140))];
    maskView.backgroundColor = [UIColor blackColor];
//    [_myCarousel addSubview:maskView];
    maskView.userInteractionEnabled = NO;
    
    
    CALayer * searchSubLayer=[CALayer layer];
    searchSubLayer.frame = CGRectMake(kAUTOWIDTH(20), kIsFullScreen ? ScreenHeight - kAUTOWIDTH(200) + kAUTOWIDTH(50) - kAUTOWIDTH(20) : ScreenHeight - kAUTOWIDTH(150) + kAUTOWIDTH(50) - kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(40), kAUTOWIDTH(20));
    //            self.searchView.frame;
                searchSubLayer.cornerRadius = kAUTOWIDTH(35);
                searchSubLayer.backgroundColor = PNCColorWithHexA(0xffffff, 1).CGColor;
                searchSubLayer.masksToBounds = NO;
                searchSubLayer.shadowColor = [UIColor grayColor].CGColor;
                searchSubLayer.shadowOffset = CGSizeMake(0,0);
                searchSubLayer.shadowOpacity = .2f;
                searchSubLayer.shadowRadius = 12;
                [self.myCarousel.layer insertSublayer:searchSubLayer below:self.pageControlView.layer];

//    NSArray *imageNameArray = @[@"shenghuo",@"旅行_拖鞋",@"旅行-12",@"旅行-17",@"旅行-30",@"旅行-54",@"旅行-79",@"旅行-71",@"旅行-33"];
//    NSArray *imageNameArray = @[@"hearts-fill",@"ancient-gate-fill",@"3",@"30",@"52",@"2",@"70",@"88",@"旅行-33"];
    NSArray *imageNameArray = [NSArray array];
 
    NSString *tag =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pagecontrolicon"];
        if ([tag isEqualToString:@"xiantiao"]) {

        imageNameArray = @[@"树木",@"鸡尾酒",@"拍立得",@"泡澡",@"日光浴",@"行旅箱",@"_冲浪",@"地图",@"长椅"];

        }
      
      if ([tag isEqualToString:@"meishi"]) {
               imageNameArray = @[@"虾仁",@"波板糖",@"杯子蛋糕",@"香肠",@"鸡腿",@"柠檬干",@"开心果",@"瓜子",@"布丁"];

      }else{
          imageNameArray = @[@"树木",@"鸡尾酒",@"拍立得",@"泡澡",@"日光浴",@"行旅箱",@"_冲浪",@"地图",@"长椅"];

      }
    

    
    
    for (int i = 0; i < 9 ; i ++) {
        UIButton *pageControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat JianGe = ((ScreenWidth - kAUTOWIDTH(60)) - 9 * kAUTOWIDTH(25))/8;
        
        pageControlBtn.frame = CGRectMake(kAUTOWIDTH(30) + i * (kAUTOWIDTH(25) + JianGe), 0, kAUTOWIDTH(25), kAUTOWIDTH(25));
//        pageControlBtn.backgroundColor = [UIColor redColor];
        [self.pageControlView addSubview:pageControlBtn];
        
        pageControlBtn.tag = 2024 + i;
        [pageControlBtn setImage:[UIImage imageNamed:@"圆形"] forState:UIControlStateNormal];

        [pageControlBtn setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateSelected];
        
        
//        [pageControlBtn setTitle:nameArray[i] forState:UIControlStateNormal];
//        pageControlBtn.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(9)];
//        [pageControlBtn setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
        
//        pageControlBtn.titleEdgeInsets = UIEdgeInsetsMake(pageControlBtn.imageView.frame.size.height + 10.0, - pageControlBtn.imageView.bounds.size.width, .0, .0);
//        pageControlBtn.imageEdgeInsets = UIEdgeInsetsMake(.0, pageControlBtn.titleLabel.bounds.size.width / 2, pageControlBtn.titleLabel.frame.size.height + 10.0, - pageControlBtn.titleLabel.bounds.size.width / 2);
//
        
        if (i == 0) {
//            [pageControlBtn setImage:[UIImage imageNamed:@"shenghuo"] forState:UIControlStateSelected];
            pageControlBtn.selected = YES;
        }
//            else if (i == 1){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行_拖鞋"] forState:UIControlStateSelected];
//
//        }else if (i == 2){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-12"] forState:UIControlStateSelected];
//
//        }else if (i == 3){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-17"] forState:UIControlStateSelected];
//
//        }else if (i == 4){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-30"] forState:UIControlStateSelected];
//
//        }else if (i == 5){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-54"] forState:UIControlStateSelected];
//
//        }else if (i == 6){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-79"] forState:UIControlStateSelected];
//
//        }else if (i == 7){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-71"] forState:UIControlStateSelected];
//
//        }else if (i == 8){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-33"] forState:UIControlStateSelected];
//
//        }else if (i == 9){
//            [pageControlBtn setImage:[UIImage imageNamed:@"爱情与浪漫-3"] forState:UIControlStateSelected];
//
//        }else if (i == 10){
//            [pageControlBtn setImage:[UIImage imageNamed:@"旅行-33"] forState:UIControlStateSelected];
//
//        }else{
//            [pageControlBtn setImage:[UIImage imageNamed:@"圆形"] forState:UIControlStateSelected];
//
//        }
        
        [pageControlBtn addTarget: self action:@selector(pageControlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArray addObject:pageControlBtn];
   
    
        UILabel *buttonLabel = [[UILabel alloc]init];
        buttonLabel.frame = CGRectMake(kAUTOWIDTH(30) + i * (kAUTOWIDTH(25) + JianGe), kAUTOWIDTH(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
        buttonLabel.font = PNCisIPAD ?  [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:(15)]: [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(9)];
        buttonLabel.textColor = PNCColorWithHex(0x515151);
        buttonLabel.text = nameArray[i];
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        [self.pageControlView addSubview:buttonLabel];
        buttonLabel.tag = 88888 + i;
        buttonLabel.hidden = YES;
        if (i == 0) {
            buttonLabel.hidden = NO;
        }
        [self.btnLabelArray addObject:buttonLabel];
    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstguide1"]){
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstguide1"];
               [self guide];
           }
    
//    [self startLocate];
    
//    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     downBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(80), PCTopBarHeight + kAUTOHEIGHT(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
//     [self.view addSubview:downBtn];
//     [downBtn setImage:[UIImage imageNamed:@"时间3"] forState:UIControlStateNormal];
//     [downBtn addTarget:self action:@selector(downLoadFile) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        upBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(120), PCTopBarHeight + kAUTOHEIGHT(25), kAUTOWIDTH(25), kAUTOWIDTH(25));
//        [self.view addSubview:upBtn];
//        [upBtn setImage:[UIImage imageNamed:@"时间3"] forState:UIControlStateNormal];
//        [upBtn addTarget:self action:@selector(uploadWenJian) forControlEvents:UIControlEventTouchUpInside];
       
    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               WHTongBuViewController *wvc =[[WHTongBuViewController alloc]init];
               [wvc tongBuVcAutoTongBuIsAlert:NO];
               
           });
    }else{
        [self createAD];
        WHTongBuViewController *wvc =[[WHTongBuViewController alloc]init];
        [wvc tongBuVcAutoTongBuIsAlert:NO];

    }
    
   
    
//    // 注册手势驱动
//       __weak typeof(self)weakSelf = self;
//       // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
//       [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
//           //NSLog(@"direction = %ld", direction);
//           if (direction == 0) { // 左侧滑出
//               [weakSelf leftBtnClick:nil];
//           } else if (direction == 1) { // 右侧滑出
//               [weakSelf pushYuSheng:nil];
//           }
//       }];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"addLocalNotification"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addLocalNotification"];
        [self addLocalNOtification];
    }
}

- (void)addLocalNOtification{
    [WHYSManager addLocalNotificationWithTitle:@"记录你的往后余生" subTitle:@"" body:@"今天时间不早了，来记录今天的恋爱小事吧!" timeInterval:3600*6 identifier:@"1" userInfo:nil repeats:4];
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

- (void)showCollectionView:(UIButton *)button{
//    [self loadDate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showAppStoreReView];
    });
    
    button.selected = !button.selected;
    
    [BCShanNianKaPianManager maDaZhongJianZhenDong];
           button.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
           // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
           [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
               button.transform = CGAffineTransformMakeScale(1, 1);        // 放大
           } completion:nil];
    
    
    if (button.selected) {
     
           
        
        
      
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        self.numberView.hidden = NO;
        self.myCarousel.hidden = YES;

             self.collectionView.transform = CGAffineTransformMakeScale(0.9, 0.9);    // 先缩小
                       // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        self.numberView.transform = CGAffineTransformMakeScale(0.9, 0.9);

        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
                           self.collectionView.transform = CGAffineTransformMakeScale(1, 1);
// 放大
            self.numberView.transform = CGAffineTransformMakeScale(1, 1);

        } completion:^(BOOL finished) {
                  
        }];
        
    }else{
        self.myCarousel.hidden = NO;
        self.numberView.hidden = YES;
        [self.myCarousel reloadData];
        self.collectionView.hidden = YES;

          self.myCarousel.transform = CGAffineTransformMakeScale(0.9, 0.9);    // 先缩小
                               // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度

                [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
                    self.myCarousel.transform = CGAffineTransformMakeScale(1, 1);
        // 放大
                } completion:^(BOOL finished) {

                }];
        
        
    }
}

- (void)pushYuSheng:(UIButton *)sender{
            [BCShanNianKaPianManager maDaQingZhenDong];
            sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
            // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
            } completion:nil];
        
    
    self.navigationController.delegate = nil;
    YSMainTimeViewController *ysVc = [[YSMainTimeViewController alloc]init];
//    ysVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ysVc animated:YES completion:nil];
//    [self.navigationController pushViewController:ysVc animated:YES];
}

- (void)leftBtnClick:(UIButton *)sender{
        [BCShanNianKaPianManager maDaQingZhenDong];
        sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
        } completion:nil];
        SettingViewController *svc = [[SettingViewController alloc]init];
    self.navigationController.delegate = nil;
//    [self.navigationController pushViewController:svc animated:YES];

//        svc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:svc animated:YES completion:nil];
    
     [self cw_showDrawerViewController:svc animationType:CWDrawerAnimationTypeDefault configuration:nil];

//     CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:0 backImage:[UIImage imageNamed:@"back.jpg"]];
//    [self cw_showDrawerViewController:svc animationType:0 configuration:conf];
    
}


- (void)pageControlBtnClick:(UIButton *)button{
    [BCShanNianKaPianManager maDaQingZhenDong];
          button.imageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    
          // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
          [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
              button.imageView.transform = CGAffineTransformMakeScale(1, 1);
          } completion:nil];
    
    
    
    if (button.tag == 2024) {
        [_myCarousel scrollToItemAtIndex:0 animated:YES];
    }
    
    if (button.tag == 2025) {
           [_myCarousel scrollToItemAtIndex:19 animated:YES];
       }
    
    if (button.tag == 2026) {
           [_myCarousel scrollToItemAtIndex:33 animated:YES];
       }
    
    if (button.tag == 2027) {
           [_myCarousel scrollToItemAtIndex:44 animated:YES];
       }
    
    if (button.tag == 2028) {
           [_myCarousel scrollToItemAtIndex:51 animated:YES];
       }
    if (button.tag == 2029) {
              [_myCarousel scrollToItemAtIndex:65 animated:YES];
          }
    if (button.tag == 2030) {
              [_myCarousel scrollToItemAtIndex:77 animated:YES];
          }
    if (button.tag == 2031) {
              [_myCarousel scrollToItemAtIndex:85 animated:YES];
          }
    if (button.tag == 2032) {
              [_myCarousel scrollToItemAtIndex:100 animated:YES];
    }
    
    
    
    for (UIButton *button1 in _btnArray) {
        if (button1.tag == button.tag) {
            button1.selected = YES;
            UILabel *label = self.btnLabelArray[button1.tag - 2024];
            label.hidden = NO;
        
        }else{
            UILabel *label = self.btnLabelArray[button1.tag - 2024];
            label.hidden = YES;
            button1.selected = NO;
        }
    }
    
}

- (void)backAction{
    
//    [self showAlertWithTitle:@"" scheme:@""];
    
}


- (void)showAlertWithTitle:(NSString *)title scheme:(NSString *)scheme {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换样式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
   
//    iCarouselTypeLinear = 0,
//      iCarouselTypeRotary,
//      iCarouselTypeInvertedRotary,
//      iCarouselTypeCylinder,
//      iCarouselTypeInvertedCylinder,
//      iCarouselTypeWheel,
//      iCarouselTypeInvertedWheel,
//      iCarouselTypeCoverFlow,
//      iCarouselTypeCoverFlow2,
//      iCarouselTypeTimeMachine,
//      iCarouselTypeInvertedTimeMachine,
//      iCarouselTypeCustom
//
    
    UIAlertAction *gaojingdu = [UIAlertAction actionWithTitle:@"iCarouselTypeLinear" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeLinear;


    }];
    
    UIAlertAction *dijingdu = [UIAlertAction actionWithTitle:@"iCarouselTypeRotary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeRotary;

    }];
    
    
    UIAlertAction *dijingdu1 = [UIAlertAction actionWithTitle:@"iCarouselTypeInvertedRotary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeInvertedRotary;

    }];
    
    
    UIAlertAction *dijingdu2 = [UIAlertAction actionWithTitle:@"iCarouselTypeCylinder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeCylinder;

    }];
    
    
    UIAlertAction *dijingdu3 = [UIAlertAction actionWithTitle:@"iCarouselTypeWheel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeWheel;

    }];
    
    
    UIAlertAction *dijingdu4 = [UIAlertAction actionWithTitle:@"iCarouselTypeInvertedWheel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _myCarousel.type = iCarouselTypeInvertedWheel;

    }];
    
    UIAlertAction *dijingdu5 = [UIAlertAction actionWithTitle:@"iCarouselTypeTimeMachine" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           _myCarousel.type = iCarouselTypeTimeMachine;

       }];
    
    UIAlertAction *dijingdu6 = [UIAlertAction actionWithTitle:@"iCarouselTypeInvertedTimeMachine" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           _myCarousel.type = iCarouselTypeInvertedTimeMachine;

       }];
    
    
    UIAlertAction *dijingdu7 = [UIAlertAction actionWithTitle:@"iCarouselTypeCustom" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           _myCarousel.type = iCarouselTypeCustom;

       }];
    
    
  

    [alertController addAction:cancelAction];
    [alertController addAction:gaojingdu];
    [alertController addAction:dijingdu];
    [alertController addAction:dijingdu1];
    [alertController addAction:dijingdu2];
    [alertController addAction:dijingdu3];
    [alertController addAction:dijingdu4];
    [alertController addAction:dijingdu5];
    [alertController addAction:dijingdu6];
    [alertController addAction:dijingdu7];

//    [alertController addAction:zhengshu];
//    [alertController addAction:okAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.sourceRect = self.view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

    [self presentViewController:alertController animated:YES completion:nil];
}









- (void)loadDate{
    
    self.dataSourceArray =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSourceArray= array.mutableCopy;
   
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first202"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first202"];
    
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        LZDataModel *model = self.dataSourceArray[i];
        if (model.email.length == 0) {
            model.email = [model.pcmData stringByAppendingString:@"&&++&&"];
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        }
    }
    
    }
    
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first0403"]){
//         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first0403"];
//
//     for (int i = 0; i < self.dataSourceArray.count; i++) {
//         LZDataModel *model = self.dataSourceArray[i];
//         if (model.email.length > 0) {
//             if (![[model.email substringToIndex:10] isEqualToString:[model.pcmData substringToIndex:10]]) {
//                         model.email = [LZStringEncode decode:model.email];
//                     [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
//                     }
//         }
//
//     }
     
//     }
     
    
    
    
    
    [_myCarousel reloadData];
    
    
    self.collectionArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *oneArray = [[NSMutableArray alloc]init];
    NSMutableArray *twoArray = [[NSMutableArray alloc]init];
    NSMutableArray *threeArray = [[NSMutableArray alloc]init];
    NSMutableArray *fourArray = [[NSMutableArray alloc]init];
    NSMutableArray *fiveArray = [[NSMutableArray alloc]init];
    NSMutableArray *sixArray = [[NSMutableArray alloc]init];
    NSMutableArray *senvenArray = [[NSMutableArray alloc]init];
    NSMutableArray *nineArray = [[NSMutableArray alloc]init];
    NSInteger doneNumber = 0;
    
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        
        LZDataModel *model = self.dataSourceArray[i];
        if ([model.urlString isEqualToString:@"isDone"]) {
            doneNumber ++;
        }
        
        if (i < 19) {
            [oneArray addObject:self.dataSourceArray[i]];
        }else if (i<33){
            [twoArray addObject:self.dataSourceArray[i]];
        }else if (i<44){
            [threeArray addObject:self.dataSourceArray[i]];
        }else if (i<51){
            [fourArray addObject:self.dataSourceArray[i]];

        }else if (i<65){
            [fiveArray addObject:self.dataSourceArray[i]];

        }else if (i<77){
            [sixArray addObject:self.dataSourceArray[i]];

        }else if (i<85){
            [senvenArray addObject:self.dataSourceArray[i]];
        }else{
            [nineArray addObject:self.dataSourceArray[i]];
        }
        
        
    }
    
    [self.collectionArray addObject: oneArray];
    [self.collectionArray addObject: twoArray];
    [self.collectionArray addObject: threeArray];
    [self.collectionArray addObject: fourArray];
    [self.collectionArray addObject: fiveArray];
    [self.collectionArray addObject: sixArray];
    [self.collectionArray addObject: senvenArray];
    [self.collectionArray addObject: nineArray];

    
    self.numContent.text = [NSString stringWithFormat:@"%ld件往后余生",(long)doneNumber];
    
    [_collectionView reloadData];
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bgImageView.backgroundColor = [UIColor whiteColor];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    LZDataModel *model = self.dataSourceArray[0];
//    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
//    self.bgImageView.image = image;
    
//    [self.myCarousel addSubview:self.bgImageView];
//    [self.myCarousel insertSubview:self.bgImageView atIndex:0];

    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
        self.bgImageView.image = image;
            
    }else{
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.pcmData] placeholderImage:kPlaceholderImage];
    }
    

    UIBlurEffect  *effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectViewT = [[UIVisualEffectView alloc] initWithEffect:effectT];
    effectViewT.frame = self.bgImageView.bounds;
    effectViewT.alpha = 1.f;
    effectViewT.userInteractionEnabled = YES;
    [self.bgImageView addSubview:effectViewT];
    
    
}


- (iCarousel *)myCarousel {
    if (!_myCarousel) {
        _myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOWIDTH(20), ScreenWidth, ScreenHeight - PCTopBarHeight - kAUTOWIDTH(20))];
        _myCarousel.dataSource = self;
        _myCarousel.delegate = self;
        _myCarousel.bounces = NO;
        _myCarousel.pagingEnabled = NO;
        _myCarousel.type = iCarouselTypeCustom;
        _myCarousel.backgroundColor = PNCColor(255, 255, 255);
        
        if (PNCisIOS13Later) {
            UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                           if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                               return PNCColor(255, 255, 255);
                           }else {
                               return PNCColorWithHexA(0x000000, 1);
                           }
                       }];
                       
            _myCarousel.backgroundColor = backViewColor;

        }else{
            _myCarousel.backgroundColor = PNCColor(255, 255, 255);
        }
    }
//    _myCarousel.alpha = 0;
//    _myCarousel.transform = CGAffineTransformMakeScale(0.7, 0.7);
//    [UIView animateWithDuration:0.5 animations:^{
//        _myCarousel.alpha = 1;
//        _myCarousel.transform = CGAffineTransformMakeScale(1, 1);
//    }];
    
    return _myCarousel;
}

#pragma mark - iCarouselDataSource

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.dataSourceArray.count;
}



-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{

    view = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(50),CGRectGetMinY(carousel.frame), VIEW_W,CGRectGetHeight(carousel.frame))];
    if (PNCisIPAD) {
        view.frame = CGRectMake(kAUTOWIDTH(100),CGRectGetMinY(carousel.frame), ScreenWidth - kAUTOWIDTH(200),CGRectGetHeight(carousel.frame));
    }
    view.tag = 1024+index;
    LZDataModel *model = self.dataSourceArray[index];
    [self createSubViewsWithView0:view WithModel:model Withindex:index];
    return view;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionDown){
        NSLog(@"swipe down");
        
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionUp) {
    [self cardPush];
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        
    }
    
}

- (void)cardPush{
    UIView *view = [self.myCarousel viewWithTag:1024+self.currentIndex];
      view.transform = CGAffineTransformMakeScale(1, 1);
      
      UIImageView *misanImage = [self.myCarousel viewWithTag:321 + self.currentIndex];
      [UIView animateWithDuration:0.3 animations:^{
          misanImage.alpha = 0;

      }];
      
      
      
      LZDataModel *model = self.dataSourceArray[self.currentIndex];
      WHBianJiViewController *wbjVc = [[WHBianJiViewController alloc]init];
      wbjVc.model = model;
      wbjVc.bgImage = [self imageFromView];;
      wbjVc.modalPresentationStyle = UIModalPresentationFullScreen;
      wbjVc.currentIndex = self.currentIndex;
      
      wbjVc.backImageBlock = ^(UIImage * _Nonnull selImage) {
          UIImageView *imageView = (UIImageView *)[self.myCarousel viewWithTag:100+self.currentIndex];
          imageView.image = selImage;
      };
      
      wbjVc.backModelBlock = ^(NSString * _Nonnull titleString, NSString * _Nonnull contentString, NSString * _Nonnull timeString, NSString * _Nonnull loacaString) {
          UILabel *titleLabel = (UILabel *)[self.myCarousel viewWithTag:300 + self.currentIndex];
          titleLabel.text = titleString;
          UILabel *contentLabel = (UILabel *)[self.myCarousel viewWithTag:888 + self.currentIndex];
          contentLabel.text = contentString;
          
          UILabel *timeLabel = (UILabel *)[self.myCarousel viewWithTag:1500 + self.currentIndex];
          timeLabel.text = timeString;
          
          UILabel *localLabel = (UILabel *)[self.myCarousel viewWithTag:5063 + self.currentIndex];
                 localLabel.text = loacaString;
          
          UIImageView *localImage = (UIImageView *)[self.myCarousel viewWithTag:254 + self.currentIndex];
          if (loacaString.length > 0) {
              localLabel.hidden = NO;
              localImage.hidden = NO;
          }
      };
      
      
      [self.navigationController pushViewController:wbjVc animated:YES];

      
      
}


- (void)createSubViewsWithView0:(UIView *)carouselView WithModel:(LZDataModel *)model Withindex:(NSInteger)index{
    
    
    UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(10), VIEW_W - kAUTOWIDTH(20), VIEW_W + kAUTOWIDTH(120) - kAUTOWIDTH(40))];
    cardView.layer.cornerRadius = kAUTOWIDTH(14);
    cardView.layer.masksToBounds = YES;
    cardView.backgroundColor = [UIColor whiteColor];
    [carouselView addSubview:cardView];
    cardView.tag = 200+index;


    UIImageView *misanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(10) + (VIEW_W + kAUTOWIDTH(120) - kAUTOWIDTH(40)), VIEW_W - kAUTOWIDTH(20), kAUTOWIDTH(15))];
        misanImageView.tag = 321+index;
    misanImageView.image = [UIImage imageNamed:@"misanyinying"];
    [carouselView addSubview:misanImageView];

    
    UILabel *indexLabel = [UILabel labelWithTitle:@"2018年1月20日" AndColor:@"ffffff" AndFont:14 AndAlignment:NSTextAlignmentCenter];
          indexLabel.alpha = 0.8;
    indexLabel.textColor = PNCColorWithHex(0x515151);
          indexLabel.frame = CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(20) + (VIEW_W + kAUTOWIDTH(120) - kAUTOWIDTH(40)), VIEW_W - kAUTOWIDTH(20), kAUTOWIDTH(20));
          indexLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:9];
          [carouselView addSubview:indexLabel];
           indexLabel.layer.shadowOffset =CGSizeMake(0, 0);
           indexLabel.layer.shadowColor = [UIColor grayColor].CGColor;
           indexLabel.layer.shadowRadius = 4;
           indexLabel.layer.shadowOpacity = 0.6;
           NSString *numberString =  [NSString stringWithFormat:@"%ld",index +1];
          indexLabel.text = [self transChinese: numberString];
       
    
    UIImageView *whImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), kAUTOWIDTH(0), VIEW_W - kAUTOWIDTH(20), cardViewH * 1)];
    whImageView.tag = 100+index;

    [cardView addSubview:whImageView];
    
    NSArray *imageNameArr = [model.email componentsSeparatedByString:@"&&++&&"];
   
    

    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:[imageNameArr firstObject]];
        whImageView.image = image;
            
    }else{
        [whImageView sd_setImageWithURL:[NSURL URLWithString:imageNameArr.firstObject] placeholderImage:[UIImage imageNamed:@"kongImage9.png"]];
    }
    
    
    whImageView.contentMode = UIViewContentModeScaleAspectFill;
    whImageView.layer.masksToBounds = YES;
    whImageView.backgroundColor = [UIColor whiteColor];
    
    whImageView.layer.shadowColor = PNCColorWithHex(0xdcdcdc).CGColor;
    whImageView.layer.shadowOffset = CGSizeMake(0, 0);
    whImageView.layer.shadowRadius = 15;
    whImageView.layer.shadowOpacity = 0.1;
    
    
        UISwipeGestureRecognizer * recognizer;
    
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [whImageView addGestureRecognizer:recognizer];
    whImageView.userInteractionEnabled = YES;
        
    
    
     UIImageView *locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), cardViewH - kAUTOWIDTH(140), kAUTOWIDTH(15), kAUTOWIDTH(15))];
     locationImage.image = [UIImage imageNamed:@"位置1"];
     locationImage.contentMode = UIViewContentModeScaleAspectFill;
     [cardView addSubview:locationImage];
    locationImage.tag = 254 +index;
     
     
     UILabel *localLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame) + kAUTOWIDTH(5),  cardViewH - kAUTOWIDTH(142), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(22))];
     localLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(9)];
     localLabel.textColor = PNCColorWithHex(0xffffff);
     localLabel.textAlignment = NSTextAlignmentLeft;
     localLabel.numberOfLines = 0;
    localLabel.tag = 5063+index;
     
     if (model.nickName.length<2) {
         localLabel.hidden = YES;
         locationImage.hidden = YES;
     }else{
     localLabel.text = model.nickName;
     }
    
     [cardView addSubview:localLabel];
     
    
    
    UIBlurEffect  *effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectViewT = [[UIVisualEffectView alloc] initWithEffect:effectT];
    effectViewT.frame = CGRectMake(0, cardViewH - kAUTOWIDTH(120), VIEW_W - kAUTOWIDTH(20), kAUTOWIDTH(120));
    effectViewT.alpha = 1.f;
    effectViewT.userInteractionEnabled = YES;
    [whImageView addSubview:effectViewT];
    
    
      UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMinY(effectViewT.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(22))];
      titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(13)];
      //    self.titleLabel.alpha = 0.4 ;
      titleLabel.textColor = PNCColorWithHex(0x1e1e1e);
      titleLabel.textAlignment = NSTextAlignmentCenter;
      [cardView addSubview:titleLabel];
      titleLabel.numberOfLines = 0;
      titleLabel.text = model.titleString;
      titleLabel.tag = 300 + index;
    
    
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(15))];
            contentLabel.font =  [UIFont systemFontOfSize:kAUTOWIDTH(11)];
            //    self.titleLabel.alpha = 0.4 ;
            contentLabel.textColor = PNCColorWithHex(0x515151);
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [cardView addSubview:contentLabel];
            contentLabel.numberOfLines = 0;
            contentLabel.text = model.contentString;
    contentLabel.tag = 888 + index;
    
     // 模仿cell创建的视图
           UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(contentLabel.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(15))];
          timeLabel.font =  [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(11)];
          timeLabel.textColor = PNCColorWithHex(0x777777);
          timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = model.colorString;
    
    timeLabel.tag = 1500 + index;
    [cardView addSubview:timeLabel];

        if (PNCisIPAD) {
            
            CGFloat padCardW = ScreenWidth - kAUTOWIDTH(220);
            CGFloat padCardH = ScreenWidth - kAUTOWIDTH(220) + kAUTOWIDTH(60);

            
            cardView.frame = CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(220),  ScreenWidth - kAUTOWIDTH(220) + kAUTOWIDTH(60));
             misanImageView.frame = CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(10) + (ScreenWidth - kAUTOWIDTH(220) + kAUTOWIDTH(60)),ScreenWidth - kAUTOWIDTH(220), kAUTOWIDTH(15));
           indexLabel.frame = CGRectMake(kAUTOWIDTH(10), PCTopBarHeight + kAUTOWIDTH(20) + (padCardH), padCardW, kAUTOWIDTH(20));
            whImageView.frame = CGRectMake(kAUTOWIDTH(0), kAUTOWIDTH(0),padCardW, padCardH);
            locationImage.frame =CGRectMake(kAUTOWIDTH(10), padCardH - kAUTOWIDTH(120), kAUTOWIDTH(15), kAUTOWIDTH(15));
            localLabel.frame = CGRectMake(CGRectGetMaxX(locationImage.frame) + kAUTOWIDTH(5),  padCardH - kAUTOWIDTH(122), padCardW - kAUTOWIDTH(30), kAUTOWIDTH(22));
            effectViewT.frame = CGRectMake(0, padCardH - (99), padCardW, (99));
           titleLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMinY(effectViewT.frame) + (12), padCardW - kAUTOWIDTH(30), (22));
           titleLabel.font = [UIFont boldSystemFontOfSize:(13)];

            contentLabel.frame =CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + (8), padCardW - kAUTOWIDTH(30), (25));
            contentLabel.font =  [UIFont systemFontOfSize:(9)];

           timeLabel.frame = CGRectMake((15),  padCardH - (30), padCardW - (30), (30));
            timeLabel.font =  [UIFont fontWithName:@"HeiTi SC" size:(11)];

        }

    
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

#pragma mark - iCarouselDelegate
//
//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
//
//    static CGFloat max_sacle = 1.0f;
//    static CGFloat min_scale = 0.6f;
//    if (offset <= 1 && offset >= -1) {
//        float tempScale = offset < 0 ? 1+offset : 1-offset;
//        float slope = (max_sacle - min_scale) / 1;
//
//        CGFloat scale = min_scale + slope*tempScale;
//        transform = CATransform3DScale(transform, scale, scale, 1);
//    }else{
//        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
//    }
//
//    return CATransform3DTranslate(transform, offset * self.myCarousel.itemWidth * 0.5, 0.0, 0.0);
//}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
//
//    GroupDetailViewController *middlePageToVc = [[GroupDetailViewController alloc] init];
//
//    middlePageToVc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    middlePageToVc.groupModel = [self.groupArray objectAtIndex:index];
//    [self.navigationController pushViewController:middlePageToVc animated:YES];
   
//    UIView *view = [self.myCarousel viewWithTag:1024+self.currentIndex];
//    view
    

    UIView *view = [self.myCarousel viewWithTag:1024+self.currentIndex];
    view.transform = CGAffineTransformMakeScale(1,1);
    
    UIImageView *misanImage = [self.myCarousel viewWithTag:321 + index];
    [UIView animateWithDuration:0.3 animations:^{
        misanImage.alpha = 0;

    }];
    
    
    
    LZDataModel *model = self.dataSourceArray[index];
    WHBianJiViewController *wbjVc = [[WHBianJiViewController alloc]init];
    wbjVc.model = model;
    wbjVc.bgImage = [self imageFromView];;
    wbjVc.modalPresentationStyle = UIModalPresentationFullScreen;
    wbjVc.currentIndex = self.currentIndex;
    
    wbjVc.backImageBlock = ^(UIImage * _Nonnull selImage) {
        UIImageView *imageView = (UIImageView *)[self.myCarousel viewWithTag:100+self.currentIndex];
        imageView.image = selImage;
    };
    
    wbjVc.backModelBlock = ^(NSString * _Nonnull titleString, NSString * _Nonnull contentString, NSString * _Nonnull timeString, NSString * _Nonnull loacaString) {
        UILabel *titleLabel = (UILabel *)[self.myCarousel viewWithTag:300 + self.currentIndex];
        titleLabel.text = titleString;
        UILabel *contentLabel = (UILabel *)[self.myCarousel viewWithTag:888 + self.currentIndex];
        contentLabel.text = contentString;

        UILabel *timeLabel = (UILabel *)[self.myCarousel viewWithTag:1500 + self.currentIndex];
        timeLabel.text = timeString;
        
        
                UILabel *localLabel = (UILabel *)[self.myCarousel viewWithTag:5063 + self.currentIndex];
                       localLabel.text = loacaString;
        
        UIImageView *localImage = (UIImageView *)[self.myCarousel viewWithTag:254 + self.currentIndex];
                if (loacaString.length > 0) {
                    localLabel.hidden = NO;
                    localImage.hidden = NO;
                }
        
    };
    
    
    [self.navigationController pushViewController:wbjVc animated:YES];

    
    
    
    
}

- (UIImage *)imageFromView {
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{

    CATransform3D transform = CATransform3DIdentity;
    // 立体
    transform.m34 = -1/1000.0;
    // 旋转
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 0, 1, 0);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    //    CATransform3D moveTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0, y));
    CATransform3D scal = CATransform3DScale(rotateTransform, 2, 2, 1);
    // 合并
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, scal);
    return concatTransform;
    
}


- (void)carouselDidScroll:(iCarousel *)carousel{
    self.currentIndex = carousel.currentItemIndex;
    
//    if (self.currentIndex == 11) {
//        for (UIButton *button1 in self.btnArray) {
//            if (button1.tag == 1024) {
//                button1.selected = YES;
//            }else{
//                button1.selected = NO;
//            }
//        }
//    }else if (self.currentIndex == 21){
//        for (UIButton *button1 in self.btnArray) {
//                   if (button1.tag == 1025) {
//                       button1.selected = YES;
//                   }else{
//                       button1.selected = NO;
//                   }
//               }
//    }
    
   
    
    
 
    
    NSLog(@"==========拖拽结束==========拖拽结束");

}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    NSLog(@"====================拖拽结束");
    
        if (self.currentIndex < 19) {
            for (UIButton *button1 in self.btnArray) {
                if (button1.tag == 2024) {
                    button1.selected = YES;
                }else{
                    button1.selected = NO;
                }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88888) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
            
        }else if (self.currentIndex < 33){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2025) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
                   }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88889) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }else if (self.currentIndex < 44){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2026) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88890) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }else if (self.currentIndex < 51){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2027) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88891) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }else if (self.currentIndex < 65){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2028) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88892) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }else if (self.currentIndex < 77){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2029) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88893) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
            
        }else if (self.currentIndex < 85){
            for (UIButton *button1 in self.btnArray) {
                       if (button1.tag == 2030) {
                           button1.selected = YES;
                       }else{
                           button1.selected = NO;
                       }
            }
            
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88894) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }else{
                for (UIButton *button1 in self.btnArray) {
                           if (button1.tag == 2031) {
                               button1.selected = YES;
                           }else{
                               button1.selected = NO;
                           }
                }
            for (UILabel *label in self.btnLabelArray) {
                               
                           if (label.tag == 88895) {
                               label.hidden = NO;
                           }else{
                               label.hidden = YES;
                           }
                           
                       }
        }
        
    
       if (self.dataSourceArray.count > 0) {
            
//            [UIView animateWithDuration:0.3 animations:^{
//                LZDataModel *model = self.dataSourceArray[carousel.currentItemIndex];
//                UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
//                self.bgImageView.image = image;
//            }];
        
        }
    
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel{
//    self.pageControl1.currentPage = carousel.currentItemIndex;

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.96f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.myCarousel.itemWidth * 1.04, 0.0, 0.0);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSInteger currentPage = targetContentOffset->x / [UIScreen mainScreen].bounds.size.width;
//    self.pageControl1.currentPage = currentPage;
   
}

#pragma mark --------------------------------------------------
#pragma mark - 代理
-(void)xh_PageControlClick:(XHPageControl*)pageControl index:(NSInteger)clickIndex{

//    NSLog(@"%ld",clickIndex);
////
//        CGPoint position = CGPointMake([UIScreen mainScreen].bounds.size.width * clickIndex, 0);
//        [_myCarousel scrollToItemAtIndex:clickIndex animated:YES];
  

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置navigaitonControllerDelegate
    self.navigationController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDate) name:@"RELOAD" object:self];

//    [self.myCarousel reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDate];
    });
    

//    WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
//    BOOL isreload = manager.isreload;
//    if (isreload) {
//        manager.isreload = NO;
//
//    }
    
    UIImageView *misanImage = [self.myCarousel viewWithTag:321 + self.currentIndex];
       [UIView animateWithDuration:0.3 animations:^{
           misanImage.alpha = 1;

       }];
    
    
    NSString *tag =  [[NSUserDefaults standardUserDefaults]objectForKey:@"pagecontrolicon"];
      if ([tag isEqualToString:@"xiantiao"]) {

              NSArray *imageNameArray = @[@"树木",@"鸡尾酒",@"拍立得",@"泡澡",@"日光浴",@"行旅箱",@"_冲浪",@"地图",@"长椅"];

          for (int i = 0; i < self.btnArray.count; i++) {
              UIButton * button = self.btnArray[i];
              [button setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateSelected];
          }
          
      }
    
    if ([tag isEqualToString:@"meishi"]) {

                          NSArray *imageNameArray = @[@"虾仁",@"波板糖",@"杯子蛋糕",@"香肠",@"鸡腿",@"柠檬干",@"开心果",@"瓜子",@"布丁"];
                       
                          for (int i = 0; i < self.btnArray.count; i++) {
                                       UIButton * button = self.btnArray[i];
                                       [button setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateSelected];
                                   }
                                   
    }
//    [self.collectionView reloadData];
    [self startAnimation];
}

// MARK: 设置代理
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self;
}

// MARK: 设置动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *cell = [self.myCarousel viewWithTag:1024+self.currentIndex];
    
//    UIView *cardView =
    WHBianJiViewController *toVC = (WHBianJiViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [toVC valueForKey:@"headerImageView"];

    UIView *fromView =  (UIView *)[self.view viewWithTag:200+self.currentIndex];
    UIView *containerView = [transitionContext containerView];
    UIImageView *imageView = (UIImageView *)[self.myCarousel viewWithTag:100+self.currentIndex];
    UIView *snapShotView = [[UIImageView alloc]initWithImage:imageView.image];
    snapShotView.contentMode = UIViewContentModeScaleAspectFill;
    snapShotView.layer.masksToBounds = YES;
    snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    
    fromView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toView.hidden = YES;
    
    self.subLayer.hidden = YES;
    LZDataModel *model = self.dataSourceArray[self.currentIndex];
    
//    snapShotView.backgroundColor = [UIColor redColor];
    
    UIBlurEffect  *effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
       UIVisualEffectView *effectViewT = [[UIVisualEffectView alloc] initWithEffect:effectT];
       effectViewT.frame = CGRectMake(0, cardViewH - kAUTOWIDTH(120), VIEW_W - kAUTOWIDTH(20), kAUTOWIDTH(120));
       effectViewT.alpha = 1.f;
       effectViewT.userInteractionEnabled = YES;
       [snapShotView addSubview:effectViewT];
       
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMinY(effectViewT.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(22))];
            titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(13)];
            //    self.titleLabel.alpha = 0.4 ;
            titleLabel.textColor = PNCColorWithHex(0x1e1e1e);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [snapShotView addSubview:titleLabel];
            titleLabel.numberOfLines = 0;
            titleLabel.text = model.titleString;
       
       UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(8), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(15))];
               contentLabel.font =  [UIFont systemFontOfSize:kAUTOWIDTH(11)];
               //    self.titleLabel.alpha = 0.4 ;
               contentLabel.textColor = PNCColorWithHex(0x515151);
               contentLabel.textAlignment = NSTextAlignmentCenter;
               contentLabel.numberOfLines = 0;
               contentLabel.text = model.contentString;
       
        // 模仿cell创建的视图
              UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(-kAUTOWIDTH(20),  CGRectGetMaxY(contentLabel.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(15))];
             timeLabel.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(11)];
             timeLabel.textColor = PNCColorWithHex(0x7777777);
             timeLabel.textAlignment = NSTextAlignmentCenter;
       timeLabel.text = model.colorString;

    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 30)];
//    titleLabel.textColor = COLOR_WHITE;
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.font = FONT_B(25);
//    titleLabel.text = cell.titleLabel.text;
    
//    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREEN_WIDTH-40)*1.3-30, SCREEN_WIDTH-44, 15)];
//    contentLabel.font = FONT_PF(15);
//    contentLabel.textColor = COLOR_WHITE;
//    contentLabel.textAlignment = NSTextAlignmentLeft;
//    contentLabel.alpha = 0.5;
//    contentLabel.text =cell.contentLabel.text;
    [snapShotView addSubview:titleLabel];
//    [snapShotView addSubview:contentLabel];
//    [snapShotView addSubview:timeLabel];

    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:.7f initialSpringVelocity:.8f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [containerView layoutIfNeeded];
        toVC.view.alpha = 1.0f;
        effectViewT.alpha = 0.f;
        
//         Tabbar*tabBar = (Tabbar *)self.tabBarController.tabBar;
//        if (IPHONE_X) {
//            tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 83);
//        } else {
//            tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49);
//        }
        snapShotView.frame = [containerView convertRect:toView.frame fromView:toView.superview];
        titleLabel.frame = CGRectMake(kAUTOWIDTH(60), ScreenWidth - kAUTOWIDTH(1), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(22));
        titleLabel.alpha = 0;
        contentLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(25));
//        timeLabel.frame = CGRectMake(kAUTOWIDTH(15),  ScreenHeight- kAUTOWIDTH(120) - kAUTOWIDTH(50), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(30));
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        fromView.hidden = NO;
        [snapShotView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
//        [self loadDate];

    }];
    
}





@end
