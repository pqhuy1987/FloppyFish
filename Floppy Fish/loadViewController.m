//
//  loadViewController.m
//  Floppy Fish
//
//  Created by Austin Nasso on 3/7/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import "loadViewController.h"

@interface loadViewController ()

@end

@implementation loadViewController

@synthesize mapToLoad, loading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initializeAnimations
{
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (int i = 1; i < 5; i++)
        [imgs addObject: [UIImage imageNamed:[NSString stringWithFormat: @"loading%d.png", i]]];
    loading.animationImages = imgs;
    loading.animationDuration = 1;
    [loading startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeAnimations];
    
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    
    ViewController *myViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Gameplay"];
    if (mapToLoad == normal_map)
        myViewController.isSunset = false;
    if (mapToLoad == sunset_map)
        myViewController.isSunset = true;
    [self presentViewController:myViewController animated:YES completion:nil];
    [myViewController initializeObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
