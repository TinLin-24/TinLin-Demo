//
//  TestImageModel.h
//  Demo
//
//  Created by TinLin on 2018/7/5.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestImageModel : NSObject

/*  */
@property (nonatomic ,strong)NSString *url;
/*  */
@property (nonatomic,assign)NSInteger width;
/*  */
@property (nonatomic,assign)NSInteger height;
/*  */
@property (nonatomic ,strong)UIImage *image;

@end
