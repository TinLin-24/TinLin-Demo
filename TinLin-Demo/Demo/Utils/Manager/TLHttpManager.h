//
//  TLHttpManager.h
//  Demo
//
//  Created by Mac on 2019/2/25.
//  Copyright © 2019 TinLin. All rights reserved.
//

/*
AFNetworking主要是对NSURLSession和NSURLConnection(iOS9.0废弃)的封装,其中主要有以下类:
1). AFHTTPRequestOperationManager：内部封装的是 NSURLConnection, 负责发送网络请求, 使用最多的一个类。(3.0废弃)
2). AFHTTPSessionManager：内部封装是 NSURLSession, 负责发送网络请求,使用最多的一个类。
3). AFNetworkReachabilityManager：实时监测网络状态的工具类。当前的网络环境发生改变之后,这个工具类就可以检测到。
4). AFSecurityPolicy：网络安全的工具类, 主要是针对 HTTPS 服务。
5). AFURLRequestSerialization：序列化工具类,基类。上传的数据转换成JSON格式
(AFJSONRequestSerializer).使用不多。
6). AFURLResponseSerialization：反序列化工具类;基类.使用比较多:
7). AFJSONResponseSerializer; JSON解析器,默认的解析器.
8). AFHTTPResponseSerializer; 万能解析器; JSON和XML之外的数据类型,直接返回二进
制数据.对服务器返回的数据不做任何处理.
9). AFXMLParserResponseSerializer; XML解析器;
*/

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLHttpManager : NSObject

+ (instancetype)manager;

#pragma mark GET请求

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


#pragma mark POST请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark 数据上传

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
