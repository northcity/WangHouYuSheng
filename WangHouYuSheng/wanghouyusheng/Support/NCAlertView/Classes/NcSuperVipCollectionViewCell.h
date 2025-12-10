//
//  NcSuperVipCollectionViewCell.h
//  NCAlertView
//
//  Created by 2345 on 2019/7/30.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NcSuperVipCollectionViewCell : UICollectionViewCell
//猜你喜欢商品大图imageview
@property (nonatomic, strong) UIImageView *iconImageView;
//商品标题
@property (nonatomic, strong) UILabel *titleLabel;
//商品价格
@property (nonatomic, strong) UILabel *priceLabel;
//- (void)setCellWithModel:(GBSimilarGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
