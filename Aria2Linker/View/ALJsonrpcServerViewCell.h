//
//  ALJsonrpcServerViewCell.h
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonrpcServer.h"
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALJsonrpcServerViewCell : UITableViewCell

@property (strong, nonatomic) JsonrpcServer *jsonrpcServer;
@property (strong, nonatomic) GlobalStatus *stat;
- (void)setOfflineStat;

@end

NS_ASSUME_NONNULL_END
