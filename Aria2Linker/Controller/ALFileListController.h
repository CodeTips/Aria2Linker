//
//  ALFileListController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ALJsonrpcServer;
@class ALFileListViewModel;

@interface ALFileListController : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ALFileListViewModel *viewModel;
@property (strong, nonatomic, nullable) ALJsonrpcServer *jsonrpcServer;

- (void)stopTimer;
- (void)startTimer;
- (void)refreshData;
- (void)addObservers;
- (void)removeObservers;

@end

NS_ASSUME_NONNULL_END
