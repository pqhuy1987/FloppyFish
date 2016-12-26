//
//  MenuController.m
//  Floppy Fish
//
//  Created by Austin Nasso on 2/16/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import "MenuController.h"

@implementation MenuController
@synthesize s1, s2, normal, sunset;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initializeAnimations];
}

- (void) initializeAnimations
{
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    NSMutableString *imgpath = [NSMutableString stringWithString: @"seaweed200"];
    NSString *png = @".png";
    int img_num = 70;
    for (int i = 0; i < img_num; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%i", i];
        if (i < 10)
            [imgpath appendString:@"0"];
        [imgpath appendString:num];
        [imgpath appendString:png];
        [imgs addObject:[UIImage imageNamed:imgpath]];
        imgpath = [NSMutableString stringWithString: @"seaweed200"];
    }
    
    s1.animationImages = imgs;
    s2.animationImages = imgs;
    s1.animationDuration = 3;
    s2.animationDuration = 3;
    [s1 startAnimating];
    [s2 startAnimating];
}

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     loadViewController *myController = segue.destinationViewController;
     if ([segue.identifier isEqualToString:@"Normal"])
     {
         myController.mapToLoad = normal_map;
     }
     
     if([segue.identifier isEqualToString:@"Sunset"])
     {
         myController.mapToLoad = sunset_map;
     }
 }

@end