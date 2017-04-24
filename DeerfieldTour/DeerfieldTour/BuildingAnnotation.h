//
//  DABuildingAnnotation.h
//  DeerfieldTour
//
//  Created by Yongyang Nie on 4/3/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BuildingAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
