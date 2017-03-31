//
//  ViewController.m
//  DeerfieldTour
//
//  Created by smcavoy19 on 3/28/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Map View delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:MapOverlay.class]) {
        MapOverlayView *overlayView = [[MapOverlayView alloc] initWithOverlay:overlay overlayImage:[UIImage imageNamed:@"map.png"]];

        return overlayView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    return nil;
}

- (void)viewDidLoad {
    
    CLLocationDegrees lat = 42.54444;
    CLLocationDegrees lon =  -72.60611;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    
    //Create a region with a 1000x1000 meter around the user location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    CLLocationDegrees deltaLatitude = viewRegion.span.latitudeDelta;
    CLLocationDegrees deltaLongitude = viewRegion.span.longitudeDelta;
    CGFloat latitudeCircumference = 40075160 * cos(self.mapView.region.center.latitude * M_PI / 180);
    NSLog(@"x: %f; y: %f", deltaLongitude * latitudeCircumference / 360, deltaLatitude * 40008000 / 360);
    
    [self.mapView setRegion:viewRegion];
    
    self.campus = [[Campus alloc] initWithFilename:@"boundaries"];
    MapOverlay *overlay = [[MapOverlay alloc] initWithPark:self.campus];
    [self.mapView addOverlay:overlay];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically fro
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
