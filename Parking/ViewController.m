//
//  ViewController.m
//  Parking
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "ViewController.h"
#import "GlobalResource.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _locService = [[BMKLocationService alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_locService startUserLocationService];
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _locService.delegate = nil;
    [_locService stopUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation != nil) {
        
        NSLog(@"not nil");
        
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        
//        //大头针摆放的坐标，必须从这里进行赋值，否则取不到值
//        CLLocationCoordinate2D coor;
//        coor.latitude = userLocation.location.coordinate.latitude;
//        coor.longitude = userLocation.location.coordinate.longitude;
        
        [GlobalResource sharedInstance].userLocation = userLocation;
        
    }
    
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
