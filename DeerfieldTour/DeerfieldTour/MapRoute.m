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
        
        self.graph = [[Graph alloc] init];
        NSString* thePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithContentsOfFile:thePath];
        
        for (NSString *key in copy.allKeys) {
            Vertex *vertex = [[Vertex alloc] init];
            vertex.key = key;
            vertex.cost = INT_MAX;
            CGPoint coordinate = CGPointFromString([[copy objectForKey:key] objectForKey:@"coordinate"]);
            vertex.coordinate = [[CLLocation alloc] initWithLatitude:coordinate.x longitude:coordinate.y];
            
            NSDictionary *dic = [copy objectForKey:key];
            NSMutableDictionary *connections = [[NSMutableDictionary alloc] init];
            for (NSString *name in [dic objectForKey:@"connections"]) {
                CGPoint fromPoint = CGPointFromString([[copy objectForKey:name] objectForKey:@"coordinate"]);
                CLLocation *from = [[CLLocation alloc] initWithLatitude:fromPoint.x longitude:fromPoint.y];
                CGPoint toPoint = CGPointFromString([dic objectForKey:@"coordinate"]);
                CLLocation *to = [[CLLocation alloc] initWithLatitude:toPoint.x longitude:toPoint.y];
                
                [connections setObject:[NSNumber numberWithFloat:[self distanceFrom:from to:to]] forKey:name];
            }
            vertex.connections = connections;
            [self.graph addVertex:vertex];
        }
    }
    return self;
}

- (float) distanceFrom:(CLLocation*) locationOfUser to:(CLLocation*) next{
    
    CLLocation *currentLoc = locationOfUser;
    CLLocation* distToTurn = next;
    
    float curLat = [self toRadians: currentLoc.coordinate.latitude];
    float turnLat = [self toRadians: distToTurn.coordinate.latitude];
    
    float deltaLatitude = [self toRadians:distToTurn.coordinate.latitude - currentLoc.coordinate.latitude];
    float deltaLongitude = [self toRadians:distToTurn.coordinate.longitude - currentLoc.coordinate.longitude];
    
    float squareHalfTheCord = pow(sinf(deltaLatitude/2.0f),2.0f) + cosf(curLat)*cosf(turnLat) * pow(sinf(deltaLongitude/2),2);
    float angularDistance = 2.0f * atan2f(sqrtf(squareHalfTheCord),sqrtf(1-squareHalfTheCord));
    
    return 6371.0f * angularDistance;
}
-(float) toRadians:(float) loc{
    return loc * (M_PI / 180);
}


-(MKPolyline *) routeStart:(NSString*) start toFinish:(NSString*) finish{
    
    PQ *pq = [[PQ alloc] init];
    
    Vertex *s = [self.graph.adjacencyList objectForKey:start];
    s.cost = 0;
    for (NSString *key in [s.connections allKeys]) {
        Vertex *v = [self.graph vertextForKey:key];
        v.cost = [[s.connections objectForKey:key] intValue];
        v.previous = s;
        [pq enqueue:v];
    }
    
    while (![pq isEmpty]) {
        Vertex *v = [pq dequeue];
        for (NSString *key in [v.connections allKeys]) {
            Vertex *vertex = [self.graph vertextForKey:key];
            if (vertex.cost >  v.cost + [[v.connections objectForKey:key] intValue]){
                vertex.cost = v.cost + [[v.connections objectForKey:key] intValue];
                vertex.previous = v;
                [pq enqueue:vertex];
            }
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    Vertex *e = [self.graph.adjacencyList objectForKey:finish];
    [array addObject:e.coordinate];
    NSLog(@"%@", e.key);
    while (e.previous) {
        e = e.previous;
        [array addObject:e.coordinate];
        NSLog(@"%@", e.key);
        
    }
    CLLocationCoordinate2D pointsInRoute[[array count]];
    for(int i = 0; i < [array count]; i++) {
        pointsInRoute[i] = [(CLLocation *)[array objectAtIndex:i] coordinate];
    }
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsInRoute count:[array count]];
    
    return myPolyline;
}

@end
