//
//  DescriptionViewController.m
//  DeerfieldTour
//
//  Created by smcavoy19 on 4/14/17.
//  Copyright © 2017 smcavoy19. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

@synthesize buildingHeader;

-(void)viewWillAppear:(BOOL)animated {
    [self.buildingHeader setTitle: self.building];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* filename = @"building_summaries";
    NSString* thePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithContentsOfFile:thePath];
    [[self summary] setText: [copy objectForKey:self.building]];
    NSString* nameOfImage = [NSString stringWithFormat:@"%@.png",self.building];
    UIImage *image = [UIImage imageNamed: @"Main School Building.png"];
    [self.imageView setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
