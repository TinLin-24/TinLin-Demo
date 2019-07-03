//
//  TLImageTool.m
//  YGMY
//
//  Created by lx on 2019/5/27.
//  Copyright © 2019 TinLin. All rights reserved.
//

#import "TLImageTool.h"

#import <SDWebImage/SDImageCache.h>

@interface TLImageTool ()

@end

static TLImageTool *_tool = nil;

@implementation TLImageTool {
    dispatch_queue_t _imageToolQueue;
}

+ (instancetype)tool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[TLImageTool alloc] init];
    });
    return _tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageToolQueue = dispatch_queue_create("ios.imageTool.queue", NULL);
    }
    return self;
}

- (CGSize)fetchImageSizeWithUrlString:(NSString *)urlStr {
    __block CGSize imageSizeFin = CGSizeZero;
    BOOL isMainThread = [NSThread isMainThread];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self tl_fetchImageSizeWithUrlString:urlStr completeInMainThread:!isMainThread completion:^(CGSize imageSize) {
        imageSizeFin = imageSize;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return imageSizeFin;
}

- (void)fetchImageSizeWithUrlString:(NSString *)urlStr completion:(void (^)(CGSize))completion {
    [self tl_fetchImageSizeWithUrlString:urlStr completeInMainThread:YES completion:completion];
}

- (void)tl_fetchImageSizeWithUrlString:(NSString *)urlStr completeInMainThread:(BOOL)need completion:(void (^)(CGSize))completion {
    dispatch_async(_imageToolQueue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *img;
        CGImageSourceRef source;
        
//        if ([imageCache diskImageDataExistsWithKey:urlStr]){
//            img = [imageCache imageFromDiskCacheForKey:urlStr];
//            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
//            source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
//        } else {
//            source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
//            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
//            [imageCache storeImage:[UIImage imageWithCGImage:imageRef] forKey:urlStr completion:nil];
//            !imageRef ? : CFRelease(imageRef);
//        }
        if ([imageCache diskImageExistsWithKey:urlStr]){
            img = [imageCache imageFromDiskCacheForKey:urlStr];
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
            source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        } else {
            source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
            [imageCache storeImage:[UIImage imageWithCGImage:imageRef] forKey:urlStr toDisk:YES];
            !imageRef ? : CFRelease(imageRef);
        }
        
        NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CGFloat imageWidth = [[imageHeader objectForKey:@"PixelWidth"] floatValue];
        CGFloat imageHeight = [[imageHeader objectForKey:@"PixelHeight"] floatValue];
        CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
        !source ? : CFRelease(source);
        
        if (need) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(imageSize);
            });
        } else {
            completion(imageSize);
        }
    });
}

@end
