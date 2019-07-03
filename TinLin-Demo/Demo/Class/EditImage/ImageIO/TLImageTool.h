//
//  TLImageTool.h
//  YGMY
//
//  Created by lx on 2019/5/27.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLImageTool : NSObject

+ (instancetype)tool;

- (CGSize)fetchImageSizeWithUrlString:(NSString *)urlStr;

- (void)fetchImageSizeWithUrlString:(NSString *)urlStr completion:(void (^ __nullable)(CGSize imageSize))completion;

@end

NS_ASSUME_NONNULL_END
