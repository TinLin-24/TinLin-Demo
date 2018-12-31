//
//  MapViewController.m
//  Demo
//
//  Created by Mac on 2018/12/5.
//  Copyright © 2018 TinLin. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

#import "TLAnnotation.h"
#import "TLAnnotationView.h"

/**
 底部距离
 */
static CGFloat const bottomMargin = 75.f;
/**
 顶部距离
 */
static CGFloat const topMargin = 125.f;
/**
 中间位置
 */
static CGFloat const middlePosition = 225.f;


@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

//
@property (nonatomic, strong)MKMapView *mapView;

//
@property (nonatomic, strong)UIView *bgView;

//
@property (nonatomic, assign)CGFloat top;

//
@property (nonatomic, strong)CLLocationManager *locationManger;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    
    [self _setupSubViews];
    
    [self _setup];
}

- (void)_setup {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManger requestWhenInUseAuthorization];
    }
    // 每隔多少距离使用位置更新数据
    self.locationManger.distanceFilter = 50;
    // 定位的精度
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    // 代理属性
    self.locationManger.delegate = self;
    
    [self.locationManger startUpdatingLocation];
}

///
- (void)_setupSubViews {
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.bgView];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.bgView addGestureRecognizer:panRecognizer];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"camera_sticker_off"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(16.f, 20.f, 44.f, 44.f);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(_pop:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加一个长按手势, 点击后, 在这个位置加一个大头针
    // 在实际项目中, 需要去请求一个接口, 返回的数据对象中会包含每个对象的经纬度信息, 然后根据经纬度去显示一个大头针
    [self.mapView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count) {
        CLLocation *location = [locations firstObject];

        //1 设置显示区域 121.318489,31.302382  ;0.1是初始的比例（跨度）
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
        //2 通过距离来设置 地图的显示区域
        //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 10, 10);
        //添加到地图上
        [self.mapView setRegion:[self.mapView regionThatFits:region]];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(nonnull NSArray<MKAnnotationView *> *)views{
    //添加标注时调用的方法
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view{
    //标注被选中时 执行的方法
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    //标注失去焦点时执行的方法
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    //地图将要载入
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    //地图载入完成以后执行的方法
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    //地图载入失败的时候的执行的方法
    NSLog(@"error:%@",[error description]);
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //地图显示区域将要发生变化是执行的方法
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //地图显示区域 发生变化 执行的方法
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[TLAnnotation class]]) {
        return [TLAnnotationView annotationViewWithMapView:mapView annotation:annotation];
    }
    
    // 重用ID
    static NSString *annotationId = @"annotationId";

    // 从重用队列中获取
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
    if (nil == annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
    }
    // 设置属性
    annotationView.canShowCallout = YES;
        
    // 弹出详情左侧视图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 50.f, 50.f);
    imageView.image = TLImageNamed(@"nature-1");
    annotationView.leftCalloutAccessoryView = imageView;
    
    // 弹出详情右侧视图
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = btn;
    
    // leftCalloutAccessoryView rightCalloutAccessoryView
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    /// 点击大头针, 在弹出的视图左右显示视图(如果是UIControl的子类的话, 点击调用的方法要实现代理方法
    NSLog(@"%s", __func__);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    userLocation.title = @"TinLin";
//    self.mapView.centerCoordinate = userLocation.coordinate;
//    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:NO];
    // 如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    // loadData是添加大头针方法
    //[self loadData];
}

#pragma mark - Action

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    // 获取经纬度信息
    CGPoint point = [gesture locationInView:self.mapView];
    // 坐标转换为经纬度
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
//    // 添加大头针
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    // 设置经纬度
//    annotation.coordinate = coor;
//    // 标题
//    annotation.title = @"大标题";
//    // 小标题
//    annotation.subtitle = @"小标题";
    
    TLAnnotation *annotation = [[TLAnnotation alloc] initWithImage:TLImageNamed(@"home_suspension_edit")
                                                        Coordinate:coor];
    [self.mapView addAnnotation:annotation];
}

- (void)_pop:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            
            break;
        case UIGestureRecognizerStateBegan:
        {
            self.top = self.bgView.top;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [recognizer translationInView:self.view];
            CGFloat top = self.top + point.y;
            if (top >= self.view.bounds.size.height - bottomMargin || top <= topMargin) {
                return;
            }
            [UIView animateWithDuration:.1f animations:^{
                self.bgView.top = top;
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.zoomEnabled = YES;
        //_mapView.showsScale = YES;
        _mapView.delegate = self;
        /// 可以设置调用频率的
//        _mapView.distanceFilter = kCLLocationAccuracyNearestTenMeters;
//        _mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    }
    return _mapView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgView.top = self.view.bounds.size.height - bottomMargin;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = 1.f;
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
        _bgView.layer.cornerRadius = 12.f;
        _bgView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, -3.f);
        //阴影透明度，默认0
        _bgView.layer.shadowOpacity = 0.5;
    }
    return _bgView;
}

- (CLLocationManager *)locationManger {
    if (!_locationManger) {
        _locationManger = [[CLLocationManager alloc] init];
    }
    return _locationManger;
}

@end
