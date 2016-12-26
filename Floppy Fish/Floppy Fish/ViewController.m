//
//  ViewController.m
//  Floppy Fish
//
//  Created by Austin Nasso on 2/8/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize myFishAnimation, images, theTimer, ocean, score, gameOver, tap, gameStarted, foregroundView, darken, score_go, high, high_score, leaderboard_button, isSunset, title_image;


//POOR DESIGN
- (void) translateViewGameOver;
{
        static int x = 0;
        gameOver.center = CGPointMake(gameOver.center.x, gameOver.center.y - 300);
        leaderboard_button.center = CGPointMake(leaderboard_button.center.x, leaderboard_button.center.y - 300);
        x++;
        
        NSLog(@"%d times", x);
}

- (void) translateViewTitle;
{
        title_image.center = CGPointMake(title_image.center.x, -title_image.frame.size.height/2);
}


- (bool) isCollision
{
    return [foregroundView detectCollision:myFishAnimation];
}

- (IBAction) launchFish:(UITapGestureRecognizer *)recognizer
{
    if (restartEnabled)
    {
    if (!gameStarted)
    {
        gameStarted = true;
        foregroundView.isLaunchScreen = false; 
        [UIView animateWithDuration:0.75 animations:^{
            title_image.alpha = 0;
            tap.alpha = 0;
            score.alpha = 1.0;
        }];
        [self performSelector:@selector(translateViewTitle) withObject:self afterDelay:0.75];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [myFishAnimation bounce];
    }
    
    if (!myFishAnimation.is_alive && gameOver.alpha == 1)
    {
        //RESET GAME
        title_image.alpha = 1.0;
        [UIView animateWithDuration:1 animations:^{
            darken.alpha = 0;
            gameOver.alpha = 0;
            leaderboard_button.alpha = 0;
            tap.alpha = 1.0;
            title_image.center = CGPointMake(title_image.center.x, title_image.frame.size.height-35);
         }];
        [self performSelector:@selector(translateViewGameOver) withObject:self afterDelay:1];

        [self stopAnimation];
        [self resetGameLogic];
    }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Configure for game center
    [self configureAll];
}

- (void) configureAll
{
    //Configure for advertisements
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.delegate = self; 
    [self.view addSubview:adView];
    
    AppDelegate *appdel = [[UIApplication sharedApplication] delegate];
    appdel.myController = self;
    myFishAnimation.delegate = self;
    [self.gameOver setImage:[UIImage imageNamed:@"gameover.png"]];
    foregroundView.distance_between = 90;
    foregroundView.parent = self;
    
    //ADJUST FOR SMALLER PHONE
    if ([UIScreen mainScreen].bounds.size.height < 500)
    {
        CGRect frame_temp = gameOver.frame;
        frame_temp.origin = CGPointMake(frame_temp.origin.x, frame_temp.origin.y - 60);
        gameOver.frame = frame_temp;
        frame_temp = leaderboard_button.frame;
        frame_temp.origin = CGPointMake(frame_temp.origin.x, frame_temp.origin.y - 10);
        leaderboard_button.frame = frame_temp;
    }
}


- (void) resetGameLogic
{
    [self authenticateLocalPlayer];
    if ([GKLocalPlayer localPlayer].authenticated)
        [self loadAchievements];
    gameStarted = false;
    callOnce = true;
    score.alpha = 0;
    score.text = @"0";
    score_num = 0;
    foregroundView.isLaunchScreen = true;
    [foregroundView clearObstacles];
    //SET INITIAL POSITION
    myFishAnimation.frame = initialFishFrame;
    myFishAnimation.parentBounds = [[UIScreen mainScreen] bounds];
    [myFishAnimation resetFish];
    [foregroundView initializeObstacles];
    [self startAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeObjects
{
    restartEnabled = true;
    [self.view setMultipleTouchEnabled:YES];
    initialFishFrame = myFishAnimation.frame;
    CGPoint fish_loc = CGPointMake(60, 270);
    initialFishFrame.origin = fish_loc;
    
    //Initialize point noise
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"point"
                                              withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &point);
    
    //SET HIGH SCORE VALUE
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"] == nil)
        high_score = 0;
    else
        high_score = [[NSUserDefaults standardUserDefaults] integerForKey: @"highScore"];
    
    //TAP FISH TO BLUB
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchFish:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //CREATE BACKGROUND IMAGE ANIMATION
    ocean = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.jpg"]];
    CGRect newFrame;
    newFrame.origin.x = 0;
    newFrame.origin.y = 0;
    newFrame.size.height = [UIScreen mainScreen].bounds.size.height;
    newFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    ocean.frame = newFrame;
    NSMutableArray *bgimgs = [[NSMutableArray alloc] init];
    NSMutableString *imgpath;
    if (!isSunset)
        imgpath = [NSMutableString stringWithString: @"ocean00"];
    
    if (isSunset)
        imgpath = [NSMutableString stringWithString: @"sunset_ocean00"];
    
    NSString *path;
    int img_num = 65;
    for (int i = 0; i < img_num; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%i", i];
        if (i < 10)
            [imgpath appendString:@"0"];
        [imgpath appendString:num];
        path = [[NSBundle mainBundle] pathForResource:imgpath ofType:@"jpg"];
        [bgimgs addObject:[UIImage imageWithContentsOfFile: path]];
        if (!isSunset)
            imgpath = [NSMutableString stringWithString: @"ocean00"];
        
        if (isSunset)
            imgpath = [NSMutableString stringWithString: @"sunset_ocean00"];
    }
    
    for (int i = img_num; i >= 0; i--)
    {
        NSString *num = [NSString stringWithFormat:@"%i", i];
        if (i < 10)
            [imgpath appendString:@"0"];
        [imgpath appendString:num];
        path = [[NSBundle mainBundle] pathForResource:imgpath ofType:@"jpg"];
        [bgimgs addObject:[UIImage imageWithContentsOfFile:path]];
        if (!isSunset)
            imgpath = [NSMutableString stringWithString: @"ocean00"];
        
        if (isSunset)
            imgpath = [NSMutableString stringWithString: @"sunset_ocean00"];
    }
    
    ocean.animationImages = bgimgs;
    ocean.animationDuration = 4.5;
    [self.view insertSubview:ocean belowSubview:foregroundView];
    [ocean startAnimating];
    
    
    //RESET GAME LOGIC
    [self resetGameLogic];
}

- (void) scrollForegroundwithSpeed: (int) x;
{
    if (myFishAnimation.is_alive)
        [foregroundView scrollForeground];
    
    foregroundView.speed = x;
}


- (void) animateFish
{
    //SCROLL GAME
    [self scrollForegroundwithSpeed:5];
    
    //ANIMATE FISH WHEN GAME STARTS
    if (gameStarted)
    {
        [myFishAnimation animate];
        if ([foregroundView givePoint:myFishAnimation] && myFishAnimation.is_alive)
        {
            AudioServicesPlaySystemSound(point);
            if (score_num<=9999)
                score_num++;
            score.text = [NSString stringWithFormat:@"%d", score_num];
        }
    }
    
    if (!myFishAnimation.is_alive)
    {
        if (callOnce)
        {
            score.alpha = 0;
            score_go.text = score.text;
            if (score_num > high_score)
            {
                high_score = score_num;
                [self completeMultipleAchievements];
                [self saveScore:high_score];
            }
            
            high.text = [NSString stringWithFormat:@"%d", high_score];
            restartEnabled = false;
            gameOver.alpha = 1.0;
            leaderboard_button.alpha = 1.0;
            [UIView animateWithDuration:2.0 animations:^{
                gameOver.center = CGPointMake (gameOver.center.x, gameOver.center.y + 300);
                leaderboard_button.center = CGPointMake (leaderboard_button.center.x, leaderboard_button.center.y + 300);
                darken.alpha = 0.6;
            }];
        
            [self performSelector:@selector(enableRestart) withObject:self afterDelay:2.0];
            callOnce = false;
        }
    }

}

- (void) enableRestart
{
    restartEnabled = true;
}

- (void) stopAnimation
{
    [theTimer invalidate];
}

- (void) startAnimation
{
    [self initializeTimer];
}

- (void) initializeTimer
{
    float theInterval = 1.0f/30.0f;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target:self selector:@selector(animateFish) userInfo:nil repeats:YES];
}

//CALLED BY APP DELEGATE TO MOVE ITEMS INTO PLACE AND RESET GAME
- (void) resetGame
{
    CGRect frame = gameOver.frame;
    frame.origin.y = -210;
    gameOver.frame = frame;
    frame = leaderboard_button.frame;
    frame.origin.y = -55;
    leaderboard_button.frame = frame;
    darken.alpha = 0;
    tap.alpha = 1.0;
    [self resetGameLogic];
}

//SAVE HIGH SCORE LOCALLY
-(void)saveScore: (int) x {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:x forKey:@"highScore"];
    [defaults synchronize];
    [self reportScores];
}

//LEADERBOARD
- (void) reportScores
{
    if ([GKLocalPlayer localPlayer].isAuthenticated)
        [self reportScore:high_score forLeaderboardID:@"Floppy_Fish_V1"];
}

- (void) reportScore: (int64_t) num forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = num;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            //Do something interesting here.
        }];

    } else {
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            // Do something interesting here.
        }];
        // Load resources for iOS 7 or later
    }
}

//SHOW LEADERBOARD
-(void)displayLeaderBoard:(NSString *)name
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardController != NULL)
        {
            if (name != nil) {//keep category nil and let user see default
                leaderboardController.category = name;
            }
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            [self presentViewController:leaderboardController animated:true completion:nil];
        }
   
    }
    
    else
    {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardCategory = name;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)leaderboardController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//BUTTON CONTROL
- (IBAction)showLeader:(id)sender
{
    [self displayLeaderBoard:@"Floppy_Fish_V1"];
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *vc, NSError *error){
        if (vc != nil)
        {
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            [self presentViewController:vc animated:YES completion:nil];
            NSLog(@"CALLED");
        }
        
       else
           return;
    };
}

//------------ ACHIEVEMENTS -------------
- (void) completeMultipleAchievements
{
    if ([GKLocalPlayer localPlayer].isAuthenticated)
    {
        
        NSLog(@"%d", high_score);
        GKAchievement *achievement1 = [[GKAchievement alloc] initWithIdentifier: @"silver_fish"];
        GKAchievement *achievement2 = [[GKAchievement alloc] initWithIdentifier: @"100p"];
        GKAchievement *achievement3 = [[GKAchievement alloc] initWithIdentifier: @"black_fish"];
        if (high_score < 25)
            achievement1.percentComplete = ((float)high_score/ 25.0)*100;
        
        if (high_score < 50)
            achievement1.percentComplete = ((float)high_score/ 50.0)*100;
    
        if (high_score < 100)
            achievement2.percentComplete = ((float)high_score/ 100.0)*100;
        
        if (high_score >= 25)
        {
            achievement3.percentComplete = 100;
        }
        
        if (high_score >= 50)
        {
            achievement1.percentComplete = 100;
        }
        
        if (high_score >= 100)
        {
             achievement2.percentComplete = 100;
        }
    
        NSArray *achievementsToComplete = [NSArray arrayWithObjects:achievement1,achievement2, achievement3, nil];
        [GKAchievement reportAchievements: achievementsToComplete withCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

- (void) loadAchievements
{    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
    if (error != nil)
    {
        // Handle the error.
    }
    if (achievements != nil)
    {
        // Process the array of achievements.
    }
}];
}

//-------iAd Protocol Functions
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    banner.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    banner.hidden = YES;
}

@end
