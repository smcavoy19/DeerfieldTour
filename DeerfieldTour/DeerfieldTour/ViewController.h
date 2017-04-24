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

@interface ViewController : UIViewController <MKOverlay, MKMapViewDelegate, CLLocationManagerDelegate, MKAnnotation, UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Campus *campus;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UITableView *vicinityTable;
@property (weak, nonatomic) IBOutlet UITextField *startTextfield;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;


@end

