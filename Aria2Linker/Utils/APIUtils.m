

//
//  APIUtils.m
//  regDevices
//
//  Created by zj15 on 2018/3/28.
//  Copyright © 2018年 zj15. All rights reserved.
//

#import "APIUtils.h"
#import "NetUtils.h"

@implementation APIUtils
+ (void)listActiveAndStop:(NSString *)rpcUri
                    rpcPasswd:(NSString *)passwd
                  success:(void (^)(NSArray *taskInfos, NSInteger count))success
                  failure:(void (^)(NSString *msg))failure {
    
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];

    NSMutableDictionary *ad = [self createDict];
    [ad setObject:@"aria2.tellActive" forKey:@"methodName"];
    [ad setObject:@[rpcPasswd,
     @[@"gid", @"totalLength", @"completedLength", @"downloadSpeed", @"files", @"status"]]
           forKey:@"params"];
    
    NSMutableDictionary *sd = [self createDict];
    [sd setObject:@"aria2.tellWaiting" forKey:@"methodName"];
    [sd setObject:@[rpcPasswd,
                    @(0),
                    @(1000),
     @[ @"gid", @"totalLength", @"completedLength", @"downloadSpeed", @"files", @"status" ]]
           forKey:@"params"];

    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"system.multicall" forKey:@"method"];
    [dict setObject:@[@[ [sd yy_modelToJSONObject] ,[ad yy_modelToJSONObject]]] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            NSArray *a = (NSArray *) json;
            NSMutableArray *arr = [NSMutableArray new];
            for (NSArray *str in a) {
                NSArray *ar = [NSArray yy_modelArrayWithClass:[TaskInfo class] json:str[0]];
                [arr addObjectsFromArray:ar];
            }
            success(arr, [arr count]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)func:(NSString *)func
         gid:(NSString *)gid
      rpcUri:(NSString *)rpcUri
    rpcPasswd:(NSString *)passwd
     success:(void (^)(NSString *okmsg))success
     failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:[NSString stringWithFormat:@"aria2.%@", func] forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd, gid] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success(json);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)statusByGid:(NSString *)gid
             rpcUri:(NSString *)rpcUri
          rpcPasswd:(NSString *)passwd
            success:(void (^)(TaskInfo *taskInfo))success
            failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.tellStatus" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd , gid] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success([TaskInfo yy_modelWithJSON:json]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)unpauseByGid:(NSString *)gid
              rpcUri:(NSString *)rpcUri
                rpcPasswd:(NSString *)passwd
             success:(void (^)(NSString *okmsg))success
             failure:(void (^)(NSString *msg))failure {
    [APIUtils func:@"unpause" gid:gid rpcUri:rpcUri rpcPasswd:passwd success:success failure:failure];
}

+ (void)pauseByGid:(NSString *)gid
            rpcUri:(NSString *)rpcUri
         rpcPasswd:(NSString *)passwd
           success:(void (^)(NSString *okmsg))success
           failure:(void (^)(NSString *msg))failure {
    [APIUtils func:@"pause" gid:gid rpcUri:rpcUri rpcPasswd:passwd success:success failure:failure];
}

+ (void)removeByGid:(NSString *)gid
             rpcUri:(NSString *)rpcUri
          rpcPasswd:(NSString *)passwd
            success:(void (^)(NSString *okmsg))success
            failure:(void (^)(NSString *msg))failure {
    [APIUtils func:@"remove" gid:gid rpcUri:rpcUri rpcPasswd:passwd success:success failure:failure];
}

+ (void)removeResultByGid:(NSString *)gid
                   rpcUri:(NSString *)rpcUri
                    rpcPasswd:(NSString *)passwd
                  success:(void (^)(NSString *okmsg))success
                  failure:(void (^)(NSString *msg))failure {
    [APIUtils func:@"removeDownloadResult" gid:gid rpcUri:rpcUri rpcPasswd:passwd success:success failure:failure];
}

+ (void)addUri:(NSString *)uri
        rpcUri:rpcUri
        rpcPasswd:(NSString *)passwd
       success:(void (^)(NSString *gid))success
       failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.addUri" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd, @[ uri ] ] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success(json);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)listActive:(NSString *)rpcUri
         rpcPasswd:(NSString *)passwd
           success:(void (^)(NSArray *activite, NSInteger count))success
           failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.tellActive" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd, @[
              @"gid", @"totalLength", @"completedLength", @"uploadSpeed", @"downloadSpeed", @"connections",
              @"numSeeders", @"files", @"status"
          ]]
             forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[TaskInfo class] json:json];
            success(arr, [arr count]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)listWait:(NSString *)rpcUri
        rpcPasswd:(NSString *)passwd
         success:(void (^)(NSArray *activite, NSInteger count))success
         failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.tellWaiting" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];

    [dict setObject:@[
        rpcPasswd,
        @(0), @(1000),
        @[
           @"gid", @"totalLength", @"completedLength", @"uploadSpeed", @"downloadSpeed", @"connections", @"numSeeders",
           @"files", @"status"
        ]

    ]
             forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[TaskInfo class] json:json];
            success(arr, [arr count]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)listStopped:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
            success:(void (^)(NSArray *activite, NSInteger count))success
            failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.tellStopped" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[
        rpcPasswd,
        @(-1),
        @(1000),
        @[
           @"gid", @"totalLength", @"completedLength", @"uploadSpeed", @"downloadSpeed", @"connections", @"numSeeders",
           @"files", @"status"
        ]
    ]
             forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[TaskInfo class] json:json];
            success(arr, [arr count]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)getGlobalOption:(NSString *)rpcUri
                rpcPasswd:(NSString *)passwd
                success:(void (^)(Setting *setting))success
                failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.getGlobalOption" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success([Setting yy_modelWithJSON:json]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)getVersion:(NSString *)rpcUri
            rpcPasswd:(NSString *)passwd
           success:(void (^)(Version *version))success
           failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.getVersion" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success([Version yy_modelWithJSON:json]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (void)getGlobalStatus:(NSString *)rpcUri
                rpcPasswd:(NSString *)passwd
                success:(void (^)(GlobalStatus *globalStatus))success
                failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dict = [self createDict];
    [dict setObject:@"aria2.getGlobalStat" forKey:@"method"];
    NSString *rpcPasswd = [NSString stringWithFormat:@"token:%@",passwd];
    [dict setObject:@[rpcPasswd] forKey:@"params"];
    [NetUtils doPost:rpcUri
        withParameters:dict
        success:^(NSString *json, NSInteger _) {
            success([GlobalStatus yy_modelWithJSON:json]);
        }
        failure:^(NSString *msg) {
            YMFAILURE(failure, msg);
        }];
}

+ (NSMutableDictionary *)createDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"2.0" forKey:@"jsonrpc"];
    NSString *str = [NSString stringWithFormat:@"Aria2Linker_%d_%f",(int)[[NSDate date] timeIntervalSince1970],((double)arc4random() / 0x100000000) * 3.0f];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *stringBase64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [dict setObject:stringBase64 forKey:@"id"];
    return dict;
}
@end
