//
//  APIUtils.h
//  regDevices
//
//  Created by zj15 on 2018/3/28.
//  Copyright © 2018年 zj15. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "Result.h"

@interface APIUtils : NSObject

/**
 同时获取正在下载/已暂停的任务
 */
+ (void)listActiveAndStop:(NSString *)rpcUri
                  rpcPasswd:(NSString *)passwd
                  success:(void (^)(NSArray *taskInfos, NSInteger count))success
                  failure:(void (^)(NSString *msg))failure;

/**
 获取单个状态
 */
+ (void)statusByGid:(NSString *)gid
            rpcUri:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
            success:(void (^)(TaskInfo *taskInfo))success
            failure:(void (^)(NSString *msg))failure;

/**
 恢复暂停

 */
+ (void)unpauseByGid:(NSString *)gid
             rpcUri:(NSString *)rpcUri
             rpcPasswd:(NSString *)passwd
             success:(void (^)(NSString *okmsg))success
             failure:(void (^)(NSString *msg))failure;

/**
 暂停
 */
+ (void)pauseByGid:(NSString *)gid
            rpcUri:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
           success:(void (^)(NSString *okmsg))success
           failure:(void (^)(NSString *msg))failure;

/**
 删除

 */
+ (void)removeByGid:(NSString *)gid
             rpcUri:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
            success:(void (^)(NSString *okmsg))success
            failure:(void (^)(NSString *msg))failure;

/**
 删除完成的任务记录

 */
+ (void)removeResultByGid:(NSString *)gid
                   rpcUri:(NSString *)rpcUri
                  rpcPasswd:(NSString *)passwd
                  success:(void (^)(NSString *okmsg))success
                  failure:(void (^)(NSString *msg))failure;

/**
 新增uri下载

 */
+ (void)addUri:(NSString *)uri
        rpcUri:(NSString *)rpcUri
        rpcPasswd:(NSString *)passwd
       success:(void (^)(NSString *gid))success
       failure:(void (^)(NSString *msg))failure;

/**
 获取正在下载列表

 */
+ (void)listActive:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
           success:(void (^)(NSArray *taskInfos, NSInteger count))success
           failure:(void (^)(NSString *msg))failure;

/**
 获取暂停下载列表

 */
+ (void)listWait:(NSString *)rpcUri
        rpcPasswd:(NSString *)passwd
         success:(void (^)(NSArray *taskInfos, NSInteger count))success
         failure:(void (^)(NSString *msg))failure;

/**
 获取已结束列表

 */
+ (void)listStopped:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
            success:(void (^)(NSArray *taskInfos, NSInteger count))success
            failure:(void (^)(NSString *msg))failure;

/**
 获取全局配置

 */
+ (void)getGlobalOption:(NSString *)rpcUri
                rpcPasswd:(NSString *)passwd
                success:(void (^)(Setting *setting))success
                failure:(void (^)(NSString *msg))failure;

/**
 获取版本信息

 */
+ (void)getVersion:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
           success:(void (^)(Version *version))success
           failure:(void (^)(NSString *msg))failure;

/**
 获取全局状态

 */
+ (void)getGlobalStatus:(NSString *)rpcUri
              rpcPasswd:(NSString *)passwd
                success:(void (^)(GlobalStatus *globalStatus))success
                failure:(void (^)(NSString *msg))failure;
@end
