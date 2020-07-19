//
//  ALActiveListViewModel.m
//  Aria2Linker
//
//  Created by Loveletter on 2020/7/19.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALActiveListViewModel.h"
#import "ALJsonrpcServer.h"
#import "APIUtils.h"
@implementation ALActiveListViewModel

- (void)requestFileTasksWithServer:(ALJsonrpcServer *)jsonrpcServer
{
    [APIUtils listActiveAndStop:jsonrpcServer.uri rpcPasswd:jsonrpcServer.secret success:^(NSArray *taskInfos, NSInteger count) {
        [self logicAfterSucceedRequestFileTasks:taskInfos];
    }failure:^(NSString *msg) {
        if ([self.delegate respondsToSelector:@selector(requestFileTasksSuccess:withMessage:)]) {
            [self.delegate requestFileTasksSuccess:NO withMessage:msg];
        }
    }];
}

@end
