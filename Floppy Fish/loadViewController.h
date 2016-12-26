//
//  loadViewController.h
//  Floppy Fish
//
//  Created by Austin Nasso on 3/7/14.
//  Copyright (c) 2014 Austin Nasso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

typedef enum{normal_map, sunset_map} mapName;

@interface loadViewController : UIViewController

@property mapName mapToLoad;
@property IBOutlet UIImageView *loading;

@end
