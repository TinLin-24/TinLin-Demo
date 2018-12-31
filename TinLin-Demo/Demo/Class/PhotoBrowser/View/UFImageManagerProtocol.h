//
//  UFImageManagerProtocol.h
//  Demo
//
//  Created by TinLin on 2018/8/11.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Block定义 && 代理方法定义 */

typedef void (^UFImageManagerProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void (^UFImageManagerCompletionBlock)(UIImage * _Nullable image, NSURL * _Nullable url, BOOL success, NSError * _Nullable error);

@protocol UFImageManager <NSObject>

- (void)setImageForImageView:(nullable UIImageView *)imageView
                     withURL:(nullable NSURL *)imageURL
                 placeholder:(nullable UIImage *)placeholder
                    progress:(nullable UFImageManagerProgressBlock)progress
                  completion:(nullable UFImageManagerCompletionBlock)completion;

- (void)cancelImageRequestForImageView:(nullable UIImageView *)imageView;

- (UIImage *_Nullable)imageFromMemoryForURL:(nullable NSURL *)url;

- (UIImage *_Nullable)imageForURL:(nullable NSURL *)url;

@end
