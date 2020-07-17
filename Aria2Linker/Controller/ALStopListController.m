//
//  FLStopListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALStopListController.h"
#import "ALFileDownloadViewCell.h"
#import "FileInfoViewController.h"
#import "APIUtils.h"

@interface ALStopListController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *fileList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ALStopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@-完成/停止",_jsonrpcServer.name];
    if (self.jsonrpcServer) {
        [self refreshData];
        [self startTimer];
    }
    else{
        [self showDefaultViewWithMessage:@"没有完成/停止的文件"];
    }
}

- (void)goBack{
    [self stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)startTimer
{
    if (!_jsonrpcServer) {
        return;
    }
    if (_timer && !_timer.valid) {
        [_timer fire];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)refreshData
{
    [APIUtils listStopped:_jsonrpcServer.uri rpcPasswd:_jsonrpcServer.secret success:^(NSArray *taskInfos, NSInteger count) {
        self.fileList = taskInfos;
        [self.tableView reloadData];
    }failure:^(NSString *msg) {
        [MsgUtils showMsg:msg];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 67;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];

        _tableView.backgroundColor = ymBackgroudColor;
        [_tableView registerClass:[ALFileDownloadViewCell class] forCellReuseIdentifier:@"FileCellText"];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALFileDownloadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCellText" forIndexPath:indexPath];
    TaskInfo *act = _fileList[indexPath.row];
    cell.active = act;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskInfo *taskInfo = self.fileList[indexPath.row];
    FileInfoViewController *vc = [FileInfoViewController new];
    vc.gid = taskInfo.gid;
    vc.rpcUri = _jsonrpcServer.uri;
    vc.secret = _jsonrpcServer.secret;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
