//
//  Obstacles.m
//  Floppy Fish
//
//  Created by Austin Nasso on 2/13/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import "Obstacles.h"

@implementation Obstacles
@synthesize isLaunchScreen, foregroundSegB, foregroundSegA, speed, distance_between, parent;

float rand_y;
float top;


- (void) initializeObstacles
{
    for (int i = 0; i < 3; i++)
    {
        if ([UIScreen mainScreen].bounds.size.height > 500)
            top = 208;
        else
            top = 160;
        rand_y = ((float)arc4random() / ARC4RANDOM_MAX) * ([[UIScreen mainScreen] bounds].size.height - 120 - top) + top;
        
        if (!parent.isSunset) //Each style
            obstacles_array[i] = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rock.png"]];
        
        if (parent.isSunset) //Each style
            obstacles_array[i] = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rock2.png"]];
        
        theFrame = obstacles_array[i].frame;
        theFrame.origin.x = 2*106*i+320;
        
        //temp test
        theFrame.origin.y = rand_y;
        obstacles_array[i].frame = theFrame;
        [self insertSubview:obstacles_array[i] atIndex:0];
        
        
        //DIFFERENTIATE STYLES... LATER USE ENUM INSTEAD OF BOOL
        if (!parent.isSunset)
            obstacles_array[i+3] = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"sunset_seaweed0000.png"]];
        
        if (parent.isSunset)
            obstacles_array[i+3] = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"seaweed20000.png"]];

        theFrame = obstacles_array[i+3].frame;
        theFrame.origin.x = 2*106*(i)+320;
        
        NSMutableArray *imgs = [[NSMutableArray alloc] init];
        
        
        NSMutableString *imgpath;
        if (!parent.isSunset)
            imgpath = [NSMutableString stringWithString: @"seaweed200"];
        
        if (parent.isSunset)
            imgpath = [NSMutableString stringWithString: @"sunset_seaweed00"];
        
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
            
            if (!parent.isSunset)
                imgpath = [NSMutableString stringWithString: @"seaweed200"];
            
            if (parent.isSunset)
                imgpath = [NSMutableString stringWithString: @"sunset_seaweed00"];
        }
        
        obstacles_array[i+3].animationImages = imgs;
        [obstacles_array[i+3] startAnimating];
        

        //temp test
        theFrame.origin.y = rand_y - theFrame.size.height - distance_between;
        obstacles_array[i+3].frame = theFrame;
        [self addSubview:obstacles_array[i+3]];
    }
}

- (void) scrollForeground
{
    if (!isLaunchScreen)
        [self scrollObstacles];
    foregroundSegA.center = CGPointMake(foregroundSegA.center.x-speed, foregroundSegA.center.y);
    if (foregroundSegA.center.x < 0)
        foregroundSegB.center = CGPointMake(foregroundSegB.center.x-speed, foregroundSegB.center.y);
    if (foregroundSegA.center.x == -320)
    {
        foregroundSegA.center = CGPointMake(640, foregroundSegB.center.y);
        UIImageView *temp = foregroundSegA;
        foregroundSegA = foregroundSegB;
        foregroundSegB = temp;
    }
}

- (void) clearObstacles
{
    for (int i = 0; i < 6; i++)
        [obstacles_array[i] removeFromSuperview];
}

- (void) scrollObstacles
{
    for (int i = 0; i < 6; i++)
    {
        theFrame = obstacles_array[i].frame;
        theFrame.origin.x = theFrame.origin.x-speed;
        obstacles_array[i].frame = theFrame;
    }
    
    if (obstacles_array[1].frame.origin.x < 0 && obstacles_array[4].frame.origin.x < 0)
    {
        rand_y = ((float)arc4random() / ARC4RANDOM_MAX) * ([[UIScreen mainScreen] bounds].size.height - 120 - top) + top;
        theFrame = obstacles_array[0].frame;
        theFrame.origin.x = 436;
        theFrame.origin.y = rand_y;
        obstacles_array[0].frame = theFrame;
        theFrame = obstacles_array[3].frame;
        theFrame.origin.x = 436;
        theFrame.origin.y = rand_y - theFrame.size.height - distance_between;
        obstacles_array[3].frame = theFrame;
    
        //Create infinte loop by switching references
        UIImageView *temp;
        temp = obstacles_array[0];
        obstacles_array[0] = obstacles_array[1];
        obstacles_array[1] = obstacles_array[2];
        obstacles_array[2] = temp;
        
        temp = obstacles_array[3];
        obstacles_array[3] = obstacles_array[4];
        obstacles_array[4] = obstacles_array[5];
        obstacles_array[5] = temp;
    }
}

- (bool) detectCollision: (UIImageView*)character
{
    for (int i = 0; i < 3; i++)
    {
        if ([self seaWeedCollision:character withSeaWeed:obstacles_array[i+3]])
        return true;
    
        if ([self rockCollision:character withRock:obstacles_array[i]])
        return true;
    }
    
    return false; 
}

- (bool) rockCollision: (UIImageView*)character withRock: (UIImageView*)rock
{
    float buffer = 14;
    
    float width, height, char_x, char_y, obs_x, obs_y, obs_width, obs_height;
    char_x = character.frame.origin.x;
    char_y = character.frame.origin.y;
    width = character.frame.size.width;
    height = character.frame.size.height;
    obs_x = rock.frame.origin.x + buffer;
    obs_y = rock.frame.origin.y + buffer;
    obs_width = rock.frame.size.width - buffer;
    obs_height = rock.frame.size.height;
    
    if (char_x + width <= (obs_x + obs_width ) && (char_x + width) >= (obs_x+17) && (char_y+height) >= obs_y-10 && (char_y+height) <= obs_y +45)
        return true;
    
    if (char_x + width <= (obs_x + obs_width) && (char_x + width) >= (obs_x) && (char_y+height) >= obs_y + 45)
        return true;
    
    return false;
}

- (bool) seaWeedCollision: (UIImageView*)character withSeaWeed: (UIImageView*)weed
{
    float buffer = 10;
    
    float width, height, char_x, char_y, obs_x, obs_y, obs_width, obs_height;
    char_x = character.frame.origin.x;
    char_y = character.frame.origin.y;
    width = character.frame.size.width;
    height = character.frame.size.height;
    obs_x = weed.frame.origin.x + buffer;
    obs_y = weed.frame.origin.y - buffer;
    obs_width = weed.frame.size.width - buffer;
    obs_height = weed.frame.size.height;
    
    //if hits seaweed
    if (char_x + width <= (obs_x + obs_width) && (char_x + width) >= obs_x && char_y <= obs_y+obs_height-30)
        return true;
    
    if (char_x + width <= (obs_x + obs_width) && (char_x + width) >= obs_x+15 && char_y <= obs_y+obs_height && char_y >= obs_y+obs_height-30)
        return true;
    
    return false;
}

- (bool) givePoint: (UIImageView*)character
{
    for (int i = 0; i < 6; i++)
    {
        if ((character.center.x >= obstacles_array[i].center.x - 2) && (character.center.x <= obstacles_array[i].center.x + 2))
            return true;
    }
    
    return false;
}

- (void) stopAnimating
{
    for (int i = 3; i < 6; i++)
        [obstacles_array[i] stopAnimating];
}


@end
