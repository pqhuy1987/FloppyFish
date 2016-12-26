//
//  fishAnimation.h
//  Floppy Fish
//
//  Created by Austin Nasso on 2/9/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@class ViewController;

@interface fishAnimation : UIImageView
{
    @protected
    float m_accel, m_rotation, m_vel, cur_vel, m_radian;
    BOOL isAccel;
    BOOL idle_y;
    SystemSoundID fishBlub, fishDie, fishDie2;
}

@property CGFloat fishlocation;
@property CGRect parentBounds, currentFrame;
@property CGAffineTransform theTransform;
@property bool is_alive, gold, silver, black;
@property bool initialized;
@property int m_time;
@property ViewController *delegate;

- (void) resetFish;
- (void) bounce;
- (void) animate;
- (void) initialize;
- (double) displacement: (int) t;
@end
