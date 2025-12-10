//
//  WHBianJiViewController.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/2/8.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHBianJiViewController.h"
#import "WHNewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "DatePickerView.h"
#import <SKGuideView.h>
#import "SettingViewController.h"
#import <StoreKit/StoreKit.h>
#import <HeWeather_Plugin/HeWeather_Plugin.h>
#import <RITLPhotos/RITLPhotos.h>
#import "WHTongBuViewController.h"

#define VIEW_W ScreenWidth - kAUTOWIDTH(50)
#define VIEW_H ScreenWidth
#define cardViewW  VIEW_W - kAUTOWIDTH(20)
#define cardViewH  VIEW_W + kAUTOWIDTH(115)

#define SETVIEW_HEIGHT  kAUTOHEIGHT(200)


@interface WHBianJiViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate,UIGestureRecognizerDelegate,DatePickerViewDelegate,CLLocationManagerDelegate,RITLPhotosViewControllerDelegate,LoopBannerView>{
    UIView * _backWindowView;
        CGFloat cellHeight;
        CGFloat startPointX;
        CGFloat startPointY;
        CGFloat scale;
        BOOL isHorizontal;

}
@property (nonatomic,strong) UIView *setView;
@property (nonatomic,strong) UIView *whiteBackView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) double jingDu;
@property (nonatomic, assign) double weiDu;

@property (nonatomic, strong) CLGeocoder *geoC;


@property (nonatomic, strong)  UIView *editView;
@property (nonatomic, strong)  UIBlurEffect *effect;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UILabel *editLabel;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentTextField;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *timeText;

@property(nonatomic,strong) DatePickerView * pikerView;
@property(nonatomic,copy)NSString * selectValue;

@property (nonatomic,strong) UIButton *gengDuoBtn;

@property (nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,copy) NSString *cityName;

@property (nonatomic, assign)CGSize assetSize;
@property (nonatomic, strong)NSArray<NSString *> *saveAssetIds;
@property (nonatomic, strong)NSArray<UIImage *> *assets;


@property (nonatomic, strong)UIImageView *bianJiIconImageView;
@property (nonatomic, strong)NSMutableArray *imageWanZhengNameArr;
@end

@implementation WHBianJiViewController


- (void)startLocate{

// 判断定位操作是否被允许

    if([CLLocationManager locationServicesEnabled]) {

        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
// 开始定位
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }else{}
}

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
//            self.localLabel.text = self.cityName;
            if (!city) {

//四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市
            city = placemark.administrativeArea;
            self.cityName = city;
//            self.localLabel.text = self.cityName;
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
    }
}

- (void)createTianQi{
//    [self setHeFengPluginViewTypeHorizontal];
    [self setHeFengPluginViewTypeLeftLarge];
//    [self setHeFengPluginViewTypeRightLarge];
//    [self setHeFengPluginViewTypeVertical];
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

    
    if (PNCisIPAD) {
       [self showViewWithFrame:CGRectMake(ScreenWidth/2 - (25), CGRectGetMaxY(self.titleLabel.frame) + (10), (25), (25)) Type:HeFengPluginViewTypeLeftLarge typeArray:
          @[@[@(HeFengConfigModelTypeWeatherStateIcon)],@[],@[]]];
    }else{
        [self showViewWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(25), CGRectGetMaxY(self.titleLabel.frame) + kAUTOWIDTH(10), kAUTOWIDTH(25), kAUTOWIDTH(25)) Type:HeFengPluginViewTypeLeftLarge typeArray:
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
        //@(HeFengConfigModelTypeLocation)
        ],
        //第三个数组内元素会被放在右边下部分布局上
        @[
        //    @(HeFengConfigModelTypeWeatherState),
        //@(HeFengConfigModelTypeWindDirIcon),
        //@(HeFengConfigModelTypeWindSC),
        //@(HeFengConfigModelTypePcpnIcon),
        //@(HeFengConfigModelTypePcpn)
        ]]];
    }
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
    view.userInteractionEnabled = NO;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.model == nil) {
        self.model = [[LZDataModel alloc]init];
        self.model.userName = @"";
        self.model.nickName = @"0";
        self.model.password = @"";
        self.model.urlString = @"isDone";
        self.model.dsc = @"noLike";
        self.model.groupName = @"";
        self.model.titleString = @"添加一条余生标题";
        self.model.contentString =@"添加一条余生内容";
        self.model.colorString =@"添加日期";
       
        self.createFlag = @"1";
        
        NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
        if ([kIsNewVersionString isEqualToString:@"1"]) {
            UIImage *image = [UIImage imageNamed:@"kongImage9.png"];
           
            NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
            NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
            NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
            self.model.pcmData = imageBackDataString;
            self.model.email = [imageBackDataString stringByAppendingString:@"&&++&&"];
            
        }else{

            NSString *imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030134623839.jpg";
            self.model.pcmData = imageName;
            self.model.email = [imageName stringByAppendingString:@"&&++&&"];
            
        }
        
    }
    
    
    [self createSubViews];
    [self initData];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstguide2"]){
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstguide2"];
               [self guide];
           }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self startLocate];
}

-(void)guide{
    [SKGuideView share].dataArr = @[@[self.headerImageView,self.gengDuoBtn],
                                    @[@"点击更换为您的照片",@"点击编辑您的往后余生"]];
}

- (void)initData {
    
    self.dataSourceArray =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSourceArray= array.mutableCopy;
    
    
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    }
    return _bgImageView;
}


#pragma mark - 下拉缩小，跳转

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {   // 手势开始
            CGPoint currentPoint =[pan locationInView:self.scrollView];
            startPointY = currentPoint.y;
            startPointX = currentPoint.x;
            // 确定是否可以横划，判断起始点位置
            if (startPointX>30) {
                isHorizontal = NO;
            } else {
                isHorizontal = YES;
            }
        } break;
        case UIGestureRecognizerStateChanged: { // 手势状态改变
            
            CGPoint currentPoint =[pan locationInView:self.scrollView];
            // 如果可以横划，判断是横划还是竖划
            if (isHorizontal) {
                if ((currentPoint.x-startPointX)>(currentPoint.y-startPointY)) {
                    scale = (ScreenWidth-(currentPoint.x-startPointX))/ScreenWidth;
                } else {
                    scale = (ScreenHeight-(currentPoint.y-startPointY))/ScreenHeight;
                }
            } else {
                scale = (ScreenHeight-(currentPoint.y-startPointY))/ScreenHeight;
            }
            if (scale > 1.0f) {
                scale = 1.0f;
            } else if (scale <=0.8f) {
                scale = 0.8f;
                
//              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                     [self.navigationController popViewControllerAnimated:YES];
//                });
                
            }
            if (self.scrollView.contentOffset.y<=0) {
                // 缩放
                self.scrollView.transform = CGAffineTransformMakeScale(scale, scale);
                // 圆角
                self.scrollView.layer.cornerRadius = 15 * (1-scale)*5*1.08;
            }
            
            if (scale < 0.99) {
                [self.scrollView setScrollEnabled:NO];
            } else {
                [self.scrollView setScrollEnabled:YES];
            }
        } break;
        case UIGestureRecognizerStateEnded:  { // 手势结束
            scale = 1;
            self.scrollView.scrollEnabled = YES;
            if (scale>0.8) {
                [BCShanNianKaPianManager maDaQingZhenDong];
                [UIView animateWithDuration:0.2 animations:^{
                    self.scrollView.layer.cornerRadius = 0;
                    self.scrollView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }

            
        
                [self popUpdate];


           
    
            
          
            
            
        }  break;
        default:
            break;
    }
}


- (void)createSubViews{
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    [self.view addSubview:self.scrollView];
  
    if (![self.pushFlag isEqualToString:@"0"]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.scrollView addGestureRecognizer:pan];
        }
    
        // 背景图
        [self.scrollView addSubview:self.bgImageView];
        self.bgImageView.image = self.bgImage;
        // 背景毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.scrollView addSubview:effectView];
    
//        self.headerImageView = [[LoopBannerView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenWidth)];
//        self.headerImageView.placeholderImage = [UIImage imageNamed:@"003.jpg"];
//        self.headerImageView.delegate = self;
//        [self.scrollView addSubview: self.headerImageView];

    
    self.imageWanZhengNameArr = [[NSMutableArray alloc] init];

    
    self.headerImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth) delegate:self placeholderImage:kPlaceholderImage];
    self.headerImageView.backgroundColor = [UIColor clearColor];
    self.headerImageView.autoScrollTimeInterval = 3;
    self.headerImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.headerImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.headerImageView.pageControlDotSize = CGSizeMake(kAUTOWIDTH(5), kAUTOWIDTH(5));
//    self.headerImageView.pageDotColor = [[RNThemeManager sharedManager] colorForKey:@"777777TextColor"];
//    self.headerImageView.currentPageDotColor = [[RNThemeManager sharedManager] colorForKey:@"101010TextColor"];
    self.headerImageView.delegate = self;
    [self.view addSubview:self.headerImageView];
    
    
        NSMutableArray *imageArr = [[NSMutableArray alloc]init];
        NSArray *imageNameArr = [self.model.email componentsSeparatedByString:@"&&++&&"];
    
        
        NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
            if ([kIsNewVersionString isEqualToString:@"1"]) {
    
                for (int i = 0; i < imageNameArr.count; i++) {
                    NSString *string = imageNameArr[i];
                    
                    UIImage *image = nil;
                    if (string.length > 0) {
                         image = [ChuLiImageManager decodeEchoImageBaseWith:imageNameArr[i]];
                        [imageArr addObject:image];

                    }else{
                    }
                    
                    
                }
                
            }else{
                
                for (int i = 0; i < imageNameArr.count; i++) {
                    NSString *imageUrlName = imageNameArr[i];
                    if (imageUrlName.length > 0) {
                        [imageArr addObject:imageUrlName];
                    }
                }
            }
    
        self.headerImageView.imageURLStringsGroup = imageArr;

    self.imageWanZhengNameArr = [imageArr mutableCopy];
//
//    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), 0, ScreenWidth - kAUTOWIDTH(0), ScreenWidth)];
//    self.headerImageView.image = [ChuLiImageManager decodeEchoImageBaseWith:self.model.pcmData];
//    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.headerImageView.layer.masksToBounds = YES;////    self.imageView
//    [self.scrollView addSubview:self.headerImageView];
//    self.headerImageView.userInteractionEnabled = YES;
//
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addKuImage)];
    [self.headerImageView addGestureRecognizer: tap];
    
    self.locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(45), kAUTOWIDTH(20), kAUTOWIDTH(20))];
    self.locationImage.image = [UIImage imageNamed:@"位置1"];
    self.locationImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerImageView addSubview:self.locationImage];
    
    
    
    self.localLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.locationImage.frame) + kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(45), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(22))];
    self.localLabel.font = PNCisIPAD ? [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:(12)] : [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(10)];
    self.localLabel.textColor = PNCColorWithHex(0xffffff);
    self.localLabel.textAlignment = NSTextAlignmentLeft;
    self.localLabel.numberOfLines = 0;
    
    if (PNCisIPAD) {
    self.locationImage.frame = CGRectMake(kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(45), kAUTOWIDTH(20), kAUTOWIDTH(20));
    self.localLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + (10), ScreenWidth - (45), ScreenWidth - (30), (22));
    }
    
    
    if (self.model.nickName.length<2) {
        self.localLabel.hidden = YES;
        self.locationImage.hidden = YES;
    }else{
    self.localLabel.text = self.model.nickName;
    }
   
    [self.headerImageView addSubview:_localLabel];
    
 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.headerImageView.frame) + kAUTOWIDTH(30), kAUTOWIDTH(50), kAUTOWIDTH(30));
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updateDB) forControlEvents:UIControlEventTouchUpInside];

    UIButton *fanHuiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fanHuiButton.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(45),ScreenHeight - kAUTOWIDTH(49), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [fanHuiButton setImage:[UIImage imageNamed:@"操作-关闭"] forState:UIControlStateNormal];
    [self.scrollView addSubview:fanHuiButton];
    [fanHuiButton addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.gengDuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gengDuoBtn.frame = CGRectMake(kAUTOWIDTH(15),ScreenHeight - kAUTOWIDTH(49), kAUTOWIDTH(25), kAUTOWIDTH(25));
    [self.gengDuoBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.gengDuoBtn];
    [self.gengDuoBtn addTarget:self action:@selector(createSetView) forControlEvents:UIControlEventTouchUpInside];
        
    
    
     self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.headerImageView.frame) + kAUTOWIDTH(30), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(22))];
     self.titleLabel.font = PNCisIPAD? [UIFont boldSystemFontOfSize:(17)] : [UIFont boldSystemFontOfSize:kAUTOWIDTH(16)];
     self.titleLabel.textColor = PNCColorWithHex(0x515151);
     self.titleLabel.textAlignment = NSTextAlignmentCenter;
     self.titleLabel.numberOfLines = 0;
     self.titleLabel.text = self.model.titleString;
    if (PNCisIPAD) {
        self.titleLabel.frame = CGRectMake((15), CGRectGetMaxY(self.headerImageView.frame) + (30), ScreenWidth - (30), (22));
    }
    
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(135),  ScreenHeight - LZTabBarHeight - kAUTOWIDTH(40), kAUTOWIDTH(115), kAUTOWIDTH(30))];
    self.timeLabel.font = PNCisIPAD ? [UIFont fontWithName:@"Futura" size:(11)] : [UIFont fontWithName:@"Futura" size:kAUTOWIDTH(11)];
    self.timeLabel.textColor = PNCColorWithHex(0x515151);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    if (PNCisIPAD) {
        self.titleLabel.frame = CGRectMake((15), CGRectGetMaxY(self.headerImageView.frame) + (30), ScreenWidth - (30), (22));
        self.timeLabel.frame = CGRectMake(ScreenWidth - (135),  ScreenHeight - LZTabBarHeight - (40), (115), (30));

    }
    
    
     if (self.model.colorString.length > 0) {
         self.timeLabel.text = self.model.colorString;

     }else{
         self.timeLabel.text = @"某年某月某日";

     }
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.titleLabel.frame) + kAUTOWIDTH(38), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(25))];
    if (PNCisIPAD) {
        self.titleLabel.frame = CGRectMake((15), CGRectGetMaxY(self.headerImageView.frame) + (30), ScreenWidth - (30), (22));
        self.timeLabel.frame = CGRectMake(ScreenWidth - (135),  ScreenHeight - LZTabBarHeight - (40), (115), (30));
        self.contentLabel.frame = CGRectMake((15), CGRectGetMaxY(self.titleLabel.frame) + (38), ScreenWidth - (30), (25));
        fanHuiButton.frame = CGRectMake(ScreenWidth - (45),ScreenHeight - (49), (25), (25));
        self.gengDuoBtn.frame = CGRectMake((15),ScreenHeight - (49), (25), (25));

    }
    
    
    self.contentLabel.font = PNCisIPAD ? [UIFont systemFontOfSize:(12)] : [UIFont systemFontOfSize:kAUTOWIDTH(10)];
    self.contentLabel.textColor = PNCColorWithHex(0x515151);
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = self.model.contentString;
    [self.contentLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.titleLabel.frame) + kAUTOWIDTH(42), ScreenWidth - kAUTOWIDTH(30),self.contentLabel.frame.size.height);
          
    if (PNCisIPAD) {
          self.titleLabel.frame = CGRectMake((15), CGRectGetMaxY(self.headerImageView.frame) + (30), ScreenWidth - (30), (22));
          self.timeLabel.frame = CGRectMake(ScreenWidth - (135),  ScreenHeight - LZTabBarHeight - (40), (115), (30));
          self.contentLabel.frame = CGRectMake((15), CGRectGetMaxY(self.titleLabel.frame) + (42), ScreenWidth - (30),self.contentLabel.frame.size.height);
          fanHuiButton.frame = CGRectMake(ScreenWidth - (45),ScreenHeight - (49), (25), (25));
          self.gengDuoBtn.frame = CGRectMake((15),ScreenHeight - (49), (25), (25));

      }
 
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.timeLabel];
    
    
    self.titleLabel.userInteractionEnabled = YES;
    self.contentLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editContent)];
    [self.titleLabel addGestureRecognizer:editTap];
    
    UITapGestureRecognizer *editTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editContent)];
    [self.contentLabel addGestureRecognizer:editTap2];
    

}

- (NSString *)getTimeString{
    NSString *currentDay = [BCShanNianKaPianManager getCurrentTimes];
    
  
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
   NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *comps = [[NSDateComponents alloc] init];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |

    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDate *now = [NSDate date];

    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN

    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    comps = [calendar components:unitFlags fromDate:now];


   
    NSString *timeString = [NSString stringWithFormat:@"%@. %@月%@ / %@",[weekdays objectAtIndex:[comps weekday] - 1],[currentDay substringWithRange:NSMakeRange(5, 2)],[currentDay substringWithRange:NSMakeRange(8, 2)],[currentDay substringToIndex:4]];

    return timeString;
}

-(void)changeLabelStyle:(UIView *)label{
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
maskLayer.frame = label.bounds;
maskLayer.path = maskPath.CGPath;
label.layer.mask = maskLayer;
}

- (void)createSetView{
    [BCShanNianKaPianManager maDaZhongJianZhenDong];
    
    self.setView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.setView.backgroundColor = PNCColorWithHexA(0x000000, 0.4);
    [self.view addSubview:self.setView];
    self.setView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSetView)];
    [self.setView addGestureRecognizer:tap];
    
    _whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), ScreenHeight - SETVIEW_HEIGHT - kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(40), SETVIEW_HEIGHT)];
    _whiteBackView.layer.cornerRadius = PNCisIPAD ? 12 : kAUTOWIDTH(12);
    _whiteBackView.layer.masksToBounds = YES;
//    [self changeLabelStyle:_whiteBackView];
    
    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
        _whiteBackView.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight - SETVIEW_HEIGHT - kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(40), SETVIEW_HEIGHT);
    }
    
    
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.setView addSubview:_whiteBackView];
    
    UIView *setView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SETVIEW_HEIGHT/4)];
    UIView *setView2 = [[UIView alloc]initWithFrame:CGRectMake(0, SETVIEW_HEIGHT/4, ScreenWidth, SETVIEW_HEIGHT/4)];
    UIView *setView3 = [[UIView alloc]initWithFrame:CGRectMake(0, SETVIEW_HEIGHT*2/4,ScreenWidth, SETVIEW_HEIGHT/4)];
    UIView *setView4 = [[UIView alloc]initWithFrame:CGRectMake(0, SETVIEW_HEIGHT*3/4,ScreenWidth, SETVIEW_HEIGHT/4)];
    
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
    [_whiteBackView addSubview:setView4];

    UIView *cutLineView1 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    UIView *cutLineView2 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 0.5)];

    UIView *cutLineView3 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 0.5)];

    cutLineView1.backgroundColor =PNCColorWithHexA(0xdcdcdc, 0.4);
    cutLineView2.backgroundColor = PNCColorWithHexA(0xdcdcdc, 0.4);
    cutLineView3.backgroundColor = PNCColorWithHexA(0xdcdcdc, 0.4);

    [setView2 addSubview:cutLineView1];
    [setView3 addSubview:cutLineView2];
    [setView4 addSubview:cutLineView3];

    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"喜欢"]];
    imageView1.frame = CGRectMake(15, SETVIEW_HEIGHT/8 - 12.5, 25, 25);
    [setView1 addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分享"]];
    imageView2.frame = CGRectMake(15, SETVIEW_HEIGHT/8 - 12.5, 25, 25);
    [setView2 addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"记事"]];
    imageView3.frame = CGRectMake(15, SETVIEW_HEIGHT/8 - 12.5, 25, 25);
    [setView3 addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"删除1"]];
    imageView4.frame = CGRectMake(15, SETVIEW_HEIGHT/8 - 12.5, 25, 25);
    [setView4 addSubview:imageView4];
    
    UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(CGRectGetMaxX(imageView1.frame) , 0, 90, SETVIEW_HEIGHT/4);
    
    UIButton *button4 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(CGRectGetMaxX(button1.frame) , 0, 200, SETVIEW_HEIGHT/4);
    
    
//    LZDataModel *model = self.model;
//    self.dataSourceArray[self.currentIndex];
    
    if ([self.model.dsc isEqualToString:@"isLike"]) {
        button1.selected = YES;
    }else{
        button1.selected = NO;
    }
    
    [button1 setTitle:@"收藏" forState:UIControlStateNormal];
//    [button1 setImage:[UIImage imageNamed:@"爱情"] forState:UIControlStateNormal];

    [button1 setTitle:@"已收藏" forState:UIControlStateSelected];
//    [button1 setImage:[UIImage imageNamed:@"不喜欢"] forState:UIControlStateSelected];

    button1.titleLabel.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(13)];
    [button1 setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
    button1.titleLabel.textAlignment = NSTextAlignmentLeft;

    [setView1 addSubview:button1];
    [setView1 addSubview:button4];
    
    
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(CGRectGetMaxX(imageView2.frame) , 0, 90, SETVIEW_HEIGHT/4);
    [button2 setTitle:@"保存" forState:UIControlStateNormal];
    button2.titleLabel.textAlignment = NSTextAlignmentLeft;
    button2.titleLabel.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(13)];
   [button2 setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];

    button2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [setView2 addSubview:button2];
    
    UIButton *button5 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = CGRectMake(CGRectGetMaxX(button2.frame) , 0, 200, SETVIEW_HEIGHT/4);
    [setView2 addSubview:button5];
    
    
    UIButton *button3 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(CGRectGetMaxX(imageView3.frame) , 0, 90, SETVIEW_HEIGHT/4);
    [button3 setTitle:@"编辑" forState:UIControlStateNormal];
    button3.titleLabel.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(13)];
    [button3 setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
    button3.titleLabel.textAlignment = NSTextAlignmentLeft;
    [setView3 addSubview:button3];
    
    UIButton *button6 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button6.frame = CGRectMake(CGRectGetMaxX(button3.frame) , 0, 200, SETVIEW_HEIGHT/4);
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
    
    
    UIButton *button7 =  [UIButton buttonWithType:UIButtonTypeCustom];
       button7.frame = CGRectMake(CGRectGetMaxX(imageView4.frame) , 0, 90, SETVIEW_HEIGHT/4);
       [button7 setTitle:@"删除" forState:UIControlStateNormal];
       button7.titleLabel.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(13)];
       [button7 setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
       button7.titleLabel.textAlignment = NSTextAlignmentLeft;
       [setView4 addSubview:button7];
    
    UIButton *button8 =  [UIButton buttonWithType:UIButtonTypeCustom];
       button8.frame = CGRectMake(CGRectGetMaxX(button7.frame) , 0, 200, SETVIEW_HEIGHT/4);
       [setView4 addSubview:button8];
    [button7 addTarget:self action:@selector(deleateWangHou) forControlEvents:UIControlEventTouchUpInside];
    [button8 addTarget:self action:@selector(deleateWangHou) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView8 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"皇冠"]];
    imageView8.frame = PNCisIPAD ? CGRectMake(ScreenWidth - kAUTOWIDTH(80), SETVIEW_HEIGHT/8 - (7.5), (15), (15)) : CGRectMake(ScreenWidth - kAUTOWIDTH(80), SETVIEW_HEIGHT/8 - kAUTOWIDTH(7.5), kAUTOWIDTH(15), kAUTOWIDTH(15));
    [setView4 addSubview:imageView8];
       
    
    button1.tag = 1002;
    
}

- (void)deleateWangHou{
    
    
    
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    NSLog(@"会员===%@",[BCUserDeafaults objectForKey:ISBUYVIP]);
    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"0"]) {
        
        SettingViewController *settingVc = [[SettingViewController alloc]init];
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:settingVc animated:YES];
        settingVc.kaiguanFlag = @"1";
        LZWeakSelf(weakSelf);
        settingVc.buySuccessBlock = ^(BOOL isSuccess) {
            if (isSuccess) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你确定要删除这一件『往后余生』吗？" message:@"注意此操作不能撤销" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                     
                    }];
                       
                    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:self.model];
                        weakSelf.navigationController.delegate = nil;
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                        WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
                        manager.isreload = YES;
                       }];
                       
                       [alertController addAction:cancelAction];
                       [alertController addAction:otherAction];
                       [weakSelf presentViewController:alertController animated:YES completion:nil];
                       
            
            }else{
                
            }
        };
        
        
        
        [settingVc initNeiGouView3];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你确定要删除这一件『往后余生』吗？" message:@"注意此操作不能撤销" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                 
                }];
                   
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:self.model];
                    self.navigationController.delegate = nil;
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
                    manager.isreload = YES;
                   }];
                   
                   [alertController addAction:cancelAction];
                   [alertController addAction:otherAction];
                   [self presentViewController:alertController animated:YES completion:nil];
                   
    }
}

- (void)shareImage{
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    NSString *text = @"往后余生";
    UIView * shareImageView = [[UIView alloc]initWithFrame:self.view.bounds];
    shareImageView.backgroundColor = PNCColorRGBA(242, 241, 237, 1);
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), PCTopBarHeight + kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(30))];
    nameLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
    nameLabel.textColor = PNCColorWithHex(0x1e1e1e);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 0;
    NSString *numberString =  [NSString stringWithFormat:@"%ld",self.currentIndex + 1];
    nameLabel.text =[NSString stringWithFormat:@"我们的第%@件『往后余生』",[self transChinese:numberString]] ;
    [shareImageView addSubview:nameLabel];
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + kAUTOWIDTH(30),ScreenWidth, ScreenWidth)];
  
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        headerImageView.image = [self.headerImageView.imageURLStringsGroup firstObject];

    }else{
        [headerImageView sd_setImageWithURL:self.headerImageView.imageURLStringsGroup.firstObject placeholderImage:kPlaceholderImage];
    }
    
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.masksToBounds = YES;////    self.imageView
    [shareImageView addSubview:headerImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(headerImageView.frame) + kAUTOWIDTH(30), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(22))];
    titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(13)];
    titleLabel.textColor = PNCColorWithHex(0x1e1e1e);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.model.titleString;
    [shareImageView addSubview:titleLabel];
             
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(25))];
    contentLabel.font = [UIFont systemFontOfSize:kAUTOWIDTH(9)];
    contentLabel.textColor = PNCColorWithHex(0x515151);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.model.contentString;
    [contentLabel sizeToFit];
    [shareImageView addSubview:contentLabel];
    
    contentLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(30),self.contentLabel.frame.size.height);
              // 模仿cell创建的视图
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15),CGRectGetMaxY(contentLabel.frame) + kAUTOWIDTH(30), kAUTOWIDTH(135), kAUTOWIDTH(30))];
    timeLabel.font =  [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(11)];
    timeLabel.textColor = PNCColorWithHex(0x515151);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = self.model.colorString;
    [shareImageView addSubview:titleLabel];
    
    
    UILabel *appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(60), kAUTOWIDTH(350) - kAUTOWIDTH(45), kAUTOWIDTH(120), kAUTOWIDTH(20))];
       appNameLabel.textAlignment = NSTextAlignmentLeft;
       appNameLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
       appNameLabel.textColor = [UIColor blackColor];
       appNameLabel.text = @"往后余生 - The rest of life";
       [appNameLabel sizeToFit];
       appNameLabel.frame = CGRectMake(ScreenWidth/2 - appNameLabel.frame.size.width/2 + kAUTOWIDTH(20), ScreenHeight - LZTabBarHeight - kAUTOWIDTH(50),appNameLabel.frame.size.width, kAUTOWIDTH(20));
       [shareImageView addSubview:appNameLabel];

       UILabel *solgonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(appNameLabel.frame) + kAUTOWIDTH(10), CGRectGetMaxY(appNameLabel.frame), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(20))];
       solgonLabel.textAlignment = NSTextAlignmentLeft;
       solgonLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(8)];
       solgonLabel.textColor = [UIColor grayColor];
       solgonLabel.text = @"情侣必做的100件小事";
       [solgonLabel sizeToFit];
       solgonLabel.frame = CGRectMake(CGRectGetMinX(appNameLabel.frame), CGRectGetMaxY(appNameLabel.frame), ScreenWidth - kAUTOWIDTH(30), solgonLabel.frame.size.height);

       [shareImageView addSubview:solgonLabel];

       UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(appNameLabel.frame) - kAUTOWIDTH(40),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(50), kAUTOWIDTH(30), kAUTOWIDTH(30))];
       iconImageView.image = [UIImage imageNamed:@"iconNew1024.png"];
       [shareImageView addSubview:iconImageView];
       iconImageView.layer.cornerRadius = kAUTOWIDTH(4);
       iconImageView.layer.masksToBounds = YES;

       CALayer *subLayer=[CALayer layer];
       CGRect fixframe=iconImageView.layer.frame;
       subLayer.frame = fixframe;
       subLayer.cornerRadius = kAUTOWIDTH(8);
       subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
       subLayer.masksToBounds=NO;
       subLayer.shadowColor=[UIColor grayColor].CGColor;
       subLayer.shadowOffset=CGSizeMake(0,4);
       subLayer.shadowOpacity=0.6f;
       subLayer.shadowRadius= 12;
       [shareImageView.layer insertSublayer:subLayer below:iconImageView.layer];

       if (PNCisIPHONEX) {
           iconImageView.frame = CGRectMake(CGRectGetMinX(appNameLabel.frame) - kAUTOWIDTH(40),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(50), kAUTOWIDTH(30), kAUTOWIDTH(30));
           appNameLabel.frame = CGRectMake(ScreenWidth/2 - appNameLabel.frame.size.width/2 + kAUTOWIDTH(20), ScreenHeight - LZTabBarHeight - kAUTOWIDTH(50),appNameLabel.frame.size.width, kAUTOWIDTH(20));
           solgonLabel.frame = CGRectMake(CGRectGetMinX(appNameLabel.frame), CGRectGetMaxY(appNameLabel.frame), ScreenWidth - kAUTOWIDTH(30), solgonLabel.frame.size.height);
           fixframe=iconImageView.layer.frame;
           subLayer.frame = fixframe;
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(40),ScreenHeight - LZTabBarHeight - kAUTOWIDTH(95), kAUTOWIDTH(80), kAUTOWIDTH(80))];
//    codeImageView.image = [UIImage imageNamed:@"二维码图片_3月25日22时29分41秒"];
//    [self.view addSubview:codeImageView];
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(codeImageView.frame) + kAUTOWIDTH(5), ScreenWidth, kAUTOWIDTH(30))];
//    nameLabel.text = @"往后余生";
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(18)];
//    [shareImageView addSubview:nameLabel];
//
//
    
    UIImage *shareimage = [self convertImageViewToImage:shareImageView];
    
    
    
    NSArray *activityItems = @[text,shareimage];
    
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

-(UIImage*)convertImageViewToImage:(UIView*)view{
    CGSize s = CGSizeMake(view.frame.size.width, view.frame.size.height);
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}





- (void)editContent{
    self.editView = [[UIView alloc]initWithFrame:self.view.bounds];
   
    [self.view addSubview:self.editView];
    
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];
    self.effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.editView addSubview:self.effectView];
    
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), ScreenHeight/2 - kAUTOWIDTH(120), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(270))];
    [self.editView addSubview:self.addView];
    
    
//     self.addView.transform = CGAffineTransformMakeScale(0.7, 0.7);    // 先缩小
           // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.9 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
     self.addView.frame =CGRectMake(kAUTOWIDTH(15), ScreenHeight/2 - kAUTOWIDTH(160), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(270));
//        self.addView.transform = CGAffineTransformMakeScale(1, 1);        // 放大
           } completion:nil];
    
    self.addView.backgroundColor = [UIColor whiteColor];
    self.addView.layer.cornerRadius = kAUTOWIDTH(8);
    self.addView.layer.masksToBounds = YES;
    
    self.editLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(45), kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(120), kAUTOWIDTH(25))];
    self.editLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(15)];
    self.editLabel.textColor = PNCColorWithHex(0x1e1e1e);
    self.editLabel.textAlignment = NSTextAlignmentCenter;
    self.editLabel.numberOfLines = 0;
    self.editLabel.text = @"编辑内容";
    [self.addView addSubview:self.editLabel];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(kAUTOWIDTH(15), kAUTOWIDTH(10), kAUTOWIDTH(25), kAUTOWIDTH(25));
    leftBtn.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(13)];
    [leftBtn setImage:[UIImage imageNamed:@"叉号caise"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(guanbiedit) forControlEvents:UIControlEventTouchUpInside];

    [self.addView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(30) - kAUTOWIDTH(25) - kAUTOWIDTH(15), kAUTOWIDTH(10), kAUTOWIDTH(25), kAUTOWIDTH(25));
    rightBtn.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:kAUTOWIDTH(13)];
    [rightBtn setImage:[UIImage imageNamed:@"对号caise"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:PNCColorWithHex(0x1e1e1e) forState:UIControlStateNormal];
    [self.addView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(rightBtn.frame) + kAUTOWIDTH(5), ScreenWidth - kAUTOWIDTH(30) - kAUTOWIDTH(30), kAUTOWIDTH(2))];
    lineView1.backgroundColor = PNCColorWithHex(0xdcdcdc);
    
    lineView1.layer.cornerRadius = kAUTOWIDTH(1);
    [self.addView addSubview:lineView1];
    
    self.bianJiIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(rightBtn.frame) + kAUTOWIDTH(15), kAUTOWIDTH(85), kAUTOWIDTH(85))];
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
//        iconImageView.image = [self.headerImageView.imageURLStringsGroup firstObject];
    }else{
        [self.bianJiIconImageView sd_setImageWithURL:[NSURL URLWithString:self.headerImageView.imageURLStringsGroup.firstObject] placeholderImage:kPlaceholderImage];
    }
    
    
    [self.addView addSubview:self.bianJiIconImageView];
    self.bianJiIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bianJiIconImageView.layer.cornerRadius = kAUTOWIDTH(5);
    self.bianJiIconImageView.layer.masksToBounds = YES;
    self.bianJiIconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *addImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addKuImage)];
    [self.bianJiIconImageView addGestureRecognizer: addImageTap];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bianJiIconImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(rightBtn.frame) + kAUTOWIDTH(15), kAUTOWIDTH(20), kAUTOWIDTH(20))];
    titleImageView.image = [UIImage imageNamed:@"爱心"];
    [self.addView addSubview:titleImageView];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    titleImageView.layer.cornerRadius = kAUTOWIDTH(5);
    titleImageView.layer.masksToBounds = YES;
//    titleImageView.backgroundColor = [UIColor redColor];

    UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bianJiIconImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(titleImageView.frame) + kAUTOWIDTH(12), kAUTOWIDTH(20), kAUTOWIDTH(20))];
    addressImageView.image = [UIImage imageNamed:@"定位"];
       [self.addView addSubview:addressImageView];
       addressImageView.contentMode = UIViewContentModeScaleAspectFill;
       addressImageView.layer.cornerRadius = kAUTOWIDTH(5);
       addressImageView.layer.masksToBounds = YES;
//    addressImageView.backgroundColor = [UIColor redColor];

    UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bianJiIconImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(addressImageView.frame) + kAUTOWIDTH(12), kAUTOWIDTH(20), kAUTOWIDTH(20))];
          timeImageView.image = [UIImage imageNamed:@"时间caise"];
          [self.addView addSubview:timeImageView];
          timeImageView.contentMode = UIViewContentModeScaleAspectFill;
          timeImageView.layer.cornerRadius = kAUTOWIDTH(5);
          timeImageView.layer.masksToBounds = YES;
//    timeImageView.backgroundColor = [UIColor redColor];

    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(rightBtn.frame) + kAUTOWIDTH(10), kAUTOWIDTH(200), kAUTOWIDTH(25))];
    self.titleTextField.text = self.model.titleString;
    self.titleTextField.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(12)];
    [self.addView addSubview:self.titleTextField];
    
    self.addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(self.titleTextField.frame) + kAUTOWIDTH(10), kAUTOWIDTH(200), kAUTOWIDTH(25))];
    self.addressTextField.placeholder = @"添加位置";
    self.addressTextField.text = self.localLabel.text ? self.localLabel.text : self.cityName;
    self.addressTextField.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(12)];
    [self.addView addSubview:self.addressTextField];
    
    self.timeText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame) + kAUTOWIDTH(10), CGRectGetMaxY(self.addressTextField.frame) + kAUTOWIDTH(10), kAUTOWIDTH(200), kAUTOWIDTH(25))];
    self.timeText.placeholder = @"添加时间";
    self.timeText.text = self.model.colorString;

    self.timeText.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(12)];
    [self.addView addSubview:self.timeText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickShow)];
    [self.timeText addGestureRecognizer:tap];
      
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.timeText.frame) + kAUTOWIDTH(10), ScreenWidth - kAUTOWIDTH(30) - kAUTOWIDTH(30), 0.5)];
    lineView2.backgroundColor = PNCColorWithHexA(0xdcdcdc, 0.5);
    [self.addView addSubview:lineView2];
    
    self.contentTextField = [[UITextView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(lineView2.frame) + kAUTOWIDTH(15), ScreenWidth - kAUTOWIDTH(30) - kAUTOWIDTH(30) ,kAUTOWIDTH(50))];
       self.contentTextField.text = self.model.contentString;
       self.contentTextField.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(11)];
       [self.addView addSubview:self.contentTextField];
       
       
    
    
}
- (void)datePickShow{
    [self.titleTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
    
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
        
        self.timeText.text = [self chuLiRiQi];
        
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


- (void)guanbiedit{
    [self.editView removeFromSuperview];
    [self removeSetView];
}

- (void)saveInfo{
    self.titleLabel.text = self.titleTextField.text ? self.titleTextField.text : self.model.titleString ;
    self.contentLabel.text = self.contentTextField.text ? self.contentTextField.text :self.model.contentString ;
    self.timeLabel.text = self.timeText.text ? self.timeText.text : self.model.colorString;
    self.localLabel.text = self.addressTextField.text ? self.addressTextField.text : self.model.nickName;

    if (self.localLabel.text.length > 0) {
        self.localLabel.hidden = NO;
        self.locationImage.hidden = NO;
    }
    
    if (self.backModelBlock) {
        self.backModelBlock(self.titleLabel.text, self.contentLabel.text,self.timeLabel.text,self.localLabel.text);
    }
    
    [self editViewUpdateDB];
    [self removeSetView];
    [self.editView removeFromSuperview];

}


- (void)iLikeItWithSelected:(UIButton *)button{
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    button.selected = !button.selected;
    if (button.selected) {
        [self saveIsLikeToDbWithString:@"isLike"];
    }else{
        [self saveIsLikeToDbWithString:@"noLike"];
    }
}

- (void)iLikeItWithSelectedbutton1:(UIButton *)button{
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    UIButton *button1 = [_whiteBackView viewWithTag:1002];
    
    button1.selected = !button1.selected;
    if (button1.selected) {
        [self saveIsLikeToDbWithString:@"isLike"];
    }else{
        [self saveIsLikeToDbWithString:@"noLike"];
    }
}

- (void)saveIsLikeToDbWithString:(NSString *)likeString{
    
    LZDataModel *model = self.dataSourceArray[self.currentIndex];
    
    //    NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
    //    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
    //    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
    //
    
    self.model.dsc = likeString;
    NSLog(@"%@",model);
    
    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
//    [SVProgressHUD showInfoWithStatus:@""];
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSLog(@"array");
}

- (void)removeSetView{
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:100 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        _whiteBackView.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight, ScreenWidth - kAUTOWIDTH(20), SETVIEW_HEIGHT);
        _setView.alpha = 0;
    } completion:^(BOOL finished) {
        [_setView removeFromSuperview];
        _setView = nil;
    }];
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


- (void)fanhui{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showAppStore"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showAppStore"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAppStoreReView];
        });
    }
   
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    [self updateDB];
    if ([self.pushFlag isEqualToString:@"0"]) {
        WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
        manager.isreload = YES;
        self.navigationController.delegate = nil;
    }

}

- (void) addImage{
    [BCShanNianKaPianManager maDaZhongJianZhenDong];

    [self selectedXiangCeImage];
}

#pragma mark  ========== 选择图片 ===========
- (void)selectedXiangCeImage{
//    [BCJiuGongGeImageManager maDaKaiShiZhenDong];
    UIView *whiteView = [self.view viewWithTag:100];
    UIView *blackView = [self.view viewWithTag:101];
    
    whiteView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    blackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:13 initialSpringVelocity:1 options:0 animations:^{
        whiteView.transform = CGAffineTransformMakeScale(1, 1);
        blackView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化UIImagePickerController类
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //判断数据来源为相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理
        picker.delegate = self;
        picker.allowsEditing = YES;
        //打开相册
        [self presentViewController:picker animated:YES completion:nil];
    });
}

#pragma mark ========== 图片代理回调 ===========
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
//    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.headerImageView.image = image;
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 NSDictionary* imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];


                 NSDictionary *GPS = [imageMetadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
                 NSLog(@"－－－－－－－－%@",GPS);//地理位置信息
//                 NSLog(@"%@",imageMetadata);

        self.jingDu = [[NSString stringWithFormat:@"%@",GPS[@"Latitude"]] doubleValue];
        self.weiDu = [[NSString stringWithFormat:@"%@",GPS[@"Longitude"]] doubleValue];

        [self reverseGeoCoder];
        }
            failureBlock:^(NSError *error) {
            }];
    
    if (self.backImageBlock) {
        self.backImageBlock(image);
    }
    
}

-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}



- (void)reverseGeoCoder {
    
    // 获取用户输入的经纬度
    double latitude = self.jingDu;
    double longitude = self.weiDu;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 反地理编码(经纬度---地址)
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            
            NSLog(@" ============= %@",pl.name);
            
            if (pl.administrativeArea.length > 0) {
                self.localLabel.text = [NSString stringWithFormat:@"%@ %@ %@",pl.administrativeArea,pl.locality,pl.name];
                self.localLabel.hidden = NO;
                self.locationImage.hidden = NO;

            }else{
                self.localLabel.text = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.name];
                self.localLabel.hidden = NO;
                self.locationImage.hidden = NO;

            }

        }else {
            NSLog(@"错误");
        }
    }];
}


//用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)popUpdate{
   
    LZDataModel *model = self.model;

    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        
        NSString *imageString = @"";
           
           for (int i = 0; i < self.headerImageView.imageURLStringsGroup.count; i ++ ) {
               UIImage *image = self.headerImageView.imageURLStringsGroup[i];
               NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
               NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
               NSString *currentString = [compressCardBackStrData base64EncodedStringWithOptions:0];
               imageString = [imageString stringByAppendingFormat:@"%@%@", currentString, @"&&++&&"];

           }
           
           
           model.email = imageString;
        
        
        NSData * imageBackData = UIImageJPEGRepresentation([self.headerImageView.imageURLStringsGroup firstObject], 1);
        NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
        NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
        model.pcmData = imageBackDataString;
        model.titleString = self.titleLabel.text;
        model.contentString = self.contentLabel.text;
        model.colorString = self.timeLabel.text;
        model.nickName = self.localLabel.text;
        model.urlString = @"isDone";
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        
    }else{
        
        if (self.imageWanZhengNameArr.count == 0 ) {
            [self.imageWanZhengNameArr removeAllObjects];
            [SVProgressHUD showWithStatus:@"回忆保存中......"];
            [AliyunUpload upLoadImages:self.headerImageView.localizationImageNamesGroup success:^(NSString *obj, NSMutableArray *imageNamesArr) {
            
                for (int i = 0; i < imageNamesArr.count; i++) {
                    NSString *imageName = imageNamesArr[i];
                    NSString *wanZhengName = [NSString stringWithFormat:@"%@%@",@"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/",imageName];
                    [self.imageWanZhengNameArr addObject:wanZhengName];
                    NSLog(@"imageWanZhengNameArr ==== %@",self.imageWanZhengNameArr);

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD showSuccessWithStatus:@"成功"];
                        
                        
                        NSString *imageString = @"";
                           
                           for (int i = 0; i < self.headerImageView.imageURLStringsGroup.count; i ++ ) {
                               NSString *imageName = self.headerImageView.imageURLStringsGroup[i];
                               imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];

                           }
                           
                           
                        model.email = imageString;
                        
                        
                       
                        model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
                        model.titleString = self.titleLabel.text;
                        model.contentString = self.contentLabel.text;
                        model.colorString = self.timeLabel.text;
                        model.nickName = self.localLabel.text;
                        model.urlString = @"isDone";
                        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
                        
                    });
                    
                }
            }];
        }else{
            NSString *imageString = @"";
               
               for (int i = 0; i < self.imageWanZhengNameArr.count; i ++ ) {
                   NSString *imageName = self.imageWanZhengNameArr[i];
                   imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];

               }
               
               
            model.email = imageString;
            
            
           
            model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
            model.titleString = self.titleLabel.text;
            model.contentString = self.contentLabel.text;
            model.colorString = self.timeLabel.text;
            model.nickName = self.localLabel.text;
            model.urlString = @"isDone";
            [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        }
        
        
        
        
    }
}


- (void)editViewUpdateDB{
    
    LZDataModel *model = self.model;

    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        NSString *imageString = @"";
           
           for (int i = 0; i < self.headerImageView.imageURLStringsGroup.count; i ++ ) {
               UIImage *image = self.headerImageView.imageURLStringsGroup[i];
               NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
               NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
               NSString *currentString = [compressCardBackStrData base64EncodedStringWithOptions:0];
               imageString = [imageString stringByAppendingFormat:@"%@%@", currentString, @"&&++&&"];

           }
           
           
           model.email = imageString;
        
        
        NSData * imageBackData = UIImageJPEGRepresentation([self.headerImageView.imageURLStringsGroup firstObject], 1);
        NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
        NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
        model.pcmData = imageBackDataString;
        model.titleString = self.titleLabel.text;
        model.contentString = self.contentLabel.text;
        model.colorString = self.timeLabel.text;
        model.nickName = self.localLabel.text;
        model.urlString = @"isDone";
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        
    }else{
        if (self.imageWanZhengNameArr.count == 0) {

            [self.imageWanZhengNameArr removeAllObjects];
//            [SVProgressHUD showWithStatus:@"回忆保存中......"];
            [AliyunUpload upLoadImages:self.headerImageView.localizationImageNamesGroup success:^(NSString *obj, NSMutableArray *imageNamesArr) {
            
                for (int i = 0; i < imageNamesArr.count; i++) {
                    NSString *imageName = imageNamesArr[i];
                    NSString *wanZhengName = [NSString stringWithFormat:@"%@%@",@"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/",imageName];
                    [self.imageWanZhengNameArr addObject:wanZhengName];
                    NSLog(@"imageWanZhengNameArr ==== %@",self.imageWanZhengNameArr);

                    dispatch_async(dispatch_get_main_queue(), ^{
                      
//                        [SVProgressHUD showSuccessWithStatus:@"成功"];
                        NSString *imageString = @"";
                           for (int i = 0; i < self.imageWanZhengNameArr.count; i ++ ) {
                               NSString *imageName = self.imageWanZhengNameArr[i];
                               imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];
                           }
                        model.email = imageString;
                    
                        model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
                        model.titleString = self.titleLabel.text;
                        model.contentString = self.contentLabel.text;
                        model.colorString = self.timeLabel.text;
                        model.nickName = self.localLabel.text;
                        model.urlString = @"isDone";
                        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
                        
                        [self saveDateToDBWithModel:model];
                    });
                    
                }
            }];
            
        }else{
            NSString *imageString = @"";
               
               for (int i = 0; i < self.imageWanZhengNameArr.count; i ++ ) {
                   NSString *imageName = self.imageWanZhengNameArr[i];
                   imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];

               }
               
            model.email = imageString;
            
            
           
            model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
            model.titleString = self.titleLabel.text;
            model.contentString = self.contentLabel.text;
            model.colorString = self.timeLabel.text;
            model.nickName = self.localLabel.text;
            model.urlString = @"isDone";
            [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
            
            [self saveDateToDBWithModel:model];
           
        }
        
    }
    
    
    
   

    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
        WHTongBuViewController *wvc =[[WHTongBuViewController alloc]init];
        [wvc uploadWangHouYuShengWithAlert:NO];
    }else{
        
    }
}

- (void)updateDB{
    
    LZDataModel *model = self.model;

    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        NSString *imageString = @"";
           
           for (int i = 0; i < self.headerImageView.imageURLStringsGroup.count; i ++ ) {
               UIImage *image = self.headerImageView.imageURLStringsGroup[i];
               NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
               NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
               NSString *currentString = [compressCardBackStrData base64EncodedStringWithOptions:0];
               imageString = [imageString stringByAppendingFormat:@"%@%@", currentString, @"&&++&&"];

           }
           
           
           model.email = imageString;
        
        
        NSData * imageBackData = UIImageJPEGRepresentation([self.headerImageView.imageURLStringsGroup firstObject], 1);
        NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
        NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
        model.pcmData = imageBackDataString;
        model.titleString = self.titleLabel.text;
        model.contentString = self.contentLabel.text;
        model.colorString = self.timeLabel.text;
        model.nickName = self.localLabel.text;
        model.urlString = @"isDone";
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        
    }else{
        if (self.imageWanZhengNameArr.count == 0) {

            [self.imageWanZhengNameArr removeAllObjects];
            [SVProgressHUD showWithStatus:@"回忆保存中......"];
            [AliyunUpload upLoadImages:self.headerImageView.localizationImageNamesGroup success:^(NSString *obj, NSMutableArray *imageNamesArr) {
            
                for (int i = 0; i < imageNamesArr.count; i++) {
                    NSString *imageName = imageNamesArr[i];
                    NSString *wanZhengName = [NSString stringWithFormat:@"%@%@",@"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/",imageName];
                    [self.imageWanZhengNameArr addObject:wanZhengName];
                    NSLog(@"imageWanZhengNameArr ==== %@",self.imageWanZhengNameArr);

                    dispatch_async(dispatch_get_main_queue(), ^{
                      
                        [SVProgressHUD showSuccessWithStatus:@"成功"];
                        NSString *imageString = @"";
                           for (int i = 0; i < self.imageWanZhengNameArr.count; i ++ ) {
                               NSString *imageName = self.imageWanZhengNameArr[i];
                               imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];
                           }
                        model.email = imageString;
                    
                        model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
                        model.titleString = self.titleLabel.text;
                        model.contentString = self.contentLabel.text;
                        model.colorString = self.timeLabel.text;
                        model.nickName = self.localLabel.text;
                        model.urlString = @"isDone";
                        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
                        
                        [self saveDateToDBWithModel:model];
                    
                        [self.navigationController popViewControllerAnimated:YES];
                      
                    });
                    
                }
            }];
            
        }else{
            NSString *imageString = @"";
               
               for (int i = 0; i < self.imageWanZhengNameArr.count; i ++ ) {
                   NSString *imageName = self.imageWanZhengNameArr[i];
                   imageString = [imageString stringByAppendingFormat:@"%@%@", imageName,@"&&++&&"];

               }
               
            model.email = imageString;
            
            
           
            model.pcmData = self.headerImageView.imageURLStringsGroup.firstObject;
            model.titleString = self.titleLabel.text;
            model.contentString = self.contentLabel.text;
            model.colorString = self.timeLabel.text;
            model.nickName = self.localLabel.text;
            model.urlString = @"isDone";
            [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
            
            [self saveDateToDBWithModel:model];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
    
    
   

    if ([[BCUserDeafaults objectForKey:ISBUYVIP] isEqualToString:@"1"]) {
        WHTongBuViewController *wvc =[[WHTongBuViewController alloc]init];
        [wvc uploadWangHouYuShengWithAlert:NO];
    }else{
        
    }
}

- (void)saveDateToDBWithModel:(LZDataModel *)model{
    if ([self.createFlag isEqualToString:@"1"]) {
        
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"您已经编辑了一条新的往后余生，保存后不可删除，确定要保存吗？" preferredStyle:UIAlertControllerStyleAlert];
           
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
               self.navigationController.delegate = nil;
            [self.navigationController popViewControllerAnimated:YES];

           }];
           
           
           
           UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             
               [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:self.model];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self userInfo:nil];
               [SVProgressHUD showSuccessWithStatus:@"『往后余生』 默认添加到『温暖』"];
              self.navigationController.delegate = nil;

               [self.navigationController popViewControllerAnimated:YES];
               WHIsReloadManager *manager = [WHIsReloadManager shareInstance];
               manager.isreload = YES;
                
             
           }];
           
           [alertController addAction:cancelAction];
           [alertController addAction:otherAction];
           [self presentViewController:alertController animated:YES completion:nil];
           
    }else{
    
    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self userInfo:nil];

    }
   
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

#pragma mark - 重写pop动画

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    WHNewViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    WHBianJiViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.headerImageView;
//    [fromVC valueForKeyPath:@"headerImageView"];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
//    HomeCell *cell = (HomeCell *)[toVC.tableView cellForRowAtIndexPath:self.selectIndexPath];
    
    UIView *view = [toVC.myCarousel viewWithTag:1024+self.currentIndex];
    UIView *originView = [view viewWithTag: 200+self.currentIndex];
    
    UIView *snapShotView = [fromView snapshotViewAfterScreenUpdates:YES];
    snapShotView.layer.masksToBounds = YES;
    snapShotView.layer.cornerRadius = kAUTOWIDTH(14);
    snapShotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    
    snapShotView.contentMode = UIViewContentModeScaleAspectFill;
    fromView.hidden = YES;
    originView.hidden = YES;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
   
   
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(0), 0,ScreenWidth, ScreenWidth)];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.masksToBounds = YES;////    self.imageView
    headerImageView.center = snapShotView.center;
    headerImageView.layer.cornerRadius = kAUTOWIDTH(14);
    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        headerImageView.image = [self.headerImageView.imageURLStringsGroup firstObject];

    }else{
        [headerImageView sd_setImageWithURL:self.imageWanZhengNameArr.firstObject placeholderImage:kPlaceholderImage];

    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(self.headerImageView.frame) + kAUTOWIDTH(30), ScreenWidth - kAUTOWIDTH(30), kAUTOWIDTH(22))];
    titleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(13)];
    titleLabel.textColor = PNCColorWithHex(0x1e1e1e);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.model.titleString;
          
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.titleLabel.frame) + kAUTOWIDTH(20), ScreenWidth - kAUTOWIDTH(150), kAUTOWIDTH(25))];
    contentLabel.font =  [UIFont systemFontOfSize:kAUTOWIDTH(11)];
    contentLabel.textColor = PNCColorWithHex(0x515151);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.model.contentString;
    
           // 模仿cell创建的视图
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(self.contentLabel.frame) + kAUTOWIDTH(20), cardViewW - kAUTOWIDTH(31), kAUTOWIDTH(30))];
    timeLabel.font = [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(11)];;
    timeLabel.textColor = PNCColorWithHex(0x7777777);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = self.model.colorString;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    
    
    UIBlurEffect  *effectT = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectViewT = [[UIVisualEffectView alloc] initWithEffect:effectT];
    effectViewT.frame = CGRectMake(0, ScreenWidth, ScreenWidth, ScreenHeight - ScreenWidth);
//    effectViewT.alpha = 0.f;
    effectViewT.userInteractionEnabled = YES;
  
    [snapShotView addSubview:headerImageView];
    [snapShotView addSubview:effectViewT];
    [snapShotView addSubview:titleLabel];
    [snapShotView addSubview:contentLabel];
    [snapShotView addSubview:timeLabel];

    
    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//
//        effectViewT.frame = CGRectMake(0, cardViewH - kAUTOWIDTH(99), VIEW_W - kAUTOWIDTH(20), kAUTOWIDTH(100));
//
//    } completion:^(BOOL finished) {
//
//    }];
//
    
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
           fromVC.view.alpha = 0.0f;
           snapShotView.layer.cornerRadius = kAUTOWIDTH(14);
//           self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width,SCREEN_WIDTH*1.3*0.8);
//           self.tableView.layer.cornerRadius = 15;
           snapShotView.frame = [containerView convertRect:originView.frame fromView:originView.superview];
           effectViewT.frame = CGRectMake(0, cardViewH - kAUTOWIDTH(120), cardViewW, kAUTOWIDTH(120));
           
           headerImageView.frame = CGRectMake(0, 0,cardViewW, cardViewH);
//           headerImageView.rcenter = snapShotView.center;
           
//           effectViewT.alpha = 1.f;

           titleLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMinY(effectViewT.frame) + kAUTOWIDTH(8), cardViewW - kAUTOWIDTH(30), kAUTOWIDTH(22));
           contentLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(titleLabel.frame) + kAUTOWIDTH(8), CGRectGetWidth(titleLabel.frame), kAUTOWIDTH(15));
           
           timeLabel.frame = CGRectMake(kAUTOWIDTH(15), CGRectGetMaxY(contentLabel.frame) + kAUTOWIDTH(8), CGRectGetWidth(titleLabel.frame), kAUTOWIDTH(15));

//           Tabbar *tabBar = (Tabbar *)self.tabBarController.tabBar;
//           if (IPHONE_X) {
//               tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-83, SCREEN_WIDTH, 83);
//           } else {
//               tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
//           }

           
       } completion:^(BOOL finished) {
           fromView.hidden = YES;
           [snapShotView removeFromSuperview];
           originView.hidden = NO;
           [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//           toVC.subLayer.hidden = NO;

       }];
}
















- (void)addKuImage{
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 3;//最大的选择数目
    photoController.configuration.containVideo = false;//选择类型，目前只选择图片不选择视频
//    photoController.configuration.hiddenGroupWhenNoPhotos = tr
    photoController.photo_delegate = self;
    photoController.thumbnailSize = self.assetSize;//缩略图的尺寸
    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    [self presentViewController:photoController animated:true completion:^{        
    }];
}



/// 图片选择器消失的回调方法
- (void)photosViewControllerWillDismiss:(UIViewController *)viewController {
    NSLog(@"%@=========!!!!!!!========= is dismiss",viewController);
    
    
    
    
    
}


/**
 选中图片以及视频等资源的本地identifer
 可用于设置默认选好的资源
 
 @param viewController RITLPhotosViewController
 @param identifiers 选中资源的本地标志位
 */
- (void)photosViewController:(UIViewController *)viewController
            assetIdentifiers:(NSArray <NSString *> *)identifiers
{
    
}


- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray<UIImage *> *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos
{
    self.assets = thumbnailImages;
//    [self.collectionView reloadData];
    
    
    NSLog(@"%@============**********==========",infos);
}


/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 @param infos 选中资源的原比例图的相关信息
 */
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos{
    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
      
        NSMutableArray *yaSuoImageArr = [[NSMutableArray alloc]init];
        NSArray *imageArr = images;
        for (int i = 0 ; i < imageArr.count; i++) {
           
            [yaSuoImageArr addObject: [self compressImageSize:imageArr[i] toByte:500000]];
            
        }
        
        self.headerImageView.imageURLStringsGroup = yaSuoImageArr;

        
    }else{
        if (images.count > 0) {
            
            self.headerImageView.localizationImageNamesGroup = images;
            self.bianJiIconImageView.image = images.firstObject;

            [self.imageWanZhengNameArr removeAllObjects];
//            [SVProgressHUD showWithStatus:@"回忆保存中......"];
            [AliyunUpload upLoadImages:images success:^(NSString *obj, NSMutableArray *imageNamesArr) {

                for (int i = 0; i < imageNamesArr.count; i++) {
                    NSString *imageName = imageNamesArr[i];
                    NSString *wanZhengName = [NSString stringWithFormat:@"%@%@",@"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/",imageName];
                    [self.imageWanZhengNameArr addObject:wanZhengName];
                    NSLog(@"imageWanZhengNameArr ==== %@",self.imageWanZhengNameArr);

//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.headerImageView.imageURLStringsGroup = imageWanZhengNameArr;
//                        [self.bianJiIconImageView sd_setImageWithURL:imageWanZhengNameArr.firstObject];
////                        [SVProgressHUD showSuccessWithStatus:@"成功"];
//                    });

                }
            }];
        }
    }
    
 
    
        
        NSURL *assetURL = [[infos firstObject] objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL
                 resultBlock:^(ALAsset *asset) {
            NSDictionary* imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
            NSDictionary *GPS = [imageMetadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
            self.jingDu = [[NSString stringWithFormat:@"%@",GPS[@"Latitude"]] doubleValue];
            self.weiDu = [[NSString stringWithFormat:@"%@",GPS[@"Longitude"]] doubleValue];
            [self reverseGeoCoder];
            }
                failureBlock:^(NSError *error) {
        }];
        
        if (self.backImageBlock) {
            self.backImageBlock(images.firstObject);
        }
        
    
    
}




- (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}






















@end
