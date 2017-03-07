//
//  LYSAutoScrollView.m
//  LYSAutoScrollView
//
//  Created by jk on 2017/3/6.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSAutoScrollView.h"

@interface LYSAutoScrollView ()<UIScrollViewDelegate>{
    UIView *_firstView;
    UIView *_secondView;
    UIView *_thirdView;
    NSInteger _currentIndex;
    CADisplayLink *_displayLink;
}

#pragma mark - 容器视图
@property(nonatomic,strong)UIView *containerView;

#pragma mark - 是否正在滚动
@property(nonatomic,assign)BOOL isScrolling;

@end

@implementation LYSAutoScrollView

- (instancetype)initWithFrame:(CGRect)frame withItemView:(Class)itemViewClass
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemViewClass = itemViewClass;
        _items = [NSMutableArray array];
        _interval = 2.0;
        _currentIndex = 0;
        _scrollDirection = RightToLeft;
        [self initConfig];
    }
    return self;
}

#pragma mark - 初始化配置
-(void)initConfig{
    
    [self initCADisplayLink];
    
    [self setupUI];
    
}

#pragma mark - 初始化displayLink
-(void)initCADisplayLink{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextPage)];
    _displayLink.frameInterval = self.interval * 60.0;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
}

#pragma mark - 处理手势
-(void)handleTap:(UITapGestureRecognizer*)gesture{
    if (self.items.count > 0){
        if (self.tapBlock){
            self.tapBlock(self.items[_currentIndex]);
        }
    }
}

#pragma mark 
-(void)setInterval:(NSTimeInterval)interval{
    _interval = interval;
    _displayLink.frameInterval = self.interval * 60.0;
}

#pragma mark - 开始
-(void)start{
    if (!self.isScrolling) {
        _displayLink.paused = NO;
        self.isScrolling = YES;
    }
}

#pragma mark - 下一页
-(void)nextPage{
    __weak typeof (self) MyWeakSelf = self;
    if (self.items.count >= 1) {
        if (self.items.count == 1) {
            [self stop];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect containerFrame = MyWeakSelf.containerView.frame;
            switch (MyWeakSelf.scrollDirection) {
                case RightToLeft:
                    containerFrame.origin.x = -2 * MyWeakSelf.frame.size.width;
                    break;
                case LeftToRight:
                    containerFrame.origin.x = 0;
                    break;
                case TopToBottom:
                    containerFrame.origin.y = -2 * MyWeakSelf.frame.size.height;
                    break;
                case BottomToTop:
                    containerFrame.origin.y = -MyWeakSelf.frame.size.height;
                    break;
            }
            MyWeakSelf.containerView.frame = containerFrame;
        } completion:^(BOOL finished) {
            [MyWeakSelf updateByIndex:_currentIndex + 1];
        }];
    }else{
        [self stop];
    }
}

#pragma mark - 停止
-(void)stop{
    _displayLink.paused = YES;
    self.isScrolling = NO;
}

#pragma mark - 按照索引更新
-(void)updateByIndex:(NSInteger)index{
    if (self.items.count > 0) {
        if (index < 0) { //第一页
            index = self.items.count - 1;
        }else if(index > self.items.count - 1){ //最后一页
            index = 0;
        }
        _currentIndex = index;
        [self reloadItems];
    }
}

#pragma mark - 加载item
-(void)reloadItems{
    NSInteger preIndex = 0 , nextIndex = 0;
    if (self.items.count > 1) {
        if (_currentIndex == 0) {
            preIndex = self.items.count - 1;
            nextIndex = 1;
        }else if(_currentIndex == self.items.count - 1){
            preIndex = self.items.count - 2;
            nextIndex = 0;
        }else{
            preIndex = _currentIndex - 1;
            nextIndex = _currentIndex + 1;
        }
    }
    [self updateItemContent:preIndex currentIndex:_currentIndex nextIndex:nextIndex];
    CGRect containerFrame = self.containerView.frame;
    switch (self.scrollDirection) {
        case LeftToRight:
            containerFrame.origin.x = 2 * self.frame.size.width;
            break;
        case RightToLeft:
            containerFrame.origin.x = - self.frame.size.width;
            break;
        case TopToBottom:
            containerFrame.origin.y = - self.frame.size.height;
            break;
        case BottomToTop:
            containerFrame.origin.y = - 2 * self.frame.size.height;
            break;
    }
    self.containerView.frame = containerFrame;
}

#pragma mark - 更新item内容
-(void)updateItemContent:(NSInteger)preIndex currentIndex:(NSInteger)currentIndex nextIndex:(NSInteger)nextIndex{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateItem:itemView:)]) {
        [self.delegate updateItem:self.items[preIndex] itemView:_firstView];
        [self.delegate updateItem:self.items[currentIndex] itemView:_secondView];
        [self.delegate updateItem:self.items[nextIndex] itemView:_thirdView];
    }
}

#pragma mark - 创建ui
-(void)setupUI{
    NSAssert([self.itemViewClass isSubclassOfClass:[UIView class]], @"itemViewClass 类型错误");
    [self addSubview:self.containerView];
    self.clipsToBounds = YES;
    _firstView = [[self.itemViewClass alloc]init];
    _firstView.userInteractionEnabled = YES;
    [_firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    _secondView = [[self.itemViewClass alloc]init];
    _secondView.userInteractionEnabled = YES;
    [_secondView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    _thirdView = [[self.itemViewClass alloc]init];
    _thirdView.userInteractionEnabled = YES;
    [_thirdView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.containerView addSubview:_firstView];
    [self.containerView addSubview:_secondView];
    [self.containerView addSubview:_thirdView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    switch (self.scrollDirection) {
        case LeftToRight:
            self.containerView.frame = CGRectMake(0, 0, 3 * CGRectGetWidth(self.frame), self.frame.size.height);
            _firstView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _secondView.frame = CGRectMake(CGRectGetMaxX(_firstView.frame), 0, self.frame.size.width, CGRectGetHeight(self.frame));
            _thirdView.frame = CGRectMake(CGRectGetMaxX(_secondView.frame), 0, self.frame.size.width, CGRectGetHeight(self.frame));
            break;
        case RightToLeft:
            self.containerView.frame = CGRectMake(0, 0, 3 * CGRectGetWidth(self.frame), self.frame.size.height);
            _firstView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _secondView.frame = CGRectMake(CGRectGetMaxX(_firstView.frame), 0, self.frame.size.width, CGRectGetHeight(self.frame));
            _thirdView.frame = CGRectMake(CGRectGetMaxX(_secondView.frame), 0, self.frame.size.width, CGRectGetHeight(self.frame));
            break;
        case TopToBottom:
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 3 * self.frame.size.height);
            _firstView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _secondView.frame = CGRectMake(0, CGRectGetMaxY(_firstView.frame), self.frame.size.width, CGRectGetHeight(self.frame));
            _thirdView.frame = CGRectMake(0, CGRectGetMaxY(_secondView.frame), self.frame.size.width, CGRectGetHeight(self.frame));
            break;
        case BottomToTop:
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 3 * self.frame.size.height);
            _firstView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _secondView.frame = CGRectMake(0, CGRectGetMaxY(_firstView.frame), self.frame.size.width, CGRectGetHeight(self.frame));
            _thirdView.frame = CGRectMake(0, CGRectGetMaxY(_secondView.frame), self.frame.size.width, CGRectGetHeight(self.frame));
            break;
    }
    
}

-(UIView*)containerView{
    if (!_containerView) {
        _containerView = [[UIScrollView alloc]init];
    }
    return _containerView;
}

-(void)stopTimer{
    if (_displayLink) {
        _displayLink.paused = YES;
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

-(void)dealloc{
    NSLog(@"%@ was dealloced", NSStringFromClass([self class]));
}

@end
