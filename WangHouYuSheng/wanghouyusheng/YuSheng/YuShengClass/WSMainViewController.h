//
//  WSMainViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/1.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "YSBaseViewController.h"
#import "CardScrollViewer.h"

#import "SecondViewController.h"

@protocol WSMainViewDelegate <NSObject>

@optional

//滚动代理方法
- (void)CardScrollViewerDidSelectAtIndex:(NSInteger)index;

@end

typedef void(^PushBlock)(NSInteger currentIndex);

@interface WSMainViewController : YSBaseViewController <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic, strong) CardScrollViewer *cardScrollViewer;
@property (nonatomic, copy) PushBlock pushBlock;

@property (nonatomic, assign)id<WSMainViewDelegate>delegate;

/**
 *  记录当前点击的indexPath
 */
@property (nonatomic, assign) NSInteger currentIndex;
- (void)buildUI;
-(void)initData;
@end
