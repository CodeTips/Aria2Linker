//
//  ALAddServerController.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ALAddServerController;
@class ALJsonrpcServer;

@protocol ALAddServerControllerDelegate <NSObject>

- (void)addServerController:(ALAddServerController *)controller successfullyAddedServer:(ALJsonrpcServer *)server;

@end

@interface ALAddServerController : BaseViewController

@property (nonatomic, weak)id<ALAddServerControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
