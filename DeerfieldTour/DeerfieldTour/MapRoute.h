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

@interface MapRoute : NSObject
@property NSMutableDictionary* graph;

-(void) createGraph;
- (instancetype)initWithFilename:(NSString *)filename;
- (MKPolyline*)addRoute:(CLLocation*) start toFinish:(CLLocation*) finish;
- (int) distanceFrom:(CLLocation*) locationOfUser to:(CLLocation*) next;


@end
