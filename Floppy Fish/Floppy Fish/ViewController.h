//
//  ViewController.h
//  Floppy Fish
//
//  Created by Austin Nasso on 2/8/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "iAd/iAd.h"
#import <GameKit/GameKit.h>
#import "fishAnimation.h"
#import "AppDelegate.h"
#import "Obstacles.h"

@class fishAnimation;
@class Obstacles;

@interface ViewController : UIViewController <GKGameCenterControllerDelegate, ADBannerViewDelegate>
{
    bool gameStarted;
    CGRect initialFishFrame;
    bool restartEnabled;
    int score_num;
    bool callOnce;
    SystemSoundID point;
    
}

@property IBOutlet fishAnimation *myFishAnimation;
@property IBOutlet UIImageView *ocean;
@property IBOutlet UILabel *score, *score_go, *high;
@property NSArray *images;
@property NSTimer *theTimer;
@property IBOutlet UIImageView *gameOver, *tap, *title_image;
@property IBOutlet UIButton *leaderboard_button;
@property IBOutlet Obstacles *foregroundView;
@property bool gameStarted, isSunset; 
@property IBOutlet UIView *darken;
@property int high_score;

- (IBAction) launchFish:(UITapGestureRecognizer *)recognizer;
- (void) stopAnimation;
- (void) startAnimation;
- (bool) isCollision;
- (IBAction)showLeader:(id)sender;
- (void) resetGameLogic;
- (void) resetGame;
- (void) initializeObjects;


@end
