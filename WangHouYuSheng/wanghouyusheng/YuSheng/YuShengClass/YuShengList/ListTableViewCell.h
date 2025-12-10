//
//  ListTableViewCell.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/6.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"

@interface ListTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView * fatherView;
@property (nonatomic,strong) UIImageView * likeImage;

@property (nonatomic, strong) UIImageView *yinHaoImageView;
@property (nonatomic, strong) UIImageView *xiaYinHaoImageView;


@property (nonatomic,strong) UIImageView * seleImage;
@property (nonatomic ,strong) UILabel * contentLabel;
@property (nonatomic ,strong) UILabel * dateLabel;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * nameLabel;

@property (nonatomic ,strong) UILabel * logoLabel;



//模糊视图图层
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;

@property(nonatomic, strong) CALayer *subLayer;
- (void)setContentViewWith:(UIImage *)seleImage ContentLabel:(NSString *)contentLabel DateString:(NSString *)dataString;
- (void)setContentViewWithModel:(LZDataModel *)model;

@end
