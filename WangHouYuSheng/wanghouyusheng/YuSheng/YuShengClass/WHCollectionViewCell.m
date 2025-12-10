//
//  WHCollectionViewCell.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/27.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHCollectionViewCell.h"

@implementation WHCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置CollectionViewCell中的图像框
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imageView.layer.cornerRadius = kAUTOWIDTH(7);
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.imageView];
        
        self.subLayer = [CALayer layer];
        CGRect fixCardframe= self.imageView.frame;
        self.subLayer.frame = fixCardframe;
        self.subLayer.cornerRadius = kAUTOWIDTH(7);
        self.subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        self.subLayer.masksToBounds=NO;
        self.subLayer.shadowColor=PNCColorWithHex(0x1e1e1e).CGColor;
        self.subLayer.shadowOffset=CGSizeMake(0,0);
        self.subLayer.shadowOpacity=0.4f;
        self.subLayer.shadowRadius= kAUTOWIDTH(3);
        [self.layer insertSublayer:self.subLayer below:self.imageView.layer];
        
        
        //文本框
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(kAUTOWIDTH(5),CGRectGetWidth(self.frame) - kAUTOWIDTH(20), CGRectGetWidth(self.frame) - kAUTOWIDTH(5), kAUTOWIDTH(15))];
        self.label.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(10)];
        self.label.textColor = PNCColorWithHex(0xffffff);
        self.label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.label];
        
//        self.label.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.label.layer.borderWidth = 2;
//        self.label.layer.cornerRadius = kAUTOWIDTH(15)/2;
//        self.label.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)setContentViewWithModel:(LZDataModel *)model{
   
    
    NSArray *imageNameArr = [model.email componentsSeparatedByString:@"&&++&&"];
    
    
    
    NSString *kIsNewVersionString = [[NSUserDefaults standardUserDefaults] objectForKey:kNewVersion];
    if ([kIsNewVersionString isEqualToString:@"1"]) {
        UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
        self.imageView.image = image;

    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageNameArr.firstObject] placeholderImage:kPlaceholderImage];
    }
    
    self.label.text = model.titleString;

}

@end
