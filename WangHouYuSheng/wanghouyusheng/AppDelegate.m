//
//  AppDelegate.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "AppDelegate.h"

#import "YSMainTimeViewController.h"
#import "WSYSMainViewController.h"


#import "LZGestureTool.h"
#import "LZGestureScreen.h"
#import "TouchIdUnlock.h"
#import "TouchIDScreen.h"
#import "LZiCloud.h"

#import "LaunchViewController.h"

#import <UMCommon/UMCommon.h>

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)getNeiGouJiaQian{
    
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"appKaiGuan"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"5f4476738a" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *KaiGuanStatus = [object objectForKey:@"WHYS_NeiGouJiaQian"];
                NSLog(@"%@=========",KaiGuanStatus);
                [[NSUserDefaults standardUserDefaults] setObject:KaiGuanStatus forKey:@"NEI_GOU_JIA_QIAN"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
    
}

- (void)chuShiHuaBomb{
    [Bmob resetDomain:@"http://timepill.northcity.top"];
    [Bmob registerWithAppKey:@"075c9e426a01a48a81aa12305924e532"];
//    [Bmob activateSDK];
    NSLog(@"=Bomb=============%ld============",(long)[Bmob version]);
//    [Bmob resetDomain:@"http://fill.northcity.top"];

    //
//                    //往GameScore表添加一条playerName为小明，分数为78的数据
//                    BmobObject *gameScore = [BmobObject objectWithClassName:@"appKaiGuan"];
//                    [gameScore setObject:@"12" forKey:@"WHYS_NeiGouJiaQian"];
//                    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//
//                    }];
    
    
    NSString *nowStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
    
    if ([nowStatus isEqualToString:@"开"]) {
        
    }else{
        //查找GameScore表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"appKaiGuan"];
        //查找GameScore表里面id为0c6db13c的数据
        [bquery getObjectInBackgroundWithId:@"d43e4c7df4" block:^(BmobObject *object,NSError *error){
            if (error){
                //进行错误处理
            }else{
                //表里有id为0c6db13c的数据
                if (object) {
                    //得到playerName和cheatMode
                    NSString *KaiGuanStatus = [object objectForKey:@"WangHouYuSheng"];
                    NSLog(@"%@=========",KaiGuanStatus);
                    [[NSUserDefaults standardUserDefaults] setObject:KaiGuanStatus forKey:@"KaiGuanShiFouDaKai"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }];
    }
}

- (void)failJiaZaVc{
    [self createSqlite];
    [self jiaZaiVc];
}

- (void)jiaZaiVc{
    // 必须在主线程同步执行，避免 window 生命周期问题
    if ([NSThread isMainThread]) {
        [self setupWindow];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setupWindow];
        });
    }
}

- (void)setupWindow {
    // iOS 13+ 使用 UIWindowScene
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && 
                [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
                break;
            }
        }
    }
    
    // iOS 12 及以下或未找到 Scene 时的降级处理
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    LaunchViewController *Lvc = [[LaunchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:Lvc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstNewVersion"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstNewVersion"];

            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstJiaZai"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kNewVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kNewVersion];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
    }
    
   
    [self createMoBiWuSiAD];
    [UMConfigure initWithAppkey:@"5e7e43a5895cca7dd00003fb" channel:@"App Store"];
//    [BCUserDeafaults setObject:@"1" forKey:@"ISBUYVIP"];

    [self verifyPassword];
    [self chuShiHuaBomb];
    [self getNeiGouJiaQian];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstJiaZai"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstJiaZai"];
        [BCUserDeafaults setObject:@"0" forKey:@"ISBUYVIP"];
    }
    
    [self failJiaZaVc];
    [self requestAuthor];
    return YES;
}

//创建本地通知
- (void)requestAuthor
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

- (void)createMoBiWuSiAD{
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
    }];
//    [[APSDK sharedInstance] initWithAppId:@"noZWXYGLgkyxqgQD-EwDoYr"];
}

-(void)updateFromiCloud{

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstText"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstText"];
        //第一次启动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LZiCloud downloadFromiCloudWithBlock:^(id obj) {
                
                if (obj != nil) {
                    
                    NSData *data = (NSData *)obj;
                    
                    [data writeToFile:[LZSqliteTool LZCreateSqliteWithName:LZSqliteName] atomically:YES];
                    
    
                    [SVProgressHUD showInfoWithStatus:@"同步成功"];
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstCreateSQ"]){
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCreateSQ"];
                            NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
                            if (array.count == 0) {
                                [self createSqlite];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"DATA_DONE" object:self userInfo:nil];
                                [self jiaZaiVc];

                            }else{

//                                [self createSqlite];
                                    [self jiaZaiVc];

                            }
                        }
//                    });
                    [self jiaZaiVc];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD" object:self userInfo:nil];
                } else {
                    
                    [self createSqlite];
                    [self jiaZaiVc];
               
//                    [SVProgressHUD showErrorWithStatus:@"iCloud还没有数据"];
                }
            }];
            
        });
    }
}

- (void)verifyPassword {
    
    if ([LZGestureTool isGestureEnable]) {
        
        [[LZGestureScreen shared] show];
        
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[LZGestureScreen shared] dismiss];
            }];
        }
    }else if([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotByUser]){
        [[TouchIDScreen shared] show];
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[TouchIDScreen shared] dismiss];
                [BCShanNianKaPianManager maDaQingZhenDong];
            }];
        }
    }else{
        
    }
}

- (void)createSqlite {
    
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstCreateiCloud"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCreateiCloud"];
        [self saveDataToiCloud];
        
    }
    
}

- (void)uploadImages{
    NSArray *imageNameArrs = @[@"kongImage9.png"];
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];

    for (int i = 0; i < imageNameArrs.count; i++) {
        UIImage *image = [UIImage imageNamed:imageNameArrs[i]];
        [imageArr addObject:image];
    }

    [AliyunUpload upLoadImages:imageArr success:^(NSString *obj, NSMutableArray *imageNamesArr) {
       
        NSLog(@"imageNamesArr ====== %@",imageNamesArr);
        
        NSLog(@"obj ===== %@",obj);

    }];
    
}


- (void)saveDataToiCloud{
    
    NSArray *titleArray= @[
        @"手牵手一起逛街",
        @"一起坐摩天轮在最高处拥吻",
        @"一起坐过山车­",
        @"一起进鬼屋",
        @"一起坐旋转木马",
        @"一起养一条喵星人/汪星人",
        @"亲手为我削一个苹果，喂我吃",
        @"给彼此一封手写信­",
        @"在一棵树上挂上祝福­",
        @"一起沿铁轨走­",
        @"在树上刻下我们的约定­",
        @"背靠背听歌­",
        @"玩同一款游戏",
        @"住一次精品民宿",
        @"吃一顿米其林三星",
        @"以喝交杯酒的方式喝东西­",
        @"穿情侣装逛街",
        @"追同一部剧",
        @"靠我肩膀睡觉­",
        @"看一次日出日落",
        @"一起在晴天的午后晒太阳",
        @"一起看烟火",
        @"一起看电影­",
        @"下雪天一起堆雪人",
        @"一起做一顿大餐",
        @"一起去捡贝壳",
        @"一起种一种花",
        @"一起去学校的操场散步",
        @"一起淋雨­",
        @"弹一首曲子给我听­",
        @"一起煮一煮咖啡",
        @" 看我打一场篮球比赛­",
        @" 一起包一次饺子­", @"一起看一次流星雨",
        @"一起看一次演唱会",
        @"一起去天台看星星",
        @"一起陪“我们”过生日",
        @"买一件奢饰品",
        @"一起买一张刮刮乐",
        @" 一起与你的小学，初中，高中­",
        @"一起去我的小学，初中，高中­",
        @"种一棵树",
        @"一起看纪录片《生门》",
        @"背着你走一段路­",
        @"春天去一次野游",
        @"夏天捉一次萤火虫",
        @"秋天去麦田里看一次麦浪",
        @"冬天一起在雪中漫步",
        @"去吃一次海鲜自助",
        @"一起理一次头发",
        @"买一箱零食",
        @"一起去看海­",
        @"一起去草原",
        @"一起去沙漠",
        @"一起去热带雨林",
        @"一起坐一趟长途火车",
        @"一场说走就走的旅行",
        @"一起泡一次温泉",
        @"一起去看樱花­",
        @"去一次迪士尼乐园",
        @"去一次野生动物园",
        @"去一趟植物园",
        @"一起去一趟海南的“天涯海角”",
        @"一起去一次海洋馆",
        @"打卡喜欢的城市的地标",
        @"一起登一座山",
        @"一起滑一次冰",
        @"玩一次漂流",
        @"互相学会一项对方的特长",
        @"整晚不睡觉，打电话唠嗑",
        @"玩一次蹦极",
        @"骑一次马",
        @"骑一次双人自行车­",
        @"一起完成一幅很大很大的拼图",
        @"喝醉一次",
        @"玩一款桌游",
        @"为你做一次早餐­",
        @"为你做一个蛋糕­",
        @"一起看动漫",
        @"比赛吃西瓜，用勺吃的那种­",
        @"献一份爱心",
        @"一起去一次敬老院­",
        @"一起去孤儿院一次­",
        @"去拍一次婚纱照­",
        @"用泥巴做两个小人，我们的形象­",
        @" 在冬天共用一副手套­",
        @"生病的时候要陪着我­",
        @"找一片四叶草夹在日记本里",
        @"一起照相­",
        @"打气球游戏帮我赢东西­",
         @"比赛磕瓜子­",
         @"假装当陌生人一天­",
         @"为你织一件东西­",
         @"专心为我做一件事，哪怕很不起眼­",
         @"为我做一件你很不喜欢的事­",
         @"在公共场合下一起喝娃哈哈­",
         @"在清晨为爱鼓掌",
         @"为我挡酒­",
         @"在朋友面前大方的介绍我­",
         @"执子之手，与子偕老",
        @"分享『往后余生』App"
    ];
    NSArray *contentArray= @[@"是否还记得第一次牵手时的心动",@"和最爱的人一起跨过天空",@"大声的说出”我爱你“",@"不要怕，我在",@"听说旋转木马是最残忍的游戏",@"每个女孩都梦想养一只可爱的喵星人",@"酸酸甜甜像爱情的味道",@"用时间胶囊给未来的TA写封信",@"祝愿我余生漫漫，有你不孤单",@"为什么要沿铁轨走，可能是想我们的爱情没有终点吧",@"对树温柔一点，她可能也怕疼",@"怀念在学校操场的夜晚背靠背听歌",@"我辅助你，你凯瑞我",@"停车坐爱枫林晚，霜叶红于二月花",@"感受美食带来的多巴胺",@"干杯，喝完这一杯还有一杯",@"秀自己的恩爱，让别人羡慕去吧",@"《乡村爱情》你觉得怎么样，都十二部了",@"最喜欢靠在你宽阔的肩膀",@"想就这样一直陪你，每一天",@"阳光穿过你的发梢，格外的耀眼",@"好想时光定格在这一刻",@"还记得《那些年，我们一起追的女孩》吗",@"别忘了给他做一个好看的帽子",@"一定要有我最爱吃的可乐鸡翅哦",@"听说把贝壳放在耳朵上，能听见海的声音",@"我喜欢随便花，看看能不能种",@"那一年最开心的事就是陪你在操场一圈又一圈的散步",@"最美的不是下雨天，是曾与你躲过雨的屋檐",@"两只老虎可以吗，我真的不会弹吉他",@"我还是更喜欢喝布丁奶茶",@"加油！加油！",@"好吃不过饺子....",     @"陪你去看流星雨，落在这地球上",@"你听过万人合唱吗？",@"流星划过的时候，别忘了许愿",@"祝”我们“生日快乐",@"品质生活需要仪式感",@"我的幸运号码是8个8",@"我希望在十八岁的时候遇见你",@"上学时的恋爱才是最纯真的",@"种一棵树最好的时间是十年前，其次是现在",@"一起感受生命的伟大",@"我背的不只是你，是我的全世界",@"远处的油菜花海，还有最爱吃的零食",@"小时候夏天的夜晚，一闪一闪的萤火虫，像梦一样",@"远处蔚蓝天空下金色的麦浪，那里曾是你和我爱过的地方",@"一不小心就白头",@"必须要扶墙进去，扶墙出来",@"我觉得我剪短发会比较帅呢",@"小时候的梦想是有一包永远吃不完的辣条",@"听，海哭的声音，叹息着谁又被伤了心",@"我爱上一匹野马，我要带TA去草原",@"听说沙漠里的星辰最美",@"氤氲着的空气，像刚洗完澡的你",@"啤酒饮料矿泉水，花生瓜子八宝粥",@"世界那么大，我想去看看",@"从山顶到山脚，我要把所有的温泉都泡一遍",@"你知道么，樱花下落的速度是秒速5厘米",@"我相信童话的故事都不是骗人的",@"你要坐在大象鼻子上拍照吗？",@"白色的风车，紫色的薰衣草花海，还有最漂亮的我",@"一次就好，我带你去看天涯海角",@"我一定要摸一下海豚",@"断桥是否下着雪，我们去西湖吧",@"不识庐山真面目，只缘身在此山中",@"别怕摔，抓紧我",@"划船不用桨，一生全靠浪",@"我头发特长你学不会吧，哈哈",@"体验一下异地恋的”煲电话粥“",@"闭上眼，抱紧我",@"勇敢的驰骋、飞奔",@"和风，暖阳，还有你",@"就先拼一个清明上河图吧",@"酒不醉人人自醉",@"狼人杀，今晚猎个痛快",@"无论多忙，不要忘记吃早餐哦",@"我最喜欢吃草莓奶油味的蛋糕，你呢？",@"哔哩哔哩万岁",@"我先让你三口",@"乐于助人，做个善良的人",@"陪爷爷奶奶们唠唠嗑，拉拉家常",@"给小朋友们讲讲故事，陪陪他们",@"最美的年纪遇见最美的你",@"你有大大的眼睛，好看的鼻子",@"我牵着你，你牵着我，好傻",@"保重身体，学会爱自己才会爱别人。",@"第四片叶子是祝你幸运的意思哦",@"就用你送我的拍立得吧",@"最起码要赢一个大大的布娃娃",@"你嗑皮，我吃子",@"你好！陌生人",@"我的拿手好戏，织微博",@"就帮你生一堆孩子吧",@"我不喜欢你喜欢我不喜欢的人",@"我还喜欢喝”爽歪歪“",@"这件事一定一定要做",@"拿来，我替你喝",@"这是我女/男朋友",@"爱你一万年",@"分享是人类最美好的品德"];
    
    NSArray *colorArray= @[@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日",@"某年某月某日"];

    
    NSArray *imageNameArr = @[@"IMG_1422.JPG",@"IMG_1423.JPG",@"IMG_1426.JPG",@"IMG_1427.JPG",@"IMG_1430.JPG",@"IMG_1432.JPG",@"IMG_1435.JPG",@"IMG_1437.JPG"];
    
    for (int i = 0; i < titleArray.count; i ++) {
        LZDataModel *model3 = [[LZDataModel alloc]init];
        model3.userName = @"";
        model3.nickName = @"0";
        model3.password = @"";
        model3.urlString = @"noDone";
        model3.dsc = @"noLike";
        model3.groupName = @"";
        //    model3.groupID = group.identifier;
        model3.titleString = titleArray[i];
        model3.contentString =contentArray[i];
        model3.colorString =colorArray[i];
        
        
        
      
       
        
        
        NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
        if ([kIsNewVersionString isEqualToString:@"1"]) {
        
            UIImage *image = nil;
            image = [UIImage imageNamed:@"kongImage9.png"];
            if (i == 0) {
                image = [UIImage imageNamed:@"IMG_1422.jpeg"];
            }
            if (i==19) {
                image = [UIImage imageNamed:@"IMG_1423.jpeg"];
            }
            if (i==33) {
                       image = [UIImage imageNamed:@"IMG_1426.jpeg"];
            }
            if (i==44) {
                       image = [UIImage imageNamed:@"IMG_1427.jpeg"];
                   }
            if (i==51) {
                       image = [UIImage imageNamed:@"IMG_1430.jpeg"];
                   }
            if (i==65) {
                       image = [UIImage imageNamed:@"IMG_1432.jpeg"];
                   }
            if (i==77) {
                       image = [UIImage imageNamed:@"IMG_1435.jpeg"];
                   }
            if (i==85) {
                       image = [UIImage imageNamed:@"IMG_1437.jpeg"];
                   }

            NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
            NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
            NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
            
            model3.pcmData = imageBackDataString;
            
            model3.email = [imageBackDataString stringByAppendingString:@"&&++&&"];
            
        }else{
           
            
            
            NSString *imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030134623839.jpg";
            
            if (i == 0) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924252.jpg";
            }
            if (i==19) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924294.jpg";
            }
            if (i==33) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924313.jpg";
            }
            if (i==44) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924331.jpg";
            }
            if (i==51) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924343.jpg";
            }
            if (i==65) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924364.jpg";
            }
            if (i==77) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924375.jpg";
            }
            if (i==85) {
                imageName = @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924387.jpg";
            }


            model3.pcmData = imageName;
            
            model3.email = [imageName stringByAppendingString:@"&&++&&"];
            
            
//            NSArray *imageUrl = @[@"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924252.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924294.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924313.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924331.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924343.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924364.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924375.jpg",
//                                  @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/postpicture/20211030103924387.jpg"];
            
        }
        
      
        [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
    }
//
//    LZDataModel *model3 = [[LZDataModel alloc]init];
//    model3.userName = @"";
//    model3.nickName = @"0";
//    model3.password = @"";
//    model3.urlString = @"";
//    model3.groupName = @"";
//    //    model3.groupID = group.identifier;
//    model3.titleString = @"手牵手一起逛街";
//    model3.contentString = @"大手牵小手，留下的是你的温柔";
//    model3.colorString =@"某年某月某日";
//
//
//    UIImage *image = [UIImage imageNamed:@"11.png"];
//    NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
//    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
//    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
//
//    model3.pcmData = imageBackDataString;
//    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
//
    //    [iCloudHandle saveCloudKitModelWithTitle:_speakTextView.text
    //                                     content:_speakTextView.text
    //                                  photoImage:data];
    //
    
    //    [self saveDataByNSUserDefaultsWithTitle:_speakTextView.text withKey:@"widgetTitle"];
    //    [self saveDataByNSUserDefaultsWithTitle:[ShanNianViewController getCurrentTimes] withKey:@"widgetTime"];
    
    //    NSLog(@"======================%@===========",[self readDataFromNSUserDefaultsWithKey:@"widgetTitle"]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self verifyPassword];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self createMoBiWuSiAD];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self resetBageNumber];

}


-(void)resetBageNumber
{
UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(1*1)];
clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
clearEpisodeNotification.applicationIconBadgeNumber = -1;
[[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"wanghouyusheng"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
