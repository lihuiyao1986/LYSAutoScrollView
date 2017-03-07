//
//  LYSNoticeView.h
//  LYSAutoScrollView
//
//  Created by jk on 2017/3/7.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSAutoScrollView.h"

@interface LYSNoticeView : UIView

#pragma mark - 内容
@property(nonatomic,copy)NSMutableArray *items;

#pragma mark - imageUrl
@property(nonatomic,copy)NSString *imageUrl;

#pragma mark - 点击时回调
@property(nonatomic,copy)TapBlock tapBlock;

#pragma mark - 滚动的方向
@property(nonatomic,assign)ScrollDirection scrollDirection;

#pragma mark - 自动滚动时的时间间隔
@property(nonatomic,assign)NSTimeInterval interval;

#pragma mark - 颜色
@property(nonatomic,strong)UIColor *itemColor;

#pragma mark - 字体
@property(nonatomic,strong)UIFont *itemFont;

#pragma mark - 分割线的颜色
@property(nonatomic,strong)UIColor *seperatorLineColor;

#pragma mark - 开始
-(void)start;

#pragma mark - 结束
-(void)stop;

#pragma mark - 释放定时器
-(void)stopTimer;

@end
