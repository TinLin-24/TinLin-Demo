//
//  MainCellModel.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "MainCellModel.h"

@implementation MainCellModel

- (instancetype)initWithName:(NSString *)name andViewControllerClass:(Class)viewControllerClass
{
    self = [super init];
    if (self) {
        self.name = name;
        self.viewControllerClass = viewControllerClass;
    }
    return self;
}

@end
