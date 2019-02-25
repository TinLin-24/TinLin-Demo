//
//  TLHttpManager.m
//  Demo
//
//  Created by Mac on 2019/2/25.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLHttpManager.h"

@interface TLHttpManager ()

@property(nonatomic, strong) AFHTTPSessionManager *manager;

@property(nonatomic, strong) NSSet <NSString *> *acceptableContentTypes;

@end

@implementation TLHttpManager

static TLHttpManager *_manager = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TLHttpManager alloc] init];
    });
    return _manager;
}


#pragma mark GET请求

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    AFHTTPSessionManager * mananger=[self manager];
    mananger.responseSerializer.acceptableContentTypes = self.acceptableContentTypes?self.acceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];

    return [mananger GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark POST请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager * mananger=[self manager];
    // 2.加上这个函数，https ssl 验证。
    // [mananger setSecurityPolicy:[self customSecurityPolicy]];
    mananger.responseSerializer.acceptableContentTypes = self.acceptableContentTypes?self.acceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    // AFJSONRequestSerializer 是jSON数据
    // AFHTTPRequestSerializer 是表单
    mananger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    return [mananger POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

#pragma mark 数据上传

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager * mananger=[self manager];
    mananger.responseSerializer.acceptableContentTypes = self.acceptableContentTypes?self.acceptableContentTypes:[NSSet setWithObject:@"text/html"];
    return [mananger POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}


- (AFSecurityPolicy *)customSecurityPolicy {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mycer" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    return securityPolicy;
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        // 请求超时的时间
        _manager.requestSerializer.timeoutInterval = 30;
    }
    return _manager;
}

- (NSSet <NSString *> *) acceptableContentTypes {
    if (_acceptableContentTypes == nil) {
        _acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    }
    return _acceptableContentTypes;
}

@end
