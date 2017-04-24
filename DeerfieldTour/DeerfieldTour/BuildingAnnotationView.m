//
//  BuildingAnnotationView.m
//  DeerfieldTour
//
//  Created by Yongyang Nie on 4/3/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "BuildingAnnotationView.h"

@implementation BuildingAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"pin"];
    }
    return self;
}

@end
