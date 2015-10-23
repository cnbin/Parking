//
//  MainViewController.m
//  Parking
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 cnbin. All rights reserved.
//
//最新版本
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GlobalResource sharedInstance].colorPin = NO;
    NSLog(@"lat is %f",[GlobalResource sharedInstance].userLocation.location.coordinate.latitude);
    NSLog(@"long is %f",[GlobalResource sharedInstance].userLocation.location.coordinate.longitude);

    
    _locService = [[BMKLocationService alloc]init];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;

    _poisearch = [[BMKPoiSearch alloc]init];

    // 设置地图级别
   [_mapView setZoomLevel:20];
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.centerCoordinate = [GlobalResource sharedInstance].userLocation.location.coordinate;
    
//
//    [NSTimer scheduledTimerWithTimeInterval:5
//                                         target:self
//                                       selector:@selector(updateDataMethod:)
//                                       userInfo:nil
//                                        repeats:NO];
//    
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapView.showsUserLocation = YES;//显示定位图层
//
    
    
    float zoomLevel = 0.01;
    BMKCoordinateRegion region = BMKCoordinateRegionMake([GlobalResource sharedInstance].userLocation.location.coordinate,BMKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];

    // 在地图中添加一个PointAnnotation
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.title = @"用户所在位置";
    _annotation.subtitle = @"斌彬哥";
    _annotation.coordinate = [GlobalResource sharedInstance].userLocation.location.coordinate;
    [_mapView addAnnotation:_annotation];
    
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = curPage;
    option.pageCapacity = 10;
    option.location = [GlobalResource sharedInstance].userLocation.location.coordinate;
    option.keyword = @"停车场";
    BOOL flag = [_poisearch poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}

-(void)updateDataMethod:(NSTimer*)timer {
    
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    option.pageIndex = curPage;
//    option.pageCapacity = 10;
//   // option.location = CLLocationCoordinate2D{39.915, 116.404};
//    
//    option.keyword = @"停车场";
//    BOOL flag = [_poisearch poiSearchNearBy:option];
//
//    if(flag)
//    {
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        NSLog(@"周边检索发送失败");
//    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
//    _locService.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
//    _locService.delegate = nil;
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
    
//    [_locService stopUserLocationService];
//    _mapView.showsUserLocation = NO;
}

- (void)dealloc {
    
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        if ([GlobalResource sharedInstance].colorPin) {
            
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorGreen;

        }else {
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        }
        
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    // 清楚屏幕中所有的 poi annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    NSMutableArray *myMutableArray = [array mutableCopy];
    [myMutableArray removeObjectAtIndex:0];
    NSArray *myArray = [myMutableArray copy];
    [_mapView removeAnnotations:myArray];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [GlobalResource sharedInstance].colorPin = YES;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
       
    }
}


@end
