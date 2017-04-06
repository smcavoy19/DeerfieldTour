//
//  PVPark.m
//
//  MapRoute.h
//  DeerfieldTour
//
//  Created by smcavoy19 on 3/31/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
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
    self.pointInRoute = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [pointsArray count]; i++) {
        CGPoint point = CGPointFromString(pointsArray[i]);
        pointsInRoute[i] = CLLocationCoordinate2DMake(point.x,point.y);
        CLLocation* location = [[CLLocation alloc] initWithLatitude:point.x longitude:point.y];
        [self.pointInRoute addObject:location];
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsInRoute count:[pointsArray count]];
    return myPolyline;
}

-(float) slopeOfCoordinates:(CLLocation*) locationStart to:(CLLocation*) locationEnd{
    float deltaLat = locationStart.coordinate.latitude - locationEnd.coordinate.latitude;
    float deltaLong = locationStart.coordinate.longitude - locationEnd.coordinate.longitude;
    return deltaLong/deltaLat;
}

- (int) distanceToNextTurn:(CLLocation*) locationOfUser{
    CLLocation *currentLoc = locationOfUser;
    CLLocation* distToTurn = [self.pointInRoute objectAtIndex:1];
    float slopeOfCurr = [self slopeOfCoordinates:currentLoc to:distToTurn];
    float slopeOfRoute = [self slopeOfCoordinates:[self.pointInRoute objectAtIndex:0] to:distToTurn];
    if(abs(slopeOfCurr-slopeOfRoute) < 10){
        float curLat = [self toRadians: currentLoc.coordinate.latitude];
        float turnLat = [self toRadians: distToTurn.coordinate.latitude];
        float deltaLatitude = [self toRadians:distToTurn.coordinate.latitude - currentLoc.coordinate.latitude];
        float deltaLongitude = [self toRadians:distToTurn.coordinate.longitude - currentLoc.coordinate.longitude];
        float radius = 6371;
        float squareHalfTheCord = pow(sinf(deltaLatitude/2),2) + cosf(curLat)*cosf(turnLat) * pow(sinf(deltaLongitude/2),2);
        float angularDistance = 2 * atan2f(sqrtf(squareHalfTheCord),sqrtf(1-squareHalfTheCord));
        //remove first coordinate in point in route once equals 0;
        float distance = radius * angularDistance;
        if(distance < 1)
            [self.pointInRoute removeObjectAtIndex:0];
        return distance;
    }
    return -1;
}

-(float) toRadians:(float) loc{
    return loc * (M_PI / 180);
}

- (BOOL) turnLeft{
    float line = [self slopeOfCoordinates:[self.pointInRoute objectAtIndex:0] to:[self.pointInRoute objectAtIndex:1]];
    float lineCross = [self slopeOfCoordinates:[self.pointInRoute objectAtIndex:1] to:[self.pointInRoute objectAtIndex:2]];
    
    //find the angle between the two lines
    //based off the angle return left,right,slightleft,slightright
    //return true if next turn is a left
    return false;
}

@end
