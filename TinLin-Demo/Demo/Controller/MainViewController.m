//
//  MainViewController.m
//  Demo
//
//  Created by TinLin on 2018/8/2.
//  Copyright © 2018年 TinLin. All rights reserved.
//

#import "MainViewController.h"
#import "CAAnimationViewController.h"
#import "WaterMarkViewController.h"
#import "RichTextViewController.h"
#import "ImageIOViewController.h"
#import "PropertyAnimatorViewController.h"
#import "StackViewController.h"
#import "CroppedFilletViewController.h"
#import "EditImageViewController.h"
#import "PhotoBrowserViewController.h"
#import "MapViewController.h"
#import "WaveViewController.h"
#import "LayerViewController.h"
#import "SwipeActionViewController.h"
#import "HeaderViewController.h"
#import "SystemCameraViewController.h"
#import "TLAVCaptureViewController.h"

#import "MainCellModel.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

/*  */
@property (nonatomic ,strong)UITableView *tableView;
/*  */
@property (nonatomic ,strong)NSMutableArray *dataSource;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
    
    [self _setup];
    [self _setupSubViews];
}

#pragma mark - 初始化

- (void)_setup{
    NSArray *nameArray = @[@"CAAnimation",
                           @"加水印",
                           @"UILabel显示HTML富文本",
                           @"ImageIO获取网络图片的宽高",
                           @"UIViewPropertyAnimator",
                           @"UIStackView",
                           @"圆角裁剪",
                           @"图片编辑",
                           @"图片浏览",
                           @"TableView",
                           @"地图",
                           @"波浪",
                           @"Layer",
                           @"HeaderView",
                           @"SystemCamera",
                           @"相机"];
    NSArray *classArray = @[[CAAnimationViewController class],
                            [WaterMarkViewController class],
                            [RichTextViewController class],
                            [ImageIOViewController class],
                            [PropertyAnimatorViewController class],
                            [StackViewController class],
                            [CroppedFilletViewController class],
                            [EditImageViewController class],
                            [PhotoBrowserViewController class],
                            [SwipeActionViewController class],
                            [MapViewController class],
                            [WaveViewController class],
                            [LayerViewController class],
                            [HeaderViewController class],
                            [SystemCameraViewController class],
                            [TLAVCaptureViewController class]];

    [nameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = classArray[idx];
        MainCellModel *model = [[MainCellModel alloc] initWithName:name andViewControllerClass:class];
        [self.dataSource addObject:model];
    }];
}

#pragma mark - 设置子控件

- (void)_setupSubViews{
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"BaseTableViewCell";
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView reuseIdentifier:reuseIdentifier];
    
    MainCellModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainCellModel *model = self.dataSource[indexPath.row];
    Class class = model.viewControllerClass;
    if (![class isSubclassOfClass:[UIViewController class]]) {
        class = [UIViewController class];
    }
    UIViewController *viewController = [[class alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource =[NSMutableArray array];
    }
    return _dataSource;
}

@end
