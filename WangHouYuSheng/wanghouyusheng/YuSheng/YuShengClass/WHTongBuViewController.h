//
//  WHTongBuViewController.h
//  wanghouyusheng
//
//  Created by 北城 on 2020/4/3.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "SNBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SizeBlock)(NSString *size);

@interface WHTongBuViewController : SNBaseViewController
//默认同步
//- (void)leiFangFaUpLoad;
//- (void)isShouYeTongBu;
- (void)tongBuVcAutoTongBuIsAlert:(BOOL)isAlert;
- (void)uploadWangHouYuShengWithAlert:(BOOL)isAlert;
@end

NS_ASSUME_NONNULL_END
