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

-(void) createGraph{
    NSString* thePath = [[NSBundle mainBundle] pathForResource:@"route_points" ofType:@"plist"];
    self.graph = [NSMutableDictionary dictionaryWithContentsOfFile:thePath];
}

- (MKPolyline*)addRoute:(CLLocation*) start toFinish:(CLLocation*) finish{
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"route_points" ofType:@"plist"];
    NSDictionary* points = [NSDictionary dictionaryWithContentsOfFile:thePath];
    NSMutableArray* pointsArray = [[NSMutableArray alloc] init];
    for(NSString* key in points)
         [pointsArray addObject:[[points objectForKey:key] objectForKey:@"coordinate"]];
    CLLocationCoordinate2D pointsInRoute[[pointsArray count]];
    for(int i = 0; i < [pointsArray count]; i++) {
        CGPoint point = CGPointFromString(pointsArray[i]);
        pointsInRoute[i] = CLLocationCoordinate2DMake(point.x,point.y);
    }
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsInRoute count:[pointsArray count]];
    return myPolyline;
}

- (int) distanceFrom:(CLLocation*) locationOfUser to:(CLLocation*) next{
    CLLocation *currentLoc = locationOfUser;
    CLLocation* distToTurn = next;
    float curLat = [self toRadians: currentLoc.coordinate.latitude];
    float turnLat = [self toRadians: distToTurn.coordinate.latitude];
    float deltaLatitude = [self toRadians:distToTurn.coordinate.latitude - currentLoc.coordinate.latitude];
    float deltaLongitude = [self toRadians:distToTurn.coordinate.longitude - currentLoc.coordinate.longitude];
    float squareHalfTheCord = pow(sinf(deltaLatitude/2),2) + cosf(curLat)*cosf(turnLat) * pow(sinf(deltaLongitude/2),2);
    float angularDistance = 2 * atan2f(sqrtf(squareHalfTheCord),sqrtf(1-squareHalfTheCord));
    return 6371 * angularDistance;
}
-(float) toRadians:(float) loc{
    return loc * (M_PI / 180);
}


-(NSMutableArray*) routeStart:(NSString*) start toFinish:(NSString*) finish{
    [self.graph objectForKey:start];
    //best first search use priorty queue
    return nil;
}

@end
