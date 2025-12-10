                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            //
//  CardScrollViewer.m
//  Demo
//
//  Created by hztuen on 2017/6/8.
//  Copyright © 2017年 cesar. All rights reserved.
//

#import "CardScrollViewer.h"
#import "CardAnimationFlowLayout.h"
#import "CardAnimationCell.h"

@interface CardScrollViewer () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@property (nonatomic, strong) UIImageView *collectionBgView;//collectionView背景视图
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;//上滑手势

@property (nonatomic, strong) UITapGestureRecognizer *tap;//上滑手势
@property (nonatomic, strong)  UIView *buttonView;
@property (nonatomic, strong)  UIButton *button2;


@end

@implementation CardScrollViewer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self initData];
        [self buildUI];
        [self buildHongDianUI];
    }
    return self;
}

- (void)buildHongDianUI{
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - ScreenWidth/6, ScreenHeight - kAUTOHEIGHT(66), ScreenWidth/3, kAUTOHEIGHT(44))];
    
    if (PNCisIPHONEX) {
        self.buttonView.frame = CGRectMake(ScreenWidth/2 - ScreenWidth/6, ScreenHeight - kAUTOHEIGHT(66) - 88, ScreenWidth/3, kAUTOHEIGHT(44));
    }
    
    [self addSubview:self.buttonView];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, kAUTOWIDTH(44), kAUTOHEIGHT(44));
    [self.buttonView addSubview:button1];
    //    button1.backgroundColor = [UIColor blueColor];
    
   _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame = CGRectMake(ScreenWidth/6 - kAUTOWIDTH(22),0, kAUTOWIDTH(44), kAUTOHEIGHT(44));
    [self.buttonView addSubview:_button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(ScreenWidth/3 - kAUTOWIDTH(44), 0, kAUTOWIDTH(44), kAUTOHEIGHT(44));
    [self.buttonView addSubview:button3];
    
    [button1 setImage:[UIImage imageNamed:@"圆环2"] forState:UIControlStateNormal];
    [_button2 setTitle:@"半生" forState:UIControlStateNormal];
    _button2.titleLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:13];
    _button2.layer.shadowOffset =CGSizeMake(0, 0);
    _button2.layer.shadowColor = [UIColor grayColor].CGColor;
    _button2.layer.shadowRadius = 4;
    _button2.layer.shadowOpacity = 0.6;
    
//    [button2 setImage:[UIImage imageNamed:@"圆环2"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"圆环2"] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(setCollectionViewContentOffSet1) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(setCollectionViewContentOffSet2) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(setCollectionViewContentOffSet3) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCollectionViewContentOffSet1{
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
    _currentIndex = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _button2.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)setCollectionViewContentOffSet2{
    [UIView animateWithDuration:0.3 animations:^{
        _button2.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];

    [self.collectionView setContentOffset:CGPointMake(50 * kAUTOWIDTH(281),0) animated:YES];
    _currentIndex = 50;


}

- (void)setCollectionViewContentOffSet3{
    [UIView animateWithDuration:0.3 animations:^{
        _button2.transform = CGAffineTransformMakeScale(1, 1);
    }];

    [self.collectionView setContentOffset:CGPointMake(98 * kAUTOWIDTH(281),0) animated:YES];
    _currentIndex = 98;


}

- (void)loadData {
    self.dataSourceArray =[[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSourceArray= array.mutableCopy;
}
- (void)initData {
//    self.imageArray = @[@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG",@"1.JPG", @"2", @"3", @"4", @"5", @"6"];
//    
    //初始化collectionView背景视图
    
    LZDataModel *model = self.dataSourceArray[self.currentIndex];
    
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    
    self.collectionBgView = [[UIImageView alloc] initWithImage:image];
    self.collectionBgView.contentMode = UIViewContentModeScaleAspectFill;
    //毛玻璃效果
    UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    [self.collectionBgView addSubview:effectView];
}

- (void)setCollViewBackImageViewImage{
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    LZDataModel *model = array[self.currentIndex];
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    self.collectionBgView.image = image;
}

- (void)buildUI {
    CardAnimationFlowLayout *layout = [[CardAnimationFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    if (PNCisIPHONEX) {
        self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - PCTopBarHeight - 88);
    }

    
//    if ([UIScreen mainScreen].bounds.size.height >= 812.0f) {
//        self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - PCTopBarHeight);
//    }
    if (PNCisIPAD) {
        self.collectionView.frame = CGRectMake(0, 0, ScreenWidth - kAUTOWIDTH(100) , ScreenHeight - kAUTOWIDTH(100));
    }
    
    self.collectionView.backgroundView = self.collectionBgView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CardAnimationCell class] forCellWithReuseIdentifier:@"cellID"];
    [self addSubview:self.collectionView];
    
    //上滑手势
    self.up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    self.up.direction = UISwipeGestureRecognizerDirectionUp;
    [self.collectionView addGestureRecognizer:self.up];
    
    //下滑手势
    self.down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    self.down.direction = UISwipeGestureRecognizerDirectionDown;
    
    //下滑手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown:)];
    [self.collectionView addGestureRecognizer:self.tap];
}

- (void)tapDown:(UISwipeGestureRecognizer *)swipeRecognizer {
    CGPoint location = [swipeRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    LZLog(@"向下滑动了%ld个item", indexPath.row);
    CardAnimationCell *swipeCell = (CardAnimationCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (_tapBlock) {
        _tapBlock(indexPath.row);
    }
}


#pragma mark - SwipeGestureRecognizer 
- (void)swipeUp:(UISwipeGestureRecognizer *)swipeRecognizer {
    [BCShanNianKaPianManager maDaKaiShiZhenDong];

    
    CGPoint location = [swipeRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    NSLog(@"向上滑动了第%ld个item", indexPath.row);
    
    
    
    CardAnimationCell *swipeCell = (CardAnimationCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    

    
    //cell在当前collection的位置
    CGRect cellRect = [_collectionView convertRect:swipeCell.frame toView:_collectionView];
    //手势没在cell范围上
    if (cellRect.origin.x == 0 && cellRect.origin.y == 0) {
        return;
    }
    
    //手势没在当前 cell上
    if (indexPath.row != _currentIndex) {
        return;
    }
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //coverImage
        CGRect frame = swipeCell.coverImage.frame;
        frame.origin.y -= [self Suit:100];
        swipeCell.coverImage.frame = frame;
        
        //bgView
        CGRect frame2 = swipeCell.bgView.frame;
        frame2.size = CGSizeMake(swipeCell.bgView.frame.size.width + [self Suit:30], swipeCell.bgView.frame.size.height + [self Suit:20]);
        frame2.origin.x -= [self Suit:15];
        swipeCell.bgView.frame = frame2;
        
        swipeCell.bgView.alpha = 1.0;
        
        //titleView
        CGRect frame3 = swipeCell.titleView.frame;
        frame3.size = CGSizeMake(swipeCell.titleView.frame.size.width + [self Suit:30], swipeCell.titleView.frame.size.height);
        frame3.origin.x -= [self Suit:15];
        swipeCell.titleView.frame = frame3;
        
        
    } completion:^(BOOL finished) {
        self.collectionView.scrollEnabled = NO;
        swipeCell.coverImage.userInteractionEnabled = YES;
        //上滑之后移除上滑手势避免继续上滑，并添加下滑手势
        [self.collectionView removeGestureRecognizer:self.up];
        [swipeCell addGestureRecognizer:self.down];
        
//        swipeCell.coverImage.layer.shadowColor = [UIColor colorWithHexString:@"8a8a8a" alpha:1.0].CGColor;
//        swipeCell.coverImage.layer.shadowOffset = CGSizeMake(0, 5);
//        swipeCell.coverImage.layer.shadowOpacity = 0.8;
//        swipeCell.coverImage.layer.shadowRadius = 10;
        
        
    }];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)swipeRecognizer {
    [BCShanNianKaPianManager maDaKaiShiZhenDong];

    CGPoint location = [swipeRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    NSLog(@"向下滑动了%ld个item", indexPath.row);
    
    CardAnimationCell *swipeCell = (CardAnimationCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    CGRect startRact = [swipeCell convertRect:swipeCell.bounds toView:window];
    
    NSLog(@"======%",startRact);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //coverImage
        CGRect frame = swipeCell.coverImage.frame;
        frame.origin.y += [self Suit:100];
        swipeCell.coverImage.frame = frame;
        
        //bgView
        CGRect frame2 = swipeCell.bgView.frame;
        frame2.size = CGSizeMake(swipeCell.bgView.frame.size.width - [self Suit:30], swipeCell.bgView.frame.size.height - [self Suit:20]);
        frame2.origin.x += [self Suit:15];
        swipeCell.bgView.frame = frame2;
        
        swipeCell.bgView.alpha = 0.0;
        
        //titleView
        CGRect frame3 = swipeCell.titleView.frame;
        frame3.size = CGSizeMake(swipeCell.titleView.frame.size.width - [self Suit:30], swipeCell.titleView.frame.size.height);
        frame3.origin.x += [self Suit:15];
        swipeCell.titleView.frame = frame3;
        
    } completion:^(BOOL finished) {
        self.collectionView.scrollEnabled = YES;
        swipeCell.coverImage.userInteractionEnabled = NO;
        //下滑之后添加上滑手势，并移除下滑手势避免继续下滑
        [self.collectionView addGestureRecognizer:self.up];
        [swipeCell removeGestureRecognizer:self.down];
    }];
    
}


#pragma mark - UICollection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //    CGAffineTransformMake(a,b,c,d,tx,ty)
    //    ad缩放bc旋转tx,ty位移，基础的2D矩阵
//    cell.transform = CGAffineTransformMakeScale(1, 1);//CGAffineTransformMake(1.4, 0, 0, 1.4, 10, 10);
    cell.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        cell.transform = CGAffineTransformIdentity;
        cell.alpha = 1;

    } completion:nil];
    
    
    
    
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardAnimationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.tag = indexPath.row + 1000;
    
    LZDataModel *model = self.dataSourceArray[indexPath.row];

    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    [cell loadData:image];
    NSString *numberString =  [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.indexLabel.text = [self transChinese: numberString];
    
    cell.titleLabel.text = model.titleString;
    
    [cell loadDateWithModel:model];
    cell.tapCoverImageBlock = ^(NSInteger tag) {
        if ([self.delegate respondsToSelector:@selector(CardScrollViewerDidSelectAtIndex:)]) {
            [self.delegate CardScrollViewerDidSelectAtIndex:tag];
        }
    };
    
    return cell;
}

-(NSString*)transChinese:(NSString *)beforeString{
    NSString *str = beforeString;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@ to %@",str,chinese);
    return chinese;
}

#pragma mark - UIScrollView, 滚动时修正cell居中
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//配置cell居中
-(void)fixCellToCenter
{
    //最小滚动距离
    float dragMiniDistance = self.collectionView.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _currentIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _currentIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _currentIndex = _currentIndex <= 0 ? 0 : _currentIndex;
    _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;
    
    
    LZDataModel *model = self.dataSourceArray[_currentIndex];
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    self.collectionBgView.image = image;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

/**
 适配 给定4.7寸屏尺寸，适配4和5.5寸屏尺寸
 */
- (float)Suit:(float)MySuit
{
    (IS_IPHONE4INCH||IS_IPHONE35INCH)?(MySuit=MySuit/Suit4Inch):((IS_IPHONE55INCH)?(MySuit=MySuit*Suit55Inch):MySuit);
    return MySuit;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.collectionView]) {
        NSLog(@"11111111111111111111222");
        [BCShanNianKaPianManager maDaQingZhenDong];
        
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    NSLog(@"%f",ScreenWidth);

}                                            // any offset changes



@end
