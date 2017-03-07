//
//  DetailViewController.m
//  LYSAutoScrollView
//
//  Created by jk on 2017/3/6.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "DetailViewController.h"
#import "LYSAutoScrollView.h"
#import "LYSNoticeView.h"

@interface DetailViewController ()<LYSAutoScrollViewDelegate>
@property(nonatomic,strong)LYSAutoScrollView *listView;
@property(nonatomic,strong)LYSNoticeView *noticeView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}


-(LYSAutoScrollView*)listView{
    if(!_listView){
        _listView = [[LYSAutoScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)/2 + 40, CGRectGetWidth(self.view.frame), 80) withItemView:[UILabel class]];
        _listView.layer.borderWidth = 1;
        _listView.delegate = self;
    }
    return _listView;
}

-(LYSNoticeView*)noticeView{
    if (!_noticeView) {
        _noticeView = [[LYSNoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.listView.frame) + 20, self.view.frame.size.width, 40)];
    }
    return _noticeView;
}

-(void)updateItem:(NSDictionary *)item itemView:(UIView *)itemView{
    UILabel * lb = (UILabel*)itemView;
    lb.text = @"";
    lb.text = [item objectForKey:@"title"];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@{@"title":@"李焱李焱生李焱生李焱生李焱生李焱生李焱生李焱生李焱生李焱生生"}];
    [items addObject:@{@"title":@"liyansheng"}];
    [items addObject:@{@"title":@"李辉耀1"}];
    [items addObject:@{@"title":@"李辉耀2"}];
    [items addObject:@{@"title":@"李辉耀3"}];
    [items addObject:@{@"title":@"李辉耀4"}];
    self.listView.items = items;
//    self.listView.scrollDirection = BottomToTop;
    self.listView.interval = 1.0;
    self.listView.tapBlock = ^(NSDictionary *item){
        NSLog(@"您选中了%@",item);
    };
    self.listView.scrollDirection = RightToLeft;
    [self.view addSubview:self.listView];
    [self.listView start];
    

    [self.view addSubview:self.noticeView];
    self.noticeView.imageUrl = @"notice_icon_1";
    self.noticeView.scrollDirection = BottomToTop;
    self.noticeView.items = items;
    [self.noticeView start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.listView stopTimer];
}

-(void)dealloc{
//    [self.listView releaseTimer];
    NSLog(@"%@ was dealloced",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
