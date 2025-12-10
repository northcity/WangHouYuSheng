//
//  SettingTableViewCell.h
//  wanghouyusheng
//
//  Created by 北城 on 2021/11/7.
//  Copyright © 2021 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView * label;
@property(nonatomic,strong)UIView * redPointView;
@property(nonatomic,strong)UIImageView * vipImageView;
@property (nonatomic,strong)UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
