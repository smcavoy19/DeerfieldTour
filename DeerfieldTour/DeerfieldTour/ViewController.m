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
#import "DescriptionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize coordinate;
@synthesize boundingMapRect;

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.buildings objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buildings.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"You are close to:";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]){
        DescriptionViewController *descriptionView = [segue destinationViewController];
        descriptionView.building = sender;
    }
}


#pragma mark - Location Manager

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
    
    self.currentLocation= locations.lastObject;
    
    if (self.tableHeight.constant == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.tableHeight.constant = 130;
                [self.view layoutIfNeeded];
            }];
        });
    }
    
    CLLocation *currentLoc = [locations lastObject];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"building_coordinates" ofType:@"plist"];
    
    for (NSDictionary *dic in [NSArray arrayWithContentsOfFile:filePath]) {
        CGPoint point = CGPointFromString(dic[@"location"]);
        float dist = [self dist:CGPointMake((float)currentLoc.coordinate.latitude, (float)currentLoc.coordinate.longitude) b:point];
        if (dist < 0.0005) {
            if (![self.buildings containsObject:[dic objectForKey:@"title"]]) {
                [self.buildings addObject:[dic objectForKey:@"title"]];
                [self.table reloadData];
            }
        }else if (dist > 0.0005){
            if ([self.buildings containsObject:[dic objectForKey:@"title"]]) {
                [self.buildings removeObject:[dic objectForKey:@"title"]];
                [self.table reloadData];
            }
        }
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
- (IBAction)segmentSelected:(id)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.vicinityTable.hidden = NO;
        self.startTextfield.hidden = YES;
        self.endTextField.hidden = YES;
        self.directionButton.hidden = YES;
        self.mapTypeSegmentedControl.hidden = YES;
    }else if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.vicinityTable.hidden = YES;
        self.startTextfield.hidden = NO;
        self.endTextField.hidden = NO;
        self.directionButton.hidden = NO;
        self.mapTypeSegmentedControl.hidden = YES;
    }else{
        self.vicinityTable.hidden = YES;
        self.startTextfield.hidden = YES;
        self.endTextField.hidden = YES;
        self.directionButton.hidden = YES;
        self.mapTypeSegmentedControl.hidden = NO;
    }
}
- (IBAction)findDirection:(id)sender {
    [self clearPolyline];
    MapRoute* mapRoute = [[MapRoute alloc] initWithFilename:@"route_points"];
    MKPolyline *route = [mapRoute routeStart:self.startTextfield.text toFinish:self.endTextField.text];
    [self.mapView addOverlay:route];
}

-(void)clearPolyline{
    for (MapOverlay *overlay in self.mapView.overlays) {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            [self.mapView removeOverlay:overlay];
        }
    }
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(c, 500, 500);
    
    [self.mapView setRegion:viewRegion];
    
    self.campus = [[Campus alloc] initWithFilename:@"boundaries"];
    MapOverlay *overlay = [[MapOverlay alloc] initWithPark:self.campus];
    [self.mapView addOverlay:overlay];
    
    [self addBuildingPins];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    self.buildings = [NSMutableArray array];
    
    [self segmentSelected:nil];
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
