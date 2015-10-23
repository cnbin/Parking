//
//  ViewController.h
//  Parking
//
//  Created by Apple on 10/23/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface ViewController : UIViewController<BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKLocationService* locService;

@end

