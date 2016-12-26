//
//  Obstacles.h
//  Floppy Fish
//
//  Created by Austin Nasso on 2/13/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fishAnimation.h"
#import "ViewController.h"
#define ARC4RANDOM_MAX 0x100000000

@interface Obstacles : UIImageView
{
    UIImageView *obstacles_array[6];
    CGRect theFrame;
}

@property bool isLaunchScreen;
@property IBOutlet UIImageView *foregroundSegA, *foregroundSegB;
@property int speed;
@property float distance_between;
@property ViewController *parent;

- (void) initializeObstacles;
- (void) scrollForeground;
- (void) clearObstacles;
- (bool) detectCollision: (UIImageView*)character;
- (bool) givePoint: (UIImageView*)character;
- (void) stopAnimating;

@end
