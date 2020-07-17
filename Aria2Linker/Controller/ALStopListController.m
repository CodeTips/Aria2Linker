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
#import "JsonrpcServer.h"
@interface ALStopListController ()

@end

@implementation ALStopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@-完成/停止",self.jsonrpcServer.name];
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

- (void)refreshData
{
    [APIUtils listStopped:self.jsonrpcServer.uri rpcPasswd:self.jsonrpcServer.secret success:^(NSArray *taskInfos, NSInteger count) {
        self.fileList = taskInfos;
        [self.tableView reloadData];
    }failure:^(NSString *msg) {
        [MsgUtils showMsg:msg];
    }];
}

- (void)removeTask:(TaskInfo *)taskInfo
{
    [APIUtils removeResultByGid:taskInfo.gid rpcUri:self.jsonrpcServer.uri rpcPasswd:self.jsonrpcServer.secret success:^(NSString *okmsg) {
        [self refreshData];
        [MsgUtils showMsg:@"已删除下载记录"];
    }failure:nil];
}

@end
