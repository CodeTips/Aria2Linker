//
//  FLStopListController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/17.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "BaseViewController.h"
#import "JsonrpcServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALStopListController : BaseViewController

@property (strong, nonatomic) JsonrpcServer *jsonrpcServer;

@end

NS_ASSUME_NONNULL_END