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
#import "Coordinate.h"
#import "PQ.h"
#import "Graph.h"
#import <limits.h>

@interface MapRoute : NSObject

@property (strong, nonatomic) Graph *graph;
@property (retain, nonatomic) id delegate;
- (instancetype)initWithFilename:(NSString *)filename;
- (MKPolyline*)addRoute:(CLLocation*) start toFinish:(CLLocation*) finish;
- (float) distanceFrom:(CLLocation*) locationOfUser to:(CLLocation*) next;
-(MKPolyline *) routeStart:(NSString*) start toFinish:(NSString*) finish;

@end
