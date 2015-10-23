//
//  GlobalResource.h
//  Movie
//
//  Created by Apple on 10/15/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
@interface GlobalResource : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, assign) BOOL colorPin;
@end
