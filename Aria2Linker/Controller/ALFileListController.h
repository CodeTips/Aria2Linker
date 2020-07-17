//
//  ALFileListController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class JsonrpcServer;

@interface ALFileListController : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic, nullable) NSArray *fileList;
@property (strong, nonatomic, nullable) JsonrpcServer *jsonrpcServer;

- (void)stopTimer;
- (void)startTimer;

@end

NS_ASSUME_NONNULL_END
