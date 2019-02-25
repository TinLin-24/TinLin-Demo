//
//  AppDelegate.m
//  Demo
//
//  Created by TinLin on 2018/5/15.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "MyOOMDataManager.h"

#import "TLHttpManager.h"

NSString *const kChunkMallocNoti = @"kChunkMallocNoti";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupWindow];
    
    //[self setupOOMDetector];
    
    return YES;
}

- (void)setupWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RTRootNavigationController *naviController = [[RTRootNavigationController alloc] initWithRootViewController:[MainViewController new]];
//    TLNavigationController *naviController = [[TLNavigationController alloc] initWithRootViewController:[MainViewController new]];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
}

- (void)setupOOMDetector{
    OOMDetector *detector = [OOMDetector getInstance];
    [detector setupWithDefaultConfig];
    
    
    /*********************下面的几项可以根据自己的实际需要选择性设置******************/
    
    // 设置捕获堆栈数据、内存log代理，在出现单次大块内存分配、检查到内存泄漏且时、调用uploadAllStack方法时会触发此回调
    [detector setFileDataDelegate:[MyOOMDataManager getInstance]];
    
    // 设置app内存触顶监控数据代理，在调用startMaxMemoryStatistic:开启内存触顶监控后会触发此回调，返回前一次app运行时单次生命周期内的最大物理内存数据
    [detector setPerformanceDataDelegate:[MyOOMDataManager getInstance]];
    
    // 单次大块内存分配监控
    [detector startSingleChunkMallocDetector:50 * 1024 * 1024 callback:^(size_t bytes, NSString *stack) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kChunkMallocNoti object:stack];
    }];
    
    // 开启内存泄漏监控，目前只可检测真机运行时的内存泄漏，模拟器暂不支持
    [detector setupLeakChecker];
    
    // 开启MallocStackMonitor用以监控通过malloc方式分配的内存
    [detector startMallocStackMonitor:10 * 1024 * 1024 needAutoDumpWhenOverflow:YES dumpLimit:300 sampleInterval:0.1];
    
    // 开启VMStackMonitor用以监控非直接通过malloc方式分配的内存
    // 因为startVMStackMonitor:方法用到了私有API __syscall_logger会带来app store审核不通过的风险，此方法默认只在DEBUG模式下生效，如果
    // 需要在RELEASE模式下也可用，请打开USE_VM_LOGGER_FORCEDLY宏，但是切记在提交appstore前将此宏关闭，否则可能会审核不通过
    [detector startVMStackMonitor:10 * 1024 * 1024];
    
    // 调用该接口上报所有缓存的OOM相关log给通过setFileDataDelegate:方法设置的代理，建议在启动的时候调用
    [detector uploadAllStack];
    
    /*************************************************************************/
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
