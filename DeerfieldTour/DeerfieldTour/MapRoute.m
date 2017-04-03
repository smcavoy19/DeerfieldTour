//
//  PVPark.m
//  Park View
//
//  Created by Cesare Rocchi on 6/19/14.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

#import "MapRoute.h"


@implementation MapRoute

- (MKPolyline*)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"route_points" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
 
    CLLocationCoordinate2D pointsInRoute[[pointsArray count]];
    
    for(int i = 0; i < [pointsArray count]; i++) {
        CGPoint point = CGPointFromString(pointsArray[i]);
        pointsInRoute[i] = CLLocationCoordinate2DMake(point.x,point.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsInRoute count:[pointsArray count]];
    return myPolyline;
}

@end
