//
//  MapOverlay.m
//  DeerfieldTour
//
//  Created by Yongyang Nie on 3/29/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "MapOverlayView.h"
#import "MapOverlay.h"

@implementation MapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(Campus *)campus {
    self = [super init];
    if (self) {
        boundingMapRect = campus.overlayBoundingMapRect;
        coordinate = campus.midCoordinate;
    }
    
    return self;
}

@end
