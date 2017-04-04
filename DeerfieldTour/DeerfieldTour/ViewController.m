//
//  ViewController.m
//  DeerfieldTour
//
//  Created by smcavoy19 on 3/28/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapRoute.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize coordinate;
@synthesize boundingMapRect;

#pragma mark - Private

-(void)setShadowforView:(UIView *)view masksToBounds:(BOOL)masksToBounds{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = masksToBounds;
}

- (void)addBuildingPins {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"building_coordinates" ofType:@"plist"];
    NSArray *attractions = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *attraction in attractions) {
        BuildingAnnotation *annotation = [[BuildingAnnotation alloc] init];
        CGPoint point = CGPointFromString(attraction[@"location"]);
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title = attraction[@"name"];
        annotation.info = attraction[@"info"];
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - IBActions

- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (IBAction)showMenu:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuHeight.constant = 85;
            self.menuView.alpha = 1.0;
            [self.view layoutIfNeeded];
        }];
    });
}

- (IBAction)closeMenu:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuHeight.constant = -30;
            self.menuView.alpha = 0.0;
            [self.view layoutIfNeeded];
        }];
    });
}

#pragma mark - Map View delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:MapOverlay.class]) {
        MapOverlayView *overlayView = [[MapOverlayView alloc] initWithOverlay:overlay overlayImage:[UIImage imageNamed:@"map.png"]];

        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor redColor];
        lineView.lineWidth = 1.0;
        
        return lineView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    BuildingAnnotationView *annotationView = [[BuildingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"building"];
    annotationView.canShowCallout = YES;
    return annotationView;
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    CLLocationDegrees lat = 42.54444;
    CLLocationDegrees lon =  -72.60611;
    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
    
    //Create a region with a 1000x1000 meter around the user location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(c, 500, 500);
    CLLocationDegrees deltaLatitude = viewRegion.span.latitudeDelta;
    CLLocationDegrees deltaLongitude = viewRegion.span.longitudeDelta;
    CGFloat latitudeCircumference = 40075160 * cos(self.mapView.region.center.latitude * M_PI / 180);
    NSLog(@"x: %f; y: %f", deltaLongitude * latitudeCircumference / 360, deltaLatitude * 40008000 / 360);
    
    [self.mapView setRegion:viewRegion];
    
    self.campus = [[Campus alloc] initWithFilename:@"boundaries"];
    MapOverlay *overlay = [[MapOverlay alloc] initWithPark:self.campus];
    [self.mapView addOverlay:overlay];
    
    MapRoute* mapRoute = [[MapRoute alloc] init];
    [self.mapView addOverlay:[mapRoute addRoute]];

    [self addBuildingPins];
    [self setShadowforView:self.menuView masksToBounds:NO];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager stopUpdatingLocation];
    
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
