//
//  ListTableViewCell.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/6.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
//        [self updateFrame];
    }
    return self;
}

- (void)createSubViews{
    self.fatherView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(25), kAUTOHEIGHT(5), ScreenWidth - kAUTOWIDTH(50), kAUTOWIDTH(140))];
    
    [self.contentView addSubview:self.fatherView];
    self.fatherView.layer.cornerRadius  = PNCisIPAD ? 6 : kAUTOHEIGHT(6);
    
    
    self.fatherView.layer.masksToBounds = YES;
    self.fatherView.backgroundColor = [UIColor whiteColor];
    
    if (PNCisIPAD) {
        self.fatherView.frame = CGRectMake((25), (5), ScreenWidth - (50), (140));
    }
    
    self.subLayer = [CALayer layer];
    CGRect fixCardframe= self.fatherView.frame;
    self.subLayer.frame = fixCardframe;
    self.subLayer.cornerRadius = PNCisIPAD ? 6 : kAUTOWIDTH(6);
    self.subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    self.subLayer.masksToBounds=NO;
    self.subLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
    self.subLayer.shadowOffset=CGSizeMake(0,0);
    self.subLayer.shadowOpacity=0.2f;
    self.subLayer.shadowRadius= PNCisIPAD ? 12 : kAUTOWIDTH(12);
    [self.contentView.layer insertSublayer:self.subLayer below:self.fatherView.layer];
         
    
    
    self.seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAUTOWIDTH(110), self.fatherView.frame.size.height)];
    self.seleImage.contentMode = UIViewContentModeScaleAspectFill;
    self.seleImage.layer.masksToBounds = YES;
    [self.fatherView addSubview:self.seleImage];
    
    _yinHaoImageView = [[UIImageView alloc]init];
    _yinHaoImageView.frame = CGRectMake(kAUTOWIDTH(115),kAUTOWIDTH(5), kAUTOWIDTH(20), kAUTOWIDTH(20));
    _yinHaoImageView.image = [UIImage imageNamed:@"引号1"];
    [self.fatherView addSubview:_yinHaoImageView];
    
    _xiaYinHaoImageView = [[UIImageView alloc]init];
    _xiaYinHaoImageView.frame = CGRectMake(self.fatherView.frame.size.width - kAUTOWIDTH(25),self.fatherView.frame.size.height - kAUTOWIDTH(25), kAUTOWIDTH(20), kAUTOWIDTH(20));
    _xiaYinHaoImageView.image = [UIImage imageNamed:@"引号"];
    [self.fatherView addSubview:_xiaYinHaoImageView];
       
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(kAUTOWIDTH(140),self.fatherView.frame.size.height/2 - kAUTOWIDTH(25), self.fatherView.frame.size.width - kAUTOWIDTH(150), kAUTOHEIGHT(25));
    self.titleLabel.textColor = PNCColorWithHex(0x1e1e1e);
    self.titleLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(15)] : [UIFont boldSystemFontOfSize:kAUTOWIDTH(13)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.fatherView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.frame = CGRectMake(kAUTOWIDTH(140), CGRectGetMaxY(self.titleLabel.frame) + kAUTOHEIGHT(2), ScreenWidth - kAUTOWIDTH(200), kAUTOWIDTH(30));
    self.contentLabel.textColor =  PNCColor(180, 181, 182);
    self.contentLabel.font = PNCisIPAD ? [UIFont boldSystemFontOfSize:(12)] :  [UIFont systemFontOfSize:kAUTOWIDTH(9)];
    self.contentLabel.numberOfLines = 0;
    [self.fatherView addSubview:self.contentLabel];
     
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.frame = CGRectMake(self.fatherView.frame.size.width - kAUTOWIDTH(100), CGRectGetMinY(self.xiaYinHaoImageView.frame) - kAUTOWIDTH(20), kAUTOWIDTH(80), kAUTOHEIGHT(20));
    self.dateLabel.textColor = PNCColorWithHex(0xdcdcdc);
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.font =  PNCisIPAD ? [UIFont boldSystemFontOfSize:(12)] :  [UIFont boldSystemFontOfSize:kAUTOWIDTH(9)];
    [self.fatherView addSubview:self.dateLabel];

    
    self.likeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"亲密付"]];
    self.likeImage.frame = CGRectMake(kAUTOWIDTH(115), CGRectGetMaxY(self.seleImage.frame) - kAUTOHEIGHT(20), kAUTOWIDTH(15), kAUTOHEIGHT(15));
    [self.fatherView addSubview:self.likeImage];
    
    
    if (PNCisIPAD) {
        self.seleImage.frame = CGRectMake(0, 0, (110), self.fatherView.frame.size.height);
        _yinHaoImageView.frame = CGRectMake((115),(5), (20), (20));
        _xiaYinHaoImageView.frame = CGRectMake(self.fatherView.frame.size.width - (25),self.fatherView.frame.size.height - (25), (20), (20));
        self.titleLabel.frame = CGRectMake((140),self.fatherView.frame.size.height/2 - (25), self.fatherView.frame.size.width - (150), (25));
        self.contentLabel.frame = CGRectMake((140), CGRectGetMaxY(self.titleLabel.frame) + (2), ScreenWidth - (200), (30));
        self.dateLabel.frame = CGRectMake(self.fatherView.frame.size.width - (100), CGRectGetMinY(self.xiaYinHaoImageView.frame) - (20), (80), (20));
        self.likeImage.frame = CGRectMake((115), CGRectGetMaxY(self.seleImage.frame) - (20), (15), (15));


        }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setContentViewWithModel:(LZDataModel *)model{

    NSArray *imageNameArr = [model.email componentsSeparatedByString:@"&&++&&"];

    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
            UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
            self.seleImage.image = image;
    }else{
        [self.seleImage sd_setImageWithURL:[NSURL URLWithString:imageNameArr.firstObject] placeholderImage:kPlaceholderImage];
    }
    
    
    self.dateLabel.text = model.colorString;
    self.nameLabel.text = @"往后 | 余生";
    
    if (model.contentString.length > 34) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@...",[model.contentString substringToIndex:33]];
    }else{
        self.contentLabel.text = model.contentString;
    }
    
    [self.contentLabel sizeToFit];
     self.contentLabel.frame = CGRectMake(kAUTOWIDTH(140), CGRectGetMaxY(self.titleLabel.frame) + kAUTOHEIGHT(2), ScreenWidth - kAUTOWIDTH(200),self.contentLabel.frame.size.height);
    self.titleLabel.text = model.titleString;

    if (PNCisIPAD) {
        self.contentLabel.frame = CGRectMake((140), CGRectGetMaxY(self.titleLabel.frame) + (2), ScreenWidth - (200),self.contentLabel.frame.size.height);

    }
    
    if ([model.dsc isEqualToString:@"isLike"]) {
        self.likeImage.hidden = NO;
    }else{
        self.likeImage.hidden = YES;

    }
}
- (void)setContentViewWith:(UIImage *)seleImage ContentLabel:(NSString *)contentLabel DateString:(NSString *)dataString{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
