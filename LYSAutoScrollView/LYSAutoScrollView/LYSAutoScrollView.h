//
//  LYSAutoScrollView.h
//  LYSAutoScrollView
//
//  Created by jk on 2017/3/6.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ScrollDirection){
    LeftToRight,
    RightToLeft,
    TopToBottom,
    BottomToTop
};


typedef void(^TapBlock)(NSDictionary * item);

@class LYSAutoScrollView;

@protocol LYSAutoScrollViewDelegate <NSObject>

-(void)updateItem:(NSDictionary*)item itemView:(UIView*)itemView;

@end

@interface LYSAutoScrollView : UIView

#pragma mark - 自动滚动时的时间间隔
@property(nonatomic,assign)NSTimeInterval interval;

#pragma mark - 内容视图Class
@property(nonatomic,strong)Class itemViewClass;

#pragma mark - items
@property(nonatomic,strong)NSMutableArray *items;

#pragma mark - 代理
@property(nonatomic,weak)id<LYSAutoScrollViewDelegate> delegate;

#pragma mark - 滚动的方向
@property(nonatomic,assign)ScrollDirection scrollDirection;

#pragma mark - 点击后处理事件
@property(nonatomic,copy)TapBlock tapBlock;

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame withItemView:(Class)itemViewClass;

#pragma mark - 开始
-(void)start;

#pragma mark - 结束
-(void)stop;

#pragma mark - 释放定时器
-(void)stopTimer;


//-(void)releaseTimer;
@end
