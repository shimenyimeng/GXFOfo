//
//  OFOMessageViewController.m
//  067-- GXFOfo
//
//  Created by 顾雪飞 on 2017/9/12.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "OFOMessageViewController.h"
#import "OFOMessageHeaderView.h"
#import "OFOMessageListCell.h"

@interface OFOMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, strong) NSArray *lists;

@end

@implementation OFOMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [UILabel new];
    self.titleLbl = titleLbl;
    titleLbl.text = @"我的消息";
    titleLbl.alpha = 0;
    [self.topView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeFork"] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    [closeBtn addTarget:self action:@selector(closeMessageVc) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-20);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    UITableView *tableView = [UITableView new];
    self.tableView = tableView;
    tableView.tableHeaderView = [[OFOMessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 370)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)loadData {
    self.lists = @[@{@"icon" : @"msg_icon_hot_msg", @"title" : @"ofo通知", @"subtitle" : @"尊敬的用户，已经收到您的反馈，在您关锁...", @"rightText" : @"10:15"},
                   @{@"icon" : @"msg_icon_hot_activity", @"title" : @"活动精选", @"subtitle" : @"收到新的活动推荐", @"rightText" : @"08/20 00:00"},
                   @{@"icon" : @"msg_icon_hot_lostkid", @"title" : @"公安部儿童失踪信息", @"subtitle" : @"龙紫韩，7岁女孩，于2017年6月31日许...", @"rightText" : @"07/31 10:29"}];
    [self.tableView reloadData];
}

- (void)closeMessageVc {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSDictionary *dict = self.lists[indexPath.row];
    
//    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", dict[@"tilte"]];
//    cell.detailTextLabel.text = dict[@"subtitle"];
    if (!cell) {
        cell = [[OFOMessageListCell alloc] initWithIconName:dict[@"icon"] title:dict[@"title"] subtitle:dict[@"subtitle"] rightText:dict[@"rightText"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    NSLog(@"%f", offsetY);
    if (offsetY > 70) {
        self.titleLbl.alpha = (offsetY - 70) / 50;
    } else {
        self.titleLbl.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
