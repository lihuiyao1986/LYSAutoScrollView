//
//  LYSNoticeView.m
//  LYSAutoScrollView
//
//  Created by jk on 2017/3/7.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LYSNoticeView.h"

@interface LYSNoticeView ()<LYSAutoScrollViewDelegate>

@property(nonatomic,strong)LYSAutoScrollView *scrollView;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIView *seperatorLine;

@end

@implementation LYSNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

-(void)initConfig{
    _itemFont = [UIFont systemFontOfSize:12];
    _itemColor = [self colorWithHexString:@"414141" alpha:1.0];
    [self setupUI];
}

#pragma mark - 创建UI
-(void)setupUI{
    [self addSubview:self.scrollView];
    [self addSubview:self.seperatorLine];
    [self addSubview:self.imageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 0, self.frame.size.height, self.frame.size.height);
    self.seperatorLine.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 2 , 0.5, self.frame.size.height - 1);
    self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.seperatorLine.frame) + 10, 0, self.frame.size.width - CGRectGetMaxX(self.seperatorLine.frame) - 20, self.frame.size.height);
}

-(UIView*)seperatorLine{
    if (!_seperatorLine) {
        _seperatorLine = [[UIView alloc] init];
        _seperatorLine.backgroundColor = [self colorWithHexString:@"e3e2e2" alpha:1.0];
    }
    return _seperatorLine;
}

-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

-(void)setScrollDirection:(ScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    self.scrollView.scrollDirection = _scrollDirection;
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    self.imageView.image = [UIImage imageNamed:_imageUrl];
}

-(void)setTapBlock:(TapBlock)tapBlock{
    _tapBlock = tapBlock;
    self.scrollView.tapBlock = _tapBlock;
}

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    self.scrollView.items = _items;
}

-(void)setInterval:(NSTimeInterval)interval{
    _interval = interval;
    self.scrollView.interval = _interval;
}

-(void)setSeperatorLineColor:(UIColor *)seperatorLineColor{
    _seperatorLineColor = seperatorLineColor;
    self.seperatorLine.backgroundColor = _seperatorLineColor;
    
}

-(LYSAutoScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[LYSAutoScrollView alloc]initWithFrame:CGRectZero withItemView:[UILabel class]];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(void)updateItem:(NSDictionary *)item itemView:(UIView *)itemView{
    if ([itemView isKindOfClass:[UILabel class]]) {
        UILabel *myView = (UILabel*)itemView;
        myView.textColor = self.itemColor;
        myView.font = self.itemFont;
        myView.text = [item objectForKey:@"title"];
    }
}

-(void)setItemViewStyle:(UIView *)itemView{
    if ([itemView isKindOfClass:[UILabel class]]) {
        UILabel *myView = (UILabel*)itemView;
        myView.numberOfLines = 1;
        myView.lineBreakMode = NSLineBreakByTruncatingTail;
    }
}

#pragma mark - 生成16进制颜色
-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark - 开始
-(void)start{
    [self.scrollView start];
}

#pragma mark - 结束
-(void)stop{
    [self.scrollView stop];
}

#pragma mark - 释放定时器
-(void)stopTimer{
    [self.scrollView stopTimer];
}

@end
