//
//  MainCellModel.h
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCellModel : NSObject

/*  */
@property (nonatomic ,assign)Class viewControllerClass;
/*  */
@property (nonatomic ,strong)NSString *name;

- (instancetype)initWithName:(NSString *)name andViewControllerClass:(Class)viewControllerClass;

@end
