//
//  WHCollectionViewCell.h
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/27.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)CALayer *subLayer;
- (void)setContentViewWithModel:(LZDataModel *)model;

@end

NS_ASSUME_NONNULL_END
