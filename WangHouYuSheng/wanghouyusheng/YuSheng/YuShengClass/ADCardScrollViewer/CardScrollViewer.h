//
//  CardScrollViewer.h
//  Demo
//
//  Created by hztuen on 2017/6/8.
//  Copyright © 2017年 cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)(NSInteger currentIndex);


@protocol CardScrollDelegate <NSObject>

@optional

//滚动代理方法
- (void)CardScrollViewerDidSelectAtIndex:(NSInteger)index;

@end

@interface CardScrollViewer : UIView

@property (weak, nonatomic) id <CardScrollDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy)TapBlock tapBlock;

@property (nonatomic, strong) UISwipeGestureRecognizer *down;//下滑手势
@property (nonatomic, strong) UISwipeGestureRecognizer *up;//上滑手势

@property (nonatomic, assign)    NSInteger currentIndex;

- (void)swipeDown:(UISwipeGestureRecognizer *)swipeRecognizer;

- (void)loadData;
- (void)setCollViewBackImageViewImage;

@end
