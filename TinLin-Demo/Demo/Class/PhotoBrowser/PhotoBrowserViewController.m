//
//  PhotoBrowserViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/10.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "PhotoBrowserViewController.h"

#import <TZPhotoPreviewController.h>
#import "HZPhotoBrowser.h"

#import "UFPhotoView.h"
#import "UFSDImageManager.h"
#import "UFPhotoModel.h"
#import "UFPhotoBrowserViewController.h"

@interface PhotoBrowserViewController ()

/*  */
@property (nonatomic ,strong)NSMutableArray *dataSource;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupNavigationItem];
    
    [self _setupSubViews];
}

/*  */
-(void)_setupSubViews{
    
    UFSDImageManager *manager = [[UFSDImageManager alloc] init];
    
    UFPhotoView *view = [[UFPhotoView alloc] initWithFrame:self.view.frame imageManager:manager];
    view.imageView.image = [UIImage imageNamed:@"10"];
    view.tag = 1122;
    [self.view addSubview:view];
}

#pragma mark - 设置导航栏

- (void)p_setupNavigationItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"图片浏览" style:UIBarButtonItemStyleDone target:self action:@selector(p_enterPhotoBrowser)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark -

- (void)p_enterPhotoBrowser{
//    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:self.dataSource.count];
//    for (NSString *url in self.dataSource) {
//        MWPhoto *photo =  [MWPhoto photoWithURL:[NSURL URLWithString:url]];
//        [dataSource addObject:photo];
//    }
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:dataSource];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:browser];
//    [self presentViewController:navi animated:YES completion:nil];
    
//    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
//    browser.isFullWidthForLandScape = YES;
//    browser.isNeedLandscape = YES;
//    browser.currentImageIndex = 0;
//    browser.imageArray = self.dataSource;
//    [browser show];
    
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    UFPhotoView *view = [self.view viewWithTag:1122];
    for (NSString *urlStr in self.dataSource) {
        UFPhotoModel *item = [UFPhotoModel itemWithSourceView:view.imageView
                                                     imageUrl:[NSURL URLWithString:urlStr]];
        [dataSource addObject:item];
    }
    UFPhotoBrowserViewController *browser = [UFPhotoBrowserViewController browserWithPhotoItems:dataSource selectedIndex:1];
//    browser.delegate = self;
//    browser.dismissalStyle = _dismissalStyle;
//    browser.backgroundStyle = _backgroundStyle;
//    browser.loadingStyle = _loadingStyle;
//    browser.pageindicatorStyle = _pageindicatorStyle;
    browser.bounces = YES;
    [browser showFromViewController:self];
}

#pragma mark - 懒加载

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource =[NSMutableArray array];
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"array" ofType:@"plist"];
        _dataSource = [NSMutableArray arrayWithContentsOfFile:dataPath];
    }
    return _dataSource;
}

@end
