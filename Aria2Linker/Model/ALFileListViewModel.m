//
//  ALFileListViewModel.m
//  Aria2Linker
//
//  Created by Loveletter on 2020/7/19.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALFileListViewModel.h"
#import "ALJsonrpcServer.h"
#import "Result.h"

@interface ALFileListViewModel ()

@property (nonatomic, strong) NSMutableDictionary *tasksDictionary;
@property (nonatomic, strong) NSMutableArray *taskGids;

@end

@implementation ALFileListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileTasks = [NSMutableArray array];
        self.tasksDictionary = [NSMutableDictionary dictionary];
        self.taskGids = [NSMutableArray array];
    }
    return self;
}

- (void)requestFileTasksWithServer:(ALJsonrpcServer *)jsonrpcServer{}

- (void)logicAfterSucceedRequestFileTasks:(NSArray *)fileTasks
{
    [fileTasks enumerateObjectsUsingBlock:^(TaskInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tasksDictionary setObject:obj forKey:obj.gid];
    }];
    
    NSArray *temp = [self.fileTasks copy];
    [temp enumerateObjectsUsingBlock:^(TaskInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.tasksDictionary objectForKey:obj.gid]) {
            [self.fileTasks removeObject:obj];
            [self.taskGids removeObject:obj.gid];
        }
    }];
    
    NSArray *tasks = [self.fileTasks copy];
    [self.tasksDictionary.allValues enumerateObjectsUsingBlock:^(TaskInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.taskGids containsObject:obj.gid]) {
            [tasks enumerateObjectsUsingBlock:^(TaskInfo * task, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([task.gid isEqualToString:obj.gid]) {
                    task.completedLength = obj.completedLength;
                    task.totalLength = obj.totalLength;
                    
                    task.downloadSpeed = obj.downloadSpeed;
                    task.uploadSpeed = obj.uploadSpeed;
                    
                    task.numPieces = obj.numPieces;
                    task.pieceLength = obj.pieceLength;
                    
                    task.status = obj.status;
                }
            }];
        }
        else{
            [self.fileTasks addObject:obj];
            [self.taskGids addObject:obj.gid];
        }
    }];
    if (self.taskCount != self.taskGids.count) {
        self.taskCount = self.taskGids.count;
    }
    [self.tasksDictionary removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(requestFileTasksSuccess:withMessage:)]) {
        [self.delegate requestFileTasksSuccess:YES withMessage:@"请求成功"];
    }
}

- (void)cleanUp
{
    [self.tasksDictionary removeAllObjects];
    [self.taskGids removeAllObjects];
    [self.fileTasks removeAllObjects];
    self.taskCount = 0;
}

@end
