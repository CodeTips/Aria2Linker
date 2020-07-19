//
//  ALFileListViewModel.h
//  Aria2Linker
//
//  Created by Loveletter on 2020/7/19.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALJsonrpcServer;

@protocol ALFileListViewModelDelegate <NSObject>
@optional;
- (void)requestFileTasksSuccess:(BOOL)success withMessage:(NSString *)message;
@end

@interface ALFileListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *fileTasks;
@property (nonatomic, assign) NSInteger taskCount;
@property (nonatomic, weak) id <ALFileListViewModelDelegate> delegate;

- (void)requestFileTasksWithServer:(ALJsonrpcServer *)jsonrpcServer;
- (void)logicAfterSucceedRequestFileTasks:(NSArray *)fileTasks;
- (void)cleanUp;

@end

NS_ASSUME_NONNULL_END
