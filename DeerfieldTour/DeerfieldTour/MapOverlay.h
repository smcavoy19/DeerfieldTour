//
//  MapOverlay.h
//  DeerfieldTour
//
//  Created by Yongyang Nie on 3/29/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Campus.h"

@interface MapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(Campus *)park;

@end
