//
//  WHCollectionHeaderView.m
//  wanghouyusheng
//
//  Created by 北城 on 2020/3/27.
//  Copyright © 2020 com.beicheng. All rights reserved.
//

#import "WHCollectionHeaderView.h"

@implementation WHCollectionHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
        [self createLab];
    }
    return self;
}
- (void)createLab{
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOWIDTH(12.5), kAUTOWIDTH(25), kAUTOWIDTH(25))];
    [self addSubview:self.headerImageView];
  
    
    self.headerLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + kAUTOWIDTH(10), kAUTOWIDTH(12.5), ScreenWidth - kAUTOWIDTH(50), kAUTOWIDTH(25))];
    [self addSubview:self.headerLab];
    self.headerLab.font = PNCisIPAD ? [UIFont fontWithName:@"HeiTi SC" size:(15)] : [UIFont fontWithName:@"HeiTi SC" size:kAUTOWIDTH(13)];
    self.headerLab.textColor = PNCColorWithHex(0x515151);
    
    if (PNCisIPAD) {
          self.headerImageView.frame = CGRectMake((15), (12.5), (25), (25));
        self.headerLab.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + (10), (12.5), ScreenWidth - (50), (25));

      }
}
@end
