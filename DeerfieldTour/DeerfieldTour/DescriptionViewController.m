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
    UIImage *image = [UIImage imageNamed: @"Main School Building.png"];
    [self.imageView setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
