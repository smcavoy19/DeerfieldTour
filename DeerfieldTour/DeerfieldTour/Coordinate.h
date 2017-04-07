//
//  Coordinate.h
//  DeerfieldTour
//
//  Created by smcavoy19 on 4/7/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Coordinate : CLLocation

-(instancetype) init;
@property NSMutableDictionary* connectingIntersections;
@property NSString* building;

@end
