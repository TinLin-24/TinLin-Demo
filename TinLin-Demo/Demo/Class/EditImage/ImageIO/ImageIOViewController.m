//
//  ImageIOViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "ImageIOViewController.h"

#import "TestImageModel.h"

#import "ImageTableViewCell.h"

#import <SDWebImageManager.h>

@interface ImageIOViewController ()<UITableViewDataSource,UITableViewDelegate>

/*  */
@property (nonatomic ,strong)UITableView *tableView;
/*  */
@property (nonatomic ,strong)NSMutableArray *dataSource;
/*  */
@property (nonatomic ,strong)NSMutableArray *imageDataSource;

@end

@implementation ImageIOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

    if (self.images && self.images.count>0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self showImage];
        });
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self imageHeight];
        });
    }
}

#pragma mark -

/* 预览图片 */

-(void)showImage{
    self.imageDataSource = [NSMutableArray array];
    for (UIImage *image in self.images) {
        TestImageModel *model = [[TestImageModel alloc] init];
        model.image = image;
        model.width = image.size.width;
        model.height = image.size.height;
        [self.imageDataSource addObject:model];
    }
}

#pragma mark - 计算图片高度

-(void)imageHeight{
    
    __block NSInteger Cachecount=0;
    __block NSInteger count=0;
    
    NSLog(@"start");
    
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group=dispatch_group_create();
    
    for (TestImageModel *model in self.dataSource) {
        NSLog(@"开始");
        
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSURL *url = [NSURL URLWithString:model.url];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            UIImage *img;
            CGImageSourceRef source;
            
            if ([manager diskImageExistsForURL:url]){
                Cachecount++;
                img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
                source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
            }
            else {
                count++;
                source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
                CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
                [manager saveImageToCache:[UIImage imageWithCGImage:imageRef] forURL:url];
                !imageRef ? : CFRelease(imageRef);
            }
            
            NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
            model.width=[[imageHeader objectForKey:@"PixelWidth"] integerValue];
            model.height=[[imageHeader objectForKey:@"PixelHeight"] integerValue];
            !source ? : CFRelease(source);
            
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"计算一张结束");
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
        });
        NSLog(@"Cachecount:%zd",Cachecount);
        NSLog(@"count:%zd",count);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"end");
    });
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageDataSource ? self.imageDataSource.count : self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestImageModel *imageModel = self.imageDataSource ? self.imageDataSource[indexPath.row] : self.dataSource[indexPath.row];
    static NSString *reuseIdentifier=@"ImageTableViewCell";
    BaseTableViewCell *cell = [ImageTableViewCell cellWithTableView:tableView reuseIdentifier:reuseIdentifier];
    [cell configModel:imageModel];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
    TestImageModel *imageModel = self.imageDataSource ? self.imageDataSource[indexPath.row] : self.dataSource[indexPath.row];
    if (imageModel.width>0 && imageModel.height>0) {
        return screenWidth*imageModel.height/imageModel.width;
    } else {
        return 500;
    }
}

#pragma mark - 懒加载

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource =[NSMutableArray array];
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"array" ofType:@"plist"];
        NSMutableArray *array=[NSMutableArray arrayWithContentsOfFile:dataPath];
        for (NSString *url in array) {
            if (_dataSource.count==50) {
                break;
            }
            TestImageModel *model=[TestImageModel new];
            model.url=url;
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

@end
