//
//  ALActiveListController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALActiveListController.h"
#import "ALPopMenuController.h"
#import "ALAddServerController.h"
#import "ALPopMenuItem.h"
#import "LocalCacheUtils.h"
#import "JsonrpcServer.h"
#import "ALFileDownloadViewCell.h"
#import "FileInfoViewController.h"
#import "APIUtils.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "ALServersController.h"
#import "ALStopListController.h"
#import "ALAboutViewController.h"

@interface ALActiveListController ()<
UIPopoverPresentationControllerDelegate,
ALPopMenuControllerDelegate,
ALAddServerControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
ALServersControllerDelegate
>

@property (strong, nonatomic) JsonrpcServer *jsonrpcServer;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *fileList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ALActiveListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"艾琳", nil);
    self.hiddenRightBarButtonItem = NO;
    self.jsonrpcServer = [[LocalCacheUtils getInstance] getDefaultJsonrpc];
    if (self.jsonrpcServer) {
        [self refreshData];
        [self startTimer];
    }
    else{
        [self showDefaultViewWithMessage:@"暂无可用服务器"];
    }
}

- (void)showPopMenu:(UIBarButtonItem *)sender
{
    NSMutableArray *menus = [NSMutableArray array];
    if (self.jsonrpcServer) {
        ALPopMenuItem *addFileItem = [ALPopMenuItem new];
        addFileItem.name = @"添加下载";
        addFileItem.actionType = ALPopMenuItemActionAddFile;
        [menus addObject:addFileItem];
        
        ALPopMenuItem *finshItem = [ALPopMenuItem new];
        finshItem.name = @"完成/停止";
        finshItem.actionType = ALPopMenuItemActionStopList;
        [menus addObject:finshItem];
    }
    
    ALPopMenuItem *serverItem = [ALPopMenuItem new];
    serverItem.name = self.jsonrpcServer ? @"服务器" : @"添加服务器";
    serverItem.actionType = self.jsonrpcServer ? ALPopMenuItemActionServers : ALPopMenuItemActionAddServer;
    [menus addObject:serverItem];
    
    ALPopMenuItem *aboutItem = [ALPopMenuItem new];
    aboutItem.name = @"关于";
    aboutItem.actionType = ALPopMenuItemActionAbout;
    [menus addObject:aboutItem];
    
    ALPopMenuController *menuController = [[ALPopMenuController alloc] init];
    menuController.menus = menus;
    menuController.delegate = self;
    menuController.preferredContentSize = CGSizeMake(120, menus.count * 44);
    menuController.modalPresentationStyle = UIModalPresentationPopover;
    menuController.popoverPresentationController.delegate = self;
    menuController.popoverPresentationController.barButtonItem = sender;
    [self presentViewController:menuController animated:YES completion:^{
        
    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

- (void)popMenuController:(ALPopMenuController *)controller didSelectItem:(ALPopMenuItem *)item
{
    switch (item.actionType) {
        case ALPopMenuItemActionAddFile:{
            [self creatTask];
        }
            break;
        case ALPopMenuItemActionAddServer:{
            ALAddServerController *serverController = [ALAddServerController new];
            serverController.delegate = self;
            [self.navigationController pushViewController:serverController animated:YES];
        }
            break;
        case ALPopMenuItemActionServers:{
            ALServersController *serversController = [ALServersController new];
            serversController.delegate = self;
            [self.navigationController pushViewController:serversController animated:YES];
        }
            break;
        case ALPopMenuItemActionStopList:{
            ALStopListController *stopController = [ALStopListController new];
            stopController.jsonrpcServer = self.jsonrpcServer;
            [self.navigationController pushViewController:stopController animated:YES];
        }
            break;
        case ALPopMenuItemActionAbout:{
            ALAboutViewController *aboutController = [ALAboutViewController new];
            [self.navigationController pushViewController:aboutController animated:YES];
        }
            break;
    }
}

- (void)addServerController:(ALAddServerController *)controller successfullyAddedServer:(JsonrpcServer *)server
{
    [self hiddenDefaultView];
    
    self.jsonrpcServer = server;
    [[LocalCacheUtils getInstance] setDefaultJsonrpc:self.jsonrpcServer];
    
    [self refreshData];
    [self startTimer];

    NSMutableArray *servers = [NSMutableArray new];
    [servers addObject:server];
    [[LocalCacheUtils getInstance] setJsonrpcArray:servers];
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
    self.title = self.jsonrpcServer.name;
    [APIUtils listActiveAndStop:_jsonrpcServer.uri rpcPasswd:_jsonrpcServer.secret success:^(NSArray *taskInfos, NSInteger count) {
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
        
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}

- (void)serversController:(ALServersController *)controller didSelectServer:(JsonrpcServer *)server
{
    [self hiddenDefaultView];
    if (![self.jsonrpcServer.name isEqualToString:server.name]) {
        self.jsonrpcServer = server;
        [[LocalCacheUtils getInstance] setDefaultJsonrpc:self.jsonrpcServer];
        [self refreshData];
    }
}

- (void)serversController:(ALServersController *)controller didDeleteServer:(JsonrpcServer *)server
{
    if ([self.jsonrpcServer.name isEqualToString:server.name]) {
        NSArray *servers = [[LocalCacheUtils getInstance] getJsonrpcArray];
        JsonrpcServer *rpcServer = servers.firstObject;
        if (rpcServer) {
            self.jsonrpcServer = rpcServer;
            [self refreshData];
        }
        else{
            [self stopTimer];
            self.jsonrpcServer = nil;
            self.fileList = nil;
            [self.tableView reloadData];
            [self showDefaultViewWithMessage:@"暂无可用服务器"];
        }
        [[LocalCacheUtils getInstance] setDefaultJsonrpc:self.jsonrpcServer];
    }
}

- (void)creatTask
{
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"新增下载任务" message:nil];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入下载链接";
    }];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil]];
    __typeof(alertView) __weak weakAlertView = alertView;
    @weakify(self);
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        @strongify(self);
        for (UITextField *textField in weakAlertView.textFieldArray) {
            [APIUtils addUri:textField.text rpcUri:self.jsonrpcServer.uri rpcPasswd:self.jsonrpcServer.secret success:^(NSString *gid) {
                
            }failure:^(NSString *msg) {
                [MsgUtils showMsg:msg];
            }];
        }
    }]];
    [alertView showInController:self preferredStyle:TYAlertControllerStyleAlert];
}

- (void)removeTask:(TaskInfo *)taskInfo
{
    [APIUtils removeByGid:taskInfo.gid rpcUri:_jsonrpcServer.uri rpcPasswd:_jsonrpcServer.secret success:^(NSString *okmsg) {
        [MsgUtils showMsg:@"已删除下载任务"];
    }failure:nil];
}

- (void)pauseTask:(TaskInfo *)taskInfo
{
    [APIUtils pauseByGid:taskInfo.gid rpcUri:_jsonrpcServer.uri rpcPasswd:_jsonrpcServer.secret success:^(NSString *okmsg) {
        [MsgUtils showMsg:@"已暂停下载"];
    }failure:nil];
}

- (void)resumeTask:(TaskInfo *)taskInfo
{
    [APIUtils unpauseByGid:taskInfo.gid rpcUri:_jsonrpcServer.uri rpcPasswd:_jsonrpcServer.secret success:^(NSString *okmsg) {
        [MsgUtils showMsg:@"恢复下载"];
    }failure:nil];
}

@end
