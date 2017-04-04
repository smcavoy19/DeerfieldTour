//
//  MapRoute.h
//  DeerfieldTour
//
//  Created by smcavoy19 on 3/31/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapRoute : NSObject
@property CLLocationCoordinate2D* pointInRoute;
- (instancetype)initWithFilename:(NSString *)filename;
- (MKPolyline*)addRoute;
- (int) distanceToNextTurn;
- (BOOL) turnLeft;
//distance from path
//route to path
//on path
//speed currentLocation.speed
@end
