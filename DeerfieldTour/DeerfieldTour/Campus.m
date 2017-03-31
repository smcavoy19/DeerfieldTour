//
//  PVPark.m
//  Park View
//
//  Created by Cesare Rocchi on 6/19/14.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

#import "Campus.h"

@implementation Campus

- (instancetype)initWithFilename:(NSString *)filename {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];

        CGPoint mid = CGPointFromString(properties[@"mid"]);
        _midCoordinate = CLLocationCoordinate2DMake(mid.x, mid.y);
        
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"top_left"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"top_right"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"bottom_left"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
        
        CGPoint overlayBottomRightPoint = CGPointFromString(properties[@"bottom_right"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomRightPoint.x, overlayBottomRightPoint.y);
    }
    
    return self;
}

- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}

@end
