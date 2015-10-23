//
//  MainViewController.h
//  Parking
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "GlobalResource.h"

@interface MainViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
        int curPage;
}

@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKPoiSearch* poisearch;
@property (nonatomic, strong) BMKLocationService* locService;
@property (nonatomic, strong) BMKPointAnnotation *annotation;

@end
