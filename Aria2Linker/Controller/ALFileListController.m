//
//  ALFileListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALFileListController.h"
#import "APIUtils.h"
#import "ALJsonrpcServer.h"
#import "ALFileDownloadViewCell.h"
#import "FileInfoViewController.h"
#import "APIUtils.h"
#import "ALFileListViewModel.h"

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

- (void)addObservers
{
    [self.viewModel addObserver:self forKeyPath:@"taskCount" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObservers
{
    [self.viewModel removeObserver:self forKeyPath:@"taskCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"taskCount"]) {
        [self.tableView reloadData];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)startTimer
{
    if (!_jsonrpcServer) {
        return;
    }
    if (_timer && !_timer.valid) {
        [_timer fire];
    } else {
        @weakify(self);
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self refreshData];
        }];
    }
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)refreshData{
    if (self.jsonrpcServer) {
        [self.viewModel requestFileTasksWithServer:self.jsonrpcServer];
    }
    else{
        [self.viewModel cleanUp];
    }
}

- (void)requestFileTasksSuccess:(BOOL)success withMessage:(NSString *)message
{
    if (success) {
        if (!self.viewModel.taskCount) {
            [self showDefaultViewWithMessage:@"没有下载中的任务"];
        }
    }else{
        [MsgUtils showMsg:message];
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[ALFileDownloadViewCell class] forCellReuseIdentifier:@"FileCellText"];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALFileDownloadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCellText" forIndexPath:indexPath];
    cell.delegate = (id)self;
    TaskInfo *act = self.viewModel.fileTasks[indexPath.row];
    cell.active = act;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.fileTasks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskInfo *taskInfo = self.viewModel.fileTasks[indexPath.row];
    FileInfoViewController *vc = [FileInfoViewController new];
    vc.gid = taskInfo.gid;
    vc.rpcUri = _jsonrpcServer.uri;
    vc.secret = _jsonrpcServer.secret;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        TaskInfo *taskInfo = self.viewModel.fileTasks[indexPath.row];
        [self removeTask:taskInfo];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}

- (void)removeTask:(TaskInfo *)taskInfo
{
    
}

@end
