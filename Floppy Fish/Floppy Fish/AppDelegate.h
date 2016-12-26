//
//  AppDelegate.h
//  Floppy Fish
//
//  Created by Austin Nasso on 2/8/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet ViewController *myController;

@end
