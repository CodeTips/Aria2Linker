//
//  Holmes.h
//  HolmesSDK
//
//  Created by Loveletter on 2020/3/19.
//  Copyright © 2020 Loveletter. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for HolmesSDK.
FOUNDATION_EXPORT double HolmesVersionNumber;

//! Project version string for HolmesSDK.
FOUNDATION_EXPORT const unsigned char HolmesVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HolmesSDK/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface Holmes : NSObject

/// 初始化SDK
/// @param config
/// 必要参数     @{@"appkey": @"yourkey", @"channel" : @"AppleStore"}
/// 非必要参数 @{@"exception" : @NO}
/// 只有@"exception" 为 @NO的时候不开启SDK本身异常日志收集
+ (void)init:(NSDictionary *)config;

/// 调试模式开启
/// @param debug YES 开始调试模式
+ (void)setDebug:(BOOL)debug;

/// 使用离线模式
/// @param offline YES开始离线模式
+ (void)setOffline:(BOOL)offline;

/// 是否使用测试服务器
/// @param testServer YES是使用，NO为不使用
/// @param url 测试服务器地址
+ (void)setTestServerMode:(BOOL)testServer withUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
