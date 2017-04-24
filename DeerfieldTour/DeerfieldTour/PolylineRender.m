//
//  PolylineRender.m
//  DeerfieldTour
//
//  Created by Yongyang Nie on 4/24/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "PolylineRender.h"

@implementation PolylineRender

- (void)applyStrokePropertiesToContext:(CGContextRef)context
                           atZoomScale:(MKZoomScale)zoomScale
{
    [super applyStrokePropertiesToContext:context atZoomScale:zoomScale];
    CGContextSetLineWidth(context, self.lineWidth);
}

@end
