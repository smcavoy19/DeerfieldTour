//
//  PVPark.m
//  Park View
//
//  Created by Cesare Rocchi on 6/19/14.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

#import "MapRoute.h"


@implementation MapRoute

-(instancetype)initWithFilename:(NSString *)filename{
    
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (MKPolyline*)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"route_points" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
 
    CLLocationCoordinate2D pointsInRoute[[pointsArray count]];
    
    for(int i = 0; i < [pointsArray count]; i++) {
        CGPoint point = CGPointFromString(pointsArray[i]);
        pointsInRoute[i] = CLLocationCoordinate2DMake(point.x,point.y);
    }
    
    self.pointInRoute = pointsInRoute;
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsInRoute count:[pointsArray count]];
    return myPolyline;
}

- (int) distanceToNextTurn:(CLLocation*) locationOfUser{
    CLLocation *currentLoc = locationOfUser;
    CLLocation *distToTurn = (CLLocation*)self.pointInRoute;
    float curLat = [self toRadians: currentLoc.coordinate.latitude];
    float turnLat = [self toRadians: distToTurn.coordinate.latitude];
    float deltaLatitude = [self toRadians:distToTurn.coordinate.latitude - currentLoc.coordinate.latitude ];
    float deltaLongitude = [self toRadians:distToTurn.coordinate.longitude - currentLoc.coordinate.longitude];
    float radius = 6371;
    float x = pow(sinf(deltaLatitude/2),2) + cosf(curLat)*cosf(turnLat) + pow(sinf(deltaLongitude/2),2);
    float y = 2 * atan2f(sqrtf(x),sqrtf(1-x));
    //remove first coordinate in point in route once equals 0;
    return radius * y;
}

-(float) toRadians:(float) loc{
    return loc * (M_PI / 180);
}
- (BOOL) turnLeft{
    //find the angle between the two lines
    //based off the angle return left,right,slightleft,slightright
    //return true if next turn is a left
    return false;
}

@end
