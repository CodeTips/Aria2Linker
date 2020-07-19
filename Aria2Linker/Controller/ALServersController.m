//
//  ALServersController.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALServersController.h"
#import "ALAddServerController.h"
#import "LocalCacheUtils.h"
#import "MJRefreshStateHeader.h"
#import "ALJsonrpcServerViewCell.h"
#import "APIUtils.h"

@interface ALServersController ()<ALAddServerControllerDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *servers;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ALServersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenRightBarButtonItem = NO;
    self.title = @"服务器";
    
    _servers = [NSMutableArray new];
    [_servers addObjectsFromArray:[[LocalCacheUtils getInstance] getJsonrpcArray]];
    [self.tableView reloadData];
}

- (void)showPopMenu:(UIBarButtonItem *)sender
{
    ALAddServerController *serverController = [ALAddServerController new];
    serverController.delegate = self;
    [self.navigationController pushViewController:serverController animated:YES];
}

- (void)addServerController:(ALAddServerController *)controller successfullyAddedServer:(ALJsonrpcServer *)server
{
    [self hiddenDefaultView];
    [self.servers addObject:server];
    [[LocalCacheUtils getInstance] setJsonrpcArray:self.servers];
    [self.tableView reloadData];
    
    if (self.servers.count == 1 && [self.delegate respondsToSelector:@selector(serversController:didSelectServer:)]) {
        [self.delegate serversController:self didSelectServer:server];
    }
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

        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [_tableView registerClass:[ALJsonrpcServerViewCell class] forCellReuseIdentifier:@"JsonrpcServerCellText"];
        _tableView.backgroundColor = ymBackgroudColor;
    }
    return _tableView;
}

- (void)refreshData
{
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALJsonrpcServerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JsonrpcServerCellText" forIndexPath:indexPath];
    ALJsonrpcServer *jrs = self.servers[indexPath.row];
    [cell setJsonrpcServer:jrs];
    [APIUtils getGlobalStatus:jrs.uri rpcPasswd:jrs.secret success:^(GlobalStatus *globalStatus) {
        [cell setStat:globalStatus];
    }failure:^(NSString *msg) {
        [cell setOfflineStat];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALJsonrpcServer *jrs = self.servers[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(serversController:didSelectServer:)]) {
        [self.delegate serversController:self didSelectServer:jrs];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.servers.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        ALJsonrpcServer *jrs = self.servers[indexPath.row];
        
        [self.servers removeObjectAtIndex:indexPath.row];
        [[LocalCacheUtils getInstance] setJsonrpcArray:self.servers];
        [self.tableView reloadData];
        
        if (!self.servers.count) {
            [self showDefaultViewWithMessage:@"暂无可用服务器"];
        }
        
        if ([self.delegate respondsToSelector:@selector(serversController:didDeleteServer:)]) {
            [self.delegate serversController:self didDeleteServer:jrs];
        }
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}

@end
