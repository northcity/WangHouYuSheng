//
//  NcSuperVipCollectionViewCell.m
//  NCAlertView
//
//  Created by 2345 on 2019/7/30.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import "NcSuperVipCollectionViewCell.h"
#import "NCAlertView.h"

@implementation NcSuperVipCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2 - NC_kAUTOWIDTH(17.5), NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(35), NC_kAUTOWIDTH(35))];

        if (PNCisIPAD) {
            _iconImageView.frame = CGRectMake(self.contentView.frame.size.width/2 - (17.5), (15), (35), (35));

        }
        _iconImageView.backgroundColor = [UIColor clearColor];

    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame) + NC_kAUTOWIDTH(2), self.contentView.frame.size.width, NC_kAUTOWIDTH(20))];
        
        if (PNCisIPAD) {
                   _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame) + (2), self.contentView.frame.size.width, (20));

               }
        if (@available(iOS 13.0, *)) {
            _titleLabel.textColor = [UIColor labelColor];
        } else {
            _titleLabel.textColor = [UIColor blackColor];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(15)] : [UIFont boldSystemFontOfSize:NC_kAUTOWIDTH(13)];
        _titleLabel.text = @"充氮酱板鸭62...";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + NC_kAUTOWIDTH(2), self.contentView.frame.size.width, NC_kAUTOWIDTH(20))];
        if (PNCisIPAD) {
            _priceLabel.frame =CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + (2), self.contentView.frame.size.width, (20));
        }
        
        
        if (@available(iOS 13.0, *)) {
                UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                    if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                        return [UIColor lightGrayColor];
                    }else {
                        return [UIColor darkGrayColor];
                    }
                }];
                self.priceLabel.textColor = backViewColor;
            } else {
                self.priceLabel.textColor = [UIColor grayColor];
            }
        
        
        
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = PNCisIPAD ? [UIFont systemFontOfSize:(13)]: [UIFont systemFontOfSize:NC_kAUTOWIDTH(11)];
        _priceLabel.text = @"券后 ￥68.0";
        _priceLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _priceLabel;
}

//- (void)setCellWithModel:(GBSimilarGoodsModel *)model {
//    
//}

- (void)setCell{
    
}
@end
