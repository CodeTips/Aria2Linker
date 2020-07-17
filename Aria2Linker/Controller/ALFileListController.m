//
//  ALFileListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALFileListController.h"
#import "APIUtils.h"
#import "JsonrpcServer.h"
#import "JsonrpcServer.h"
#import "ALFileDownloadViewCell.h"
#import "FileInfoViewController.h"
#import "APIUtils.h"

@interface ALFileListController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ALFileListController

- (void)viewDidLoad {
    [super viewDidLoad];
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

}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        TaskInfo *taskInfo = self.fileList[indexPath.row];
        [self removeTask:taskInfo];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}

- (void)removeTask:(TaskInfo *)taskInfo
{
    
}

@end
