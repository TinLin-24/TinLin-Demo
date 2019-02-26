//
//  NSObject+RunTime.h
//  Demo
//
//  Created by Mac on 2019/2/26.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RunTime)

/**
 runtime交换方法

 @param class 需要交换方法的类
 @param originalSelector 原Selector
 @param swizzledSelector 自定义Selector
 */
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@end
