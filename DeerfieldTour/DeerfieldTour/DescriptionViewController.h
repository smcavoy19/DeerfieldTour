//
//  DescriptionViewController.h
//  DeerfieldTour
//
//  Created by smcavoy19 on 4/14/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "ViewController.h"

@interface DescriptionViewController : ViewController <UITextViewDelegate>

@property NSString* building;
@property (strong, nonatomic) IBOutlet UITextView *summary;
@property (strong, nonatomic) IBOutlet UINavigationItem *buildingHeader;

@end
