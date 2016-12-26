//
//  fishAnimation.m
//  Floppy Fish
//
//  Created by Austin Nasso on 2/9/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import "fishAnimation.h"
#include <stdlib.h>

@implementation fishAnimation
@synthesize fishlocation, parentBounds, theTransform, is_alive, currentFrame, initialized, m_time, delegate, gold, silver, black;

- (void) startAnimating
{
    [super startAnimating];
    if (!delegate.gameStarted)
        [self idleAnimation];
}

- (void) bounce
{
    if (idle_y)
        idle_y = false;
    
    if (is_alive)
    {
        AudioServicesPlaySystemSound(fishBlub);
        m_time = 0;
        m_vel = 10;
        
        //WITH VIEWS

        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformRotate(self.transform, -.7);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
        
    }
}

- (double)displacement: (int) t;
{
    if (self.center.y < 0)
    {
        m_vel = 0;
        m_time = 1;
    }
    
    return (0.5)*(m_accel)*(t*t)-(m_vel*t);
}

- (void) animate
{
    cur_vel = (m_accel*m_time - m_vel);
    
    if (isAccel)
    {
        float dy = ([self displacement:m_time] - [self displacement:m_time-1]);
        self.fishlocation = self.frame.origin.y;
        self.fishlocation += dy;
        CGPoint cur_loc = CGPointMake(self.frame.origin.x, fishlocation);
        currentFrame.origin = cur_loc;
        self.frame = currentFrame;
        
        m_time++;
    }
    
    if (self.center.y > [UIScreen mainScreen].bounds.size.height - 83 || [delegate isCollision])
    {
        if (is_alive)
        {
            int i = arc4random()%2;
            SystemSoundID temp;
        
            if (i == 0)
                temp = fishDie;
        
            if (i==1)
                temp = fishDie2;
            
            
            AudioServicesPlayAlertSound(temp);
            isAccel = FALSE;
            is_alive = false;
            [self stopAnimating];
        }
    }
    
    if (!isAccel)
    {
        m_time = 0;
        fishlocation = [UIScreen mainScreen].bounds.size.height - 83;
        CGPoint cur_loc = CGPointMake(self.frame.origin.x, fishlocation);
        currentFrame.origin = cur_loc;
        [UIView animateWithDuration:2 animations:^{
            self.frame = currentFrame;
        }];
    }
}

- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image])
        [self initialize];
    
    return self;
}

- (void) initialize
{
    //Initialize sound
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"floppy fish"
                                              withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &fishBlub);
    
    //Initialize sound
    NSURL *soundDie1 = [[NSBundle mainBundle] URLForResource:@"floppy fish die1"
                                              withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundDie1, &fishDie);
    
    //Initialize sound
    NSURL *soundDie2 = [[NSBundle mainBundle] URLForResource:@"floppy fish die2"
                                               withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundDie2, &fishDie2);
    
    
    
    //physics
    m_accel = 1.45;
    m_time = 0;
    m_vel = 0;
    m_rotation = 0.7;
    
    //was initialized
    initialized = true;
    [self resetFish];
}

- (void) resetFish
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] >= 25)
        black = true;
    else
        black = false;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] >= 50)
        silver = true;
    else
        silver = false;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] >= 100)
        gold = true;
    else
        gold = false;
    
    //ivars
    idle_y = true;
    currentFrame = self.frame;
    isAccel = TRUE;
    is_alive = true;
    int random;
    
    random = arc4random()%3;
    
    
    NSArray *images;
    
    //select random fish character
    
    if (random == 0 && !silver) //BLUE
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"blue1.png"],
                  [UIImage imageNamed:@"blue2.png"],
                  nil];
        self.image = [UIImage imageNamed:@"blue1.png"];
    }
    
    if (random == 1 && !gold) //ORANGE
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"orange1.png"],
                  [UIImage imageNamed:@"orange2.png"],
                  nil];
        
        self.image = [UIImage imageNamed:@"orange1.png"];
    }
    
    if (random == 2 && !black) //GREEN
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"yosh1.png"],
                  [UIImage imageNamed:@"yosh2.png"],
                  nil];
        
        self.image = [UIImage imageNamed:@"yosh1.png"];
    }
    
    if (random == 2 && black) //GREEN UPGRADES TO BLACK
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"black1.png"],
                  [UIImage imageNamed:@"black2.png"],
                  nil];
        
        self.image = [UIImage imageNamed:@"black1.png"];
    }
    
    if (random == 0 && silver) //BLUE UPGRADES TO SILVER
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"silver1.png"],
                  [UIImage imageNamed:@"silver2.png"],
                  nil];
        self.image = [UIImage imageNamed:@"silver1.png"];
    }
    
    if (random == 1 && gold) //ORANGE GOES TO GOLD
    {
        images = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"gold1.png"],
                  [UIImage imageNamed:@"gold2.png"],
                  nil];
        self.image = [UIImage imageNamed:@"gold1.png"];
    }

        
    
    //animation
    self.animationImages = images;
    self.animationDuration = 0.2;
    [self startAnimating];
   
}

- (void) idleAnimation
{
    if (idle_y) {
        [self idleUp];
    }
}

- (void) idleUp
{
    if (idle_y){
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformMakeTranslation( 0, 8);
    }];
    
    [self performSelector:@selector(idleDown) withObject:self afterDelay:1];
    }
}

- (void) idleDown
{
    if (idle_y){
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    
    [self performSelector:@selector(idleUp) withObject:self afterDelay:1];
    }

}


- (id) initWithCoder:(NSCoder *)aCoder
{
    if(self = [super initWithCoder:aCoder])
        [self initialize];
    
    return self;
}
               
- (id) initWithFrame:(CGRect)rect
    {
        if(self = [super initWithFrame:rect])
            [self initialize];
                            
        return self;
    }

@end
