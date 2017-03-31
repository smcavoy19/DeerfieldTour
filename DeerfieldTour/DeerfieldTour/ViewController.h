//
//  ViewController.h
//  DeerfieldTour
//
//  Created by smcavoy19 on 3/28/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapOverlay.h"
#import "MapOverlayView.h"
#import "Campus.h"

@interface ViewController : UIViewController <MKOverlay, MKMapViewDelegate>

@property (strong, nonatomic) Campus *campus;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

