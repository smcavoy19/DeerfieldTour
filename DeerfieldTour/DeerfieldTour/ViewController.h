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

#import "MapRoute.h"
#import "MapOverlay.h"
#import "MapOverlayView.h"
#import "Campus.h"
#import "BuildingAnnotationView.h"

@interface ViewController : UIViewController <MKOverlay, MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Campus *campus;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeight;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

