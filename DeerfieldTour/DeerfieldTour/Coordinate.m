//
//  Coordinate.m
//  DeerfieldTour
//
//  Created by smcavoy19 on 4/7/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

-(instancetype) init{
    self = [super init];
    if(self){
        self.connectingIntersections = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
