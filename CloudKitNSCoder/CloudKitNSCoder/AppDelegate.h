//
//  AppDelegate.h
//  CloudKitNSCoder
//
//  Created by Juan Martín Noguera on 1/9/14.
//  Copyright (c) 2014 Juan Martín Noguera. All rights reserved.
//

@import CoreLocation;
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

