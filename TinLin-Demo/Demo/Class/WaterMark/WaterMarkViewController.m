//
//  WaterMarkViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "WaterMarkViewController.h"
#import "ImageIOViewController.h"
#import <TZImagePickerController.h>

#import "WaterMarkLayer.h"
#import "WatermarkTool.h"

@interface WaterMarkViewController ()<TZImagePickerControllerDelegate>

/*  */
@property (nonatomic ,strong)UIBarButtonItem *addWaterMarkItem;

/*  */
@property (nonatomic ,strong)UIBarButtonItem *selectPhotoItem;

/*  */
@property (nonatomic ,strong)UIImageView *imageView;

/*  */
@property (nonatomic ,strong)NSMutableArray *originalImageArray;

@end

@implementation WaterMarkViewController
{
    /// 串行加水印的队列
    dispatch_queue_t _watermarkQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _watermarkQueue = dispatch_queue_create("ios.watermark.queue", NULL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultImage];
}

#pragma mark -

-(void)defaultImage{
    
    self.navigationItem.rightBarButtonItems = @[self.addWaterMarkItem,self.selectPhotoItem];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_logo"]];
    imageView.frame = self.view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

#pragma mark - Action

-(void)selectBtnClick:(UIBarButtonItem *)sender{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:50 delegate:self];
    imagePickerVc.allowPreview = NO;
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        self.originalImageArray = [NSMutableArray arrayWithArray:assets];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)addBtnClick:(UIBarButtonItem *)sender{
    
    if (self.originalImageArray.count == 0) {
        NSLog(@"没有图片");
        return;
    }
    
    self.navigationItem.rightBarButtonItems = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(_watermarkQueue, ^{
//        [self _adjunctionWatermark];
        [self _drawWaterMark];
    });
    
}

#pragma mark - 绘制加水印

-(void)_drawWaterMark{
    /* 保存添加水印后的图片 */
    __block NSMutableArray *sourceImages = [NSMutableArray array];
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"开始绘制加水印");
    
    for (PHAsset *asset in self.originalImageArray) {
        
        dispatch_group_enter(group);
        
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            UIImage *image = [UIImage imageWithData:data];
            UIImage *waterMarkImage = [[WatermarkTool watermarkInstance] getWaterMarkImage:image];
            [sourceImages addObject:waterMarkImage];
            NSLog(@"加完一张");
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
        }];
        
        /* 等待 */
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"结束");
        [self.originalImageArray removeAllObjects];
        self.navigationItem.rightBarButtonItems = @[self.addWaterMarkItem,self.selectPhotoItem];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ImageIOViewController *viewController = [[ImageIOViewController alloc] init];
        viewController.title = @"加完水印预览";
        viewController.images = [NSArray arrayWithArray:sourceImages];
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

#pragma mark - GPUImage加水印

-(void)_adjunctionWatermark{
    /* 保存添加水印后的图片 */
    __block NSMutableArray *sourceImages = [NSMutableArray array];
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"开始GPUImage加水印");
    
    for (PHAsset *asset in self.originalImageArray) {
        
        dispatch_group_enter(group);
        
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            UIImage *image = [UIImage imageWithData:data];
            [[WatermarkTool watermarkInstance] getWaterMarkImage:image Complete:^(UIImage *resultImage) {
                [sourceImages addObject:UIImageJPEGRepresentation(resultImage, .8f)];
                NSLog(@"加完一张");
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
            }];
        }];
        
        /* 等待 */
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"结束");
        [self.originalImageArray removeAllObjects];
        self.navigationItem.rightBarButtonItems = @[self.addWaterMarkItem,self.selectPhotoItem];
        [self showImages:sourceImages];
    });
}

-(void)showImages:(NSMutableArray *)imagesData{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imagesData.count];
    for (NSData *imageData in imagesData) {
        UIImage *image = [UIImage imageWithData:imageData];
        [images addObject:image];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    ImageIOViewController *viewController = [[ImageIOViewController alloc] init];
    viewController.title = @"加完水印预览";
    viewController.images = [NSArray arrayWithArray:images];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 懒加载

-(UIBarButtonItem *)addWaterMarkItem{
    if (!_addWaterMarkItem) {
        _addWaterMarkItem = [[UIBarButtonItem alloc] initWithTitle:@"加水印" style:UIBarButtonItemStyleDone target:self action:@selector(addBtnClick:)];
    }
    return _addWaterMarkItem;
}

-(UIBarButtonItem *)selectPhotoItem{
    if (!_selectPhotoItem) {
        _selectPhotoItem = [[UIBarButtonItem alloc] initWithTitle:@"选图" style:UIBarButtonItemStyleDone target:self action:@selector(selectBtnClick:)];
    }
    return _selectPhotoItem;
}

@end
