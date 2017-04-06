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

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"There is an error retrieving your location" message:@"Please try again later" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    NSLog(@"%@", error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLoc = [locations lastObject];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"building_coordinates" ofType:@"plist"];
    NSDictionary *first = [NSArray arrayWithContentsOfFile:filePath].firstObject;
    CGPoint point = CGPointFromString(first[@"location"]);
    float dist = [self dist:CGPointMake((float)currentLoc.coordinate.latitude, (float)currentLoc.coordinate.longitude) b:point];
    if (dist < 0.0005) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome to the dinning hall!" message:@"You location indicates that you are close to the dinning hall" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

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
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CGPoint point = CGPointFromString(attraction[@"location"]);
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title = annotation.title = attraction[@"name"];
        
        [self.mapView addAnnotation:annotation];
    }
}

-(float)dist:(CGPoint)a b:(CGPoint)b{
    return sqrtf(powf(a.x-b.x, 2.0) + powf(a.y-b.y, 2.0));
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:MapOverlay.class]) {
        MapOverlayView *overlayView = [[MapOverlayView alloc] initWithOverlay:overlay overlayImage:[UIImage imageNamed:@"map copy.png"]];

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

    if (annotation == mapView.userLocation) return nil;
    BuildingAnnotationView *annotationView = [[BuildingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"building"];
    annotationView.canShowCallout = YES;
    return annotationView;
    return nil;
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
    
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
